//
//  Entity+Road.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension Entity {
    static func makeRoad(width: Float) async throws -> Entity {
        let road = Entity()
        road.name = "Road"

        let roadModel = ModelEntity(
            mesh: .generateBox(width: width, height: 0.01, depth: width, cornerRadius: 0.01),
            materials: [SimpleMaterial(color: .black, isMetallic: false)]
        )
        roadModel.name = "RoadModel"
        road.addChild(roadModel)

        return road
    }
}
