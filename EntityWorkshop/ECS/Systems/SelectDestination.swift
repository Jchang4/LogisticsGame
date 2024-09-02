//
//  SelectDestination.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

/// Highlight the destinations and set it in the entity's PathComponent
/// NOTE: vehicle.pathComp.destinationTile is set in the GameBoardView using a SpatialTapGesture
final class SelectDestination: System {
    static let query = EntityQuery(where: .has(BuildingComponent.self) || .has(WarehouseComponent.self))
    static let selectionTileQuery = EntityQuery(where: .has(SelectionTileComponent.self))

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        /// Remove selection tiles
        if GlobalGameState.shared.selectedVehicle == nil {
            for selectionTile in context.entities(matching: Self.selectionTileQuery, updatingSystemWhen: .rendering) {
                selectionTile.removeFromParent()
            }
        } else {
            /// Add SelectionTiles to all neighboring roads to Buildings
            if let rootEntity = context.scene.findEntity(named: "GameRoot") {
                for building in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
                    let buildingPoint = Point2D(row: building.boardPositionComp!.row, col: building.boardPositionComp!.col)
                    let neighbors = Point2D
                        .getNeighbors(for: buildingPoint, boardSize: GlobalGameState.shared.boardSize)
                        .filter {
                            // Is Road Tile
                            context.scene.findEntity(named: ImmersiveViewModel.getRoadTileName(row: $0.row, col: $0.col)) != nil
                        }

                    for neighbor in neighbors {
                        /// Change color
                        if let existingSelectionTile = context.scene.findEntity(named: Entity.getSelectionTileName(prefix: vehicleSelectDestinationTileName, row: neighbor.row, col: neighbor.col)) {
                            let model = existingSelectionTile.findEntity(named: "SelectionTileModel") as! ModelEntity
                            model.model?.materials = [SimpleMaterial(color: GlobalGameState.shared.selectedVehicle!.vehicleComp!.color, isMetallic: false)]
                        }
                        /// Create Selection Tile
                        else {
                            let boardTile = context.scene.findEntity(named: ImmersiveViewModel.getBoardTileName(row: neighbor.row, col: neighbor.col))!
                            let selectionTile = Entity.makeSelectionTile(
                                name: vehicleSelectDestinationTileName,
                                width: GlobalGameState.shared.tileWidth,
                                row: boardTile.boardPositionComp!.row,
                                col: boardTile.boardPositionComp!.col,
                                color: GlobalGameState.shared.selectedVehicle!.vehicleComp!.color
                            )
                            rootEntity.addChild(selectionTile)
                            selectionTile.position += boardTile.position
                        }
                    }
                }
            }
        }
    }
}
