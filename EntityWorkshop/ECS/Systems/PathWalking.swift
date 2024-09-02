//
//  PathWalking.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

final class PathWalking: System {
    static let query = EntityQuery(where:
        .has(PathComponent.self) &&
            .has(BoardPositionComponent.self)
    )

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        let boardTiles = context
            .scene
            .performQuery(.init(where: .has(BoardPositionComponent.self)))
            .filter { $0.name.hasPrefix("BoardTile") }

        let roadPoints = context
            .scene
            .performQuery(.init(where: .has(BoardPositionComponent.self)))
            .filter { $0.name.hasPrefix("RoadTile") }
            .map { Point2D(row: $0.boardPositionComp!.row, col: $0.boardPositionComp!.col) }

        let warehousePoints = context
            .scene
            .performQuery(.init(where: .has(BoardPositionComponent.self)))
            .filter { $0.name == "Warehouse" }
            .map { Point2D(row: $0.boardPositionComp!.row, col: $0.boardPositionComp!.col) }

        let tilePoints = Set(GlobalGameState.shared.tilePoints)

        /// Move vehicle to destination
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard entity.pathComp!.phase == .moving else { continue }

            /// Check if enough time has passed to move
            if entity.pathComp!.lastMovement != nil && Date().timeIntervalSince(entity.pathComp!.lastMovement!) < entity.pathComp!.secsPerTile {
                continue
            }

            let currentPoint = Point2D(row: entity.boardPositionComp!.row, col: entity.boardPositionComp!.col)
            let destinationPoint = entity.pathComp!.destinationPoint

            /// Fix state or Reached the end
            if destinationPoint == nil || currentPoint == destinationPoint! {
                entity.pathComp!.resetPath()
                continue
            }

            /// Set path if none exists
            if entity.pathComp!.path == nil {
                entity.pathComp!.path = PathfindingHelpers.bfs(
                    boardSize: GlobalGameState.shared.boardSize,
                    from: currentPoint,
                    to: destinationPoint!,
                    excludedPoints: tilePoints.subtracting(roadPoints + warehousePoints),
                    preferredPoints: Set()
                )
            }

            /// Move to next tile
            let currentPathIdx = entity.pathComp!.path!.firstIndex(where: { $0 == currentPoint })!
            let nextPoint = entity.pathComp!.path![currentPathIdx + 1]
            let nextBoardTile = boardTiles
                .first(where: { Point2D(row: $0.boardPositionComp!.row, col: $0.boardPositionComp!.col) == nextPoint })!
            let position = ImmersiveViewModel.getVehiclePositionForTile(vehicle: entity as! ModelEntity, boardTile: nextBoardTile)

            let translateX = position[0] - entity.position[0]
            let translateZ = position[2] - entity.position[2]
            entity.move(to: .init(translation: [translateX, 0, translateZ]),
                        relativeTo: entity,
                        duration: 0.3,
                        timingFunction: .easeInOut)
//                entity.position = position
            entity.pathComp!.lastMovement = Date()
            entity.boardPositionComp!.row = nextPoint.row
            entity.boardPositionComp!.col = nextPoint.col
        }
    }
}
