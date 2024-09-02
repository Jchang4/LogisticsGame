//
//  Entity+Warehouse.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension Entity {
    static func makeWarehouse(width: Float) async throws -> Entity {
        let warehouse = Entity()
        warehouse.name = "Warehouse"

        let width = width * 0.75
        let warehouseModel = ModelEntity(
            mesh: .generateBox(width: width, height: width * 1.3, depth: width, cornerRadius: 0.01),
            materials: [SimpleMaterial(color: .systemPurple, isMetallic: true)]
        )
        warehouseModel.name = "WarehouseModel"
        warehouse.addChild(warehouseModel)

        return warehouse
    }
}
