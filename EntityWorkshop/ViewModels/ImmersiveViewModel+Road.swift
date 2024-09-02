//
//  ImmersiveViewModel+Road.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension ImmersiveViewModel {
    func createRoadTile(row: Int, col: Int) async throws -> Entity {
        guard let boardTile = point2Entity[Point2D(row: row, col: col)] else {
            fatalError("Must create board entity first!")
        }

        let roadTile = try await Entity.makeRoad(width: GlobalGameState.shared.tileWidth)
        roadTile.name = ImmersiveViewModel.getRoadTileName(row: row, col: col)

        roadTile.components.set(BoardPositionComponent(row: row, col: col))

        rootEntity.addChild(roadTile)

        roadTile.position = boardTile.position + [0, -0.0049, 0]

        roads[Point2D(row: row, col: col)] = roadTile

        return roadTile
    }

    static func getRoadTileName(row: Int, col: Int) -> String {
        "RoadTile \(row) \(col)"
    }
}
