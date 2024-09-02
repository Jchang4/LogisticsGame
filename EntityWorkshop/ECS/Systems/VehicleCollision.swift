//
//  VehicleCollision.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

final class VehicleCollision: System {
    static var dependencies: [SystemDependency] {
        [.before(PathWalking.self)]
    }

    static let query = EntityQuery(where: .has(VehicleComponent.self))

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        let point2Vehicle = context
            .entities(matching: Self.query, updatingSystemWhen: .rendering)
            .reduce(into: [Point2D: Entity]()) { result, vehicle in
                let point = Point2D(row: vehicle.boardPositionComp!.row, col: vehicle.boardPositionComp!.col)
                result[point] = vehicle
            }
        let vehicle2NextPoint = point2Vehicle
            .values
            .reduce(into: [Entity: Point2D]()) { result, vehicle in
                let point = Point2D(row: vehicle.boardPositionComp!.row, col: vehicle.boardPositionComp!.col)
                if let pathIndex = vehicle.pathComp!.path?.firstIndex(where: { $0 == point }) {
                    if pathIndex != vehicle.pathComp!.path!.count - 1, let nextPoint = vehicle.pathComp!.path?[pathIndex + 1] {
                        result[vehicle] = nextPoint
                    }
                }
            }

        for vehicle in point2Vehicle.values {
            guard !LOCKED_PATH_PHASES.contains(vehicle.pathComp!.phase) &&
                vehicle.pathComp!.path != nil &&
                vehicle.pathComp!.path!.count > 0 &&
                vehicle2NextPoint[vehicle] != nil &&
                point2Vehicle[vehicle2NextPoint[vehicle]!] != nil
            else { continue }

            let nextPoint = vehicle2NextPoint[vehicle]!
            let neighborVehicle = point2Vehicle[nextPoint]!

            Task {
                /// Lock vehicle movement
                let prevPhase = vehicle.pathComp!.phase
                vehicle.pathComp!.phase = .crashed

                let prevNeighborPhase = neighborVehicle.pathComp!.phase
                if [.waitingInput, .moving].contains(neighborVehicle.pathComp!.phase) {
                    neighborVehicle.pathComp!.phase = .crashed
                }

                /// Animate Vehicle Crash
                try! await Task.sleep(nanoseconds: sec2nanosec(1.0))

                /// Unlock vehicle movement
                vehicle.pathComp!.phase = LOCKED_PATH_PHASES.contains(prevPhase) ? .moving : prevPhase
                if prevNeighborPhase != neighborVehicle.pathComp!.phase {
                    neighborVehicle.pathComp!.phase = LOCKED_PATH_PHASES.contains(prevNeighborPhase) ? .moving : prevNeighborPhase
                }
            }
        }
    }
}
