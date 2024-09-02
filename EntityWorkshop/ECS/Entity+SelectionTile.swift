//
//  Entity+SelectionTile.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

let vehicleSelectDestinationTileName: String = "VehicleSelectDestinationTile"

extension Entity {
    static func makeSelectionTile(name: String, width: Float, row: Int, col: Int, color: SimpleMaterial.Color = .yellow) -> Entity {
        let selectionTile = Entity()
        selectionTile.name = Entity.getSelectionTileName(prefix: name, row: row, col: col)

        let width = width * 0.25
        let tileModel = ModelEntity(
            mesh: .generateBox(width: width, height: width, depth: width),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
        tileModel.name = "SelectionTileModel"

        // Make the tile tappable
        selectionTile.components.set(SelectionTileComponent())
        selectionTile.components.set(BoardPositionComponent(row: row, col: col))
        selectionTile.components.set(InputTargetComponent())
        selectionTile.components.set(CollisionComponent(shapes: [.generateBox(width: width, height: width, depth: width)]))

        selectionTile.addChild(tileModel)
        selectionTile.position = [0, width / 2, 0]

        return selectionTile
    }

    static func getSelectionTileName(prefix: String, row: Int, col: Int) -> String {
        "\(prefix) \(row) \(col)"
    }
}
