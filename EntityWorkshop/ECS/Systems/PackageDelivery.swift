//
//  PackageDelivery.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

final class PackageDelivery: System {
    static var dependencies: [SystemDependency] {
        [.before(PathWalking.self), .after(PackagePickup.self)]
    }

    static let query = EntityQuery(where:
        (.has(HasPackagesComponent.self) || .has(RequiresPackagesComponent.self))
            && .has(BoardPositionComponent.self)
    )

    var lastTicked: Date?

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        let allEnts = context.entities(matching: Self.query, updatingSystemWhen: .rendering)
        /// Separate require vs carrying packages
        let requiresPackageEnts = allEnts.filter { $0.requiresPackagesComp != nil }
        let carryingPackageEnts = allEnts.filter { $0.hasPackagesComp != nil && $0.name == "Vehicle" }

        if requiresPackageEnts.count == 0 {
            return
        }

        let requirePoint2Ent = requiresPackageEnts.reduce(into: [Point2D: Entity]()) { result, entity in
            let point = Point2D(row: entity.boardPositionComp!.row, col: entity.boardPositionComp!.col)
            result[point] = entity
        }

        /// Complete Deliveries
        for carryingEnt in carryingPackageEnts {
            guard !LOCKED_PATH_PHASES.contains(carryingEnt.pathComp!.phase) && carryingEnt.hasPackagesComp!.numPackages > 0 else {
                continue
            }

            let carryingPoint = Point2D(row: carryingEnt.boardPositionComp!.row, col: carryingEnt.boardPositionComp!.col)

            Task {
                /// Lock carryingEnt movement
                let prevPhase = carryingEnt.pathComp!.phase
                carryingEnt.pathComp!.phase = .locked

                for neighborPoint in Point2D.getNeighbors(for: carryingPoint, boardSize: GlobalGameState.shared.boardSize) {
                    if let requireEnt = requirePoint2Ent[neighborPoint] {
                        if requireEnt.requiresPackagesComp!.numPackages == 0 { continue }

                        let dropoffAmount = min(requireEnt.requiresPackagesComp!.numPackages, carryingEnt.hasPackagesComp!.numPackages)

                        requireEnt.requiresPackagesComp!.numPackages -= dropoffAmount
                        carryingEnt.hasPackagesComp!.numPackages -= dropoffAmount

                        /// Animate Package Dropoff
                        try! await Task.sleep(nanoseconds: sec2nanosec(0.3))
                    }
                }

                /// Unlock carryingEnt movement
                carryingEnt.pathComp!.phase = LOCKED_PATH_PHASES.contains(prevPhase) ? .moving : prevPhase
            }
        }

        /// Increment time
        if lastTicked == nil || Date().timeIntervalSince(lastTicked!) >= 1 {
            for requireEnt in requiresPackageEnts {
                if requireEnt.requiresPackagesComp == nil || requireEnt.requiresPackagesComp!.numPackages <= 0 {
                    continue
                }
                requireEnt.requiresPackagesComp?.secsRemaining -= 1
            }

            lastTicked = Date()
        }
    }
}
