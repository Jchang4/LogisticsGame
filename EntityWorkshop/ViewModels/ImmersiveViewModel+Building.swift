//
//  Entity+Building.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

extension ImmersiveViewModel {
    func createBuilding(row: Int, col: Int) async throws -> Entity {
        guard let boardTile = point2Entity[Point2D(row: row, col: col)] else {
            fatalError("Must create board entity first!")
        }

        let building = try await Entity.makeBuilding(width: GlobalGameState.shared.tileWidth)

        building.components.set(BuildingComponent())
        building.components.set(BoardPositionComponent(row: row, col: col))
        building.components.set(RequiresPackagesComponent(secsToDeliver: 45, numPackages: 0))

        rootEntity.addChild(building)

        building.position = boardTile.position
        if let bounds = building.children.first(where: { $0.name == "BuildingModel" })?.visualBounds(relativeTo: nil) {
            let height = bounds.max[1] - bounds.min[1]
            building.position += [0, height / 2, 0]
        }

        buildings[Point2D(row: row, col: col)] = building

        return building
    }
}
