///
//  Entity+BoardTile.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

extension Entity {
    static func makeBoardTile(width: Float) async throws -> Entity {
        let boardTile = Entity()
        boardTile.name = "BoardTile"

//        let height: Float = 0.01
//        let boardTileModel = ModelEntity(
//            mesh: .generateBox(width: width, height: height, depth: width, cornerRadius: 0.02),
//            materials: [SimpleMaterial(color: .yellow, isMetallic: true)])
//        boardTileModel.name = "BoardTileModel"
//
//        boardTile.addChild(boardTileModel)

        return boardTile
    }
}
