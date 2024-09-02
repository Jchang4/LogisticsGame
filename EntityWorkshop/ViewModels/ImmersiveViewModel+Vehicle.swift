//
//  ImmersiveViewModel+Vehicle.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

extension ImmersiveViewModel {
    func spawnVehicle(row: Int, col: Int) async throws -> ModelEntity {
        let vehicle = try await createVehicle()
        setVehiclePosition(vehicle: vehicle, row: row, col: col)
        vehicle.fadeOpacity(from: 0, to: 1, duration: 1)
        return vehicle
    }

    func createVehicle() async throws -> ModelEntity {
        let color = VEHICLE_COLORS[vehicles.count % VEHICLE_COLORS.count]
        let vehicle = try await Entity.makeVehicle(width: GlobalGameState.shared.tileWidth,
                                                   color: color)

        vehicle.components.set(InputTargetComponent())
        vehicle.components.set(HoverEffectComponent())
        vehicle.components.set(VehicleComponent(color: color))
        vehicle.components.set(PathComponent())
        vehicle.components.set(DamageComponent())
        vehicle.components.set(HasPackagesComponent(carryingCapacity: 2))

        rootEntity.addChild(vehicle)
        vehicles.append(vehicle)

        return vehicle
    }

    func setVehiclePosition(vehicle: ModelEntity, row: Int, col: Int) {
        guard let boardTile = point2Entity[Point2D(row: row, col: col)] else {
            fatalError("Must create board entity first!")
        }

        vehicle.position = ImmersiveViewModel.getVehiclePositionForTile(vehicle: vehicle, boardTile: boardTile)
        vehicle.components.set(BoardPositionComponent(row: row, col: col))
    }

    static func getVehiclePositionForTile(vehicle: ModelEntity, boardTile: Entity) -> SIMD3<Float> {
        var tilePosition = boardTile.position
        if let bounds = vehicle.children.first(where: { $0.name == "VehicleModel" })?.visualBounds(relativeTo: nil) {
            let height = bounds.max[1] - bounds.min[1]
            tilePosition += [0, height, 0]
        }
        return tilePosition
    }
}
