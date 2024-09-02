//
//  ImmersiveViewModel+BoardTile.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

extension ImmersiveViewModel {
    func createBoardTile(row: Int, col: Int) async throws -> Entity {
        let point = Point2D(row: row, col: col)
        if let boardTile = point2Entity[point] {
            return boardTile
        }

        let boardTile = try await Entity.makeBoardTile(width: GlobalGameState.shared.tileWidth)
        boardTile.name = ImmersiveViewModel.getBoardTileName(row: row, col: col)

        let position = boardTileInitialPosition(row: row, col: col)
        boardTile.components.set(
            BoardPositionComponent(
                row: row,
                col: col
            )
        )

        rootEntity.addChild(boardTile)
        boardTile.position = position

        point2Entity[point] = boardTile

        return boardTile
    }

    func boardTileInitialPosition(row: Int, col: Int) -> SIMD3<Float> {
        let tileWidth = GlobalGameState.shared.tileWidth
        let positionZ: Float = (tileWidth * Float(row)) - 0.5 + tileWidth / 2
        let positionX: Float = (tileWidth * Float(col)) - 0.5 + tileWidth / 2
        return [positionX, 0.005, positionZ]
    }

    static func getBoardTileName(row: Int, col: Int) -> String {
        "BoardTile \(row) \(col)"
    }
}
