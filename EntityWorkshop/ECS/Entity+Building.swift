//
//  Entity+Building.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension Entity {
    static func makeBuilding(width: Float) async throws -> Entity {
        let building = Entity()
        building.name = "Building"

        let width = width * 0.75
        let buildingModel = ModelEntity(
            mesh: .generateBox(width: width, height: width * 1.3, depth: width, cornerRadius: 0.01),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        buildingModel.name = "BuildingModel"
        building.addChild(buildingModel)

        return building
    }
}
