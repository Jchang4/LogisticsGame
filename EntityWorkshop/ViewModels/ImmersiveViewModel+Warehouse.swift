//
//  ImmersiveViewModel+Warehouse.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension ImmersiveViewModel {
    func createWarehouse(row: Int, col: Int) async throws -> Entity {
        guard let boardTile = point2Entity[Point2D(row: row, col: col)] else {
            fatalError("Must create board entity first!")
        }

        let warehouse = try await Entity.makeWarehouse(width: GlobalGameState.shared.tileWidth)

        warehouse.components.set(WarehouseComponent())
        warehouse.components.set(BoardPositionComponent(row: row, col: col))
        warehouse.components.set(HasPackagesComponent(carryingCapacity: .max, numPackages: 3))
        warehouse.components.set(CreatesPackagesComponent(secsToCreate: 7))

        rootEntity.addChild(warehouse)

        warehouse.position = boardTile.position
        if let bounds = warehouse.children.first(where: { $0.name == "WarehouseModel" })?.visualBounds(relativeTo: nil) {
            let height = bounds.max[1] - bounds.min[1]
            warehouse.position += [0, height / 2, 0]
        }

        warehouses[Point2D(row: row, col: col)] = warehouse

        return warehouse
    }
}
