//
//  GameOver.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/2/24.
//

import Foundation
import RealityKit

/// Highlight the destinations and set it in the entity's PathComponent
/// NOTE: vehicle.pathComp.destinationTile is set in the GameBoardView using a SpatialTapGesture
final class GameOver: System {
    static let query = EntityQuery(where: .has(RequiresPackagesComponent.self))

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            let requirePackage = entity.requiresPackagesComp!
            if requirePackage.secsRemaining <= 0 {
                GlobalGameState.shared.gamePhase = .gameOver
            }
        }
    }
}
