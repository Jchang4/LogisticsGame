//
//  PackagePickup.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

final class PackagePickup: System {
    static var dependencies: [SystemDependency] {
        [.before(PathWalking.self), .before(PackageDelivery.self)]
    }

    static let query = EntityQuery(where: .has(HasPackagesComponent.self) && .has(BoardPositionComponent.self))

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        let allEnts = context.entities(matching: Self.query, updatingSystemWhen: .rendering)
        let vehicles = allEnts.filter { $0.name == "Vehicle" }
        let warehouses = allEnts.filter { $0.name == "Warehouse" }

        let point2warehouse = warehouses.reduce(into: [Point2D: Entity]()) { result, warehouse in
            let point = Point2D(row: warehouse.boardPositionComp!.row, col: warehouse.boardPositionComp!.col)
            result[point] = warehouse
        }

        for vehicle in vehicles {
            guard !LOCKED_PATH_PHASES.contains(vehicle.pathComp!.phase) && vehicle.hasPackagesComp!.numPackages < vehicle.hasPackagesComp!.carryingCapacity else {
                continue
            }

            let vehiclePoint = Point2D(
                row: vehicle.boardPositionComp!.row,
                col: vehicle.boardPositionComp!.col
            )

            Task {
                /// Lock vehicle movement
                let prevPhase = vehicle.pathComp!.phase

                for neighbor in Point2D.getNeighbors(for: vehiclePoint, boardSize: GlobalGameState.shared.boardSize) {
                    if let warehouse = point2warehouse[neighbor] {
                        if warehouse.hasPackagesComp!.numPackages > 0 && vehicle.hasPackagesComp!.numPackages < vehicle.hasPackagesComp!.carryingCapacity {
                            vehicle.pathComp!.phase = .locked

                            let pickupAmount = min(
                                warehouse.hasPackagesComp!.numPackages,
                                vehicle.hasPackagesComp!.carryingCapacity - vehicle.hasPackagesComp!.numPackages
                            )

                            warehouse.hasPackagesComp!.numPackages -= pickupAmount
                            vehicle.hasPackagesComp!.numPackages += pickupAmount

                            /// Animate Pickup
                            try! await Task.sleep(nanoseconds: sec2nanosec(0.3))
                        }
                    }
                }

                /// Unlock vehicle movement
                vehicle.pathComp!.phase = LOCKED_PATH_PHASES.contains(prevPhase) ? .moving : prevPhase
            }
        }
    }
}
