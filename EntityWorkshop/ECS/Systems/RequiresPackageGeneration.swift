//
//  RequiresPackageGeneration.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

final class RequiresPackageGeneration: System {
    static var dependencies: [SystemDependency] {
        [.after(PackagePickup.self), .after(PackageDelivery.self), .after(PathWalking.self)]
    }

    static let query = EntityQuery(where: .has(BuildingComponent.self))
    static let vehicleQuery = EntityQuery(where: .has(VehicleComponent.self))

    static let minPctBuildingsWithPackages: Double = 0.25

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        let vehicleNeighborPoints = Set(
            context.entities(matching: Self.vehicleQuery, updatingSystemWhen: .rendering)
                .map { Point2D(
                    row: $0.boardPositionComp!.row,
                    col: $0.boardPositionComp!.col
                ) }
                .flatMap { Point2D.getNeighbors(for: $0, boardSize: GlobalGameState.shared.boardSize) }
        )

        let allBuildings = Array(context.entities(matching: Self.query, updatingSystemWhen: .rendering))
        let buildingsWithPackages = allBuildings.filter { $0.requiresPackagesComp!.numPackages > 0 }

        let pctBuildingsWithPackages = Double(buildingsWithPackages.count) / Double(allBuildings.count)

        if pctBuildingsWithPackages < Self.minPctBuildingsWithPackages {
            let numPackagesToGenerate = Int((Self.minPctBuildingsWithPackages - pctBuildingsWithPackages) * Double(allBuildings.count))
            let buildingsNoPackages = allBuildings.filter { $0.requiresPackagesComp!.numPackages <= 0 }.shuffled()

            var numGenerated = 0

            for building in buildingsNoPackages {
                let buildingPoint = Point2D(row: building.boardPositionComp!.row, col: building.boardPositionComp!.col)
                if vehicleNeighborPoints.contains(buildingPoint) { continue }

                if numGenerated >= numPackagesToGenerate { break }

                building.requiresPackagesComp!.reset()
                building.requiresPackagesComp!.numPackages = 1
                numGenerated += 1
            }
        }
    }
}
