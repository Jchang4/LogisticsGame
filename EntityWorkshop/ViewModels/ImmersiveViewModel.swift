//
//  ImmersiveViewModel.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

/// Global Variables
enum GamePhase {
    case setup
    case playing
    case stopped
    case gameOver
}

@Observable
class GlobalGameState {
    static let shared = GlobalGameState()

    var gamePhase: GamePhase = .setup
    var boardSize: Int = 10

    var selectedVehicle: ModelEntity?

    private init() {}

    var numTiles: Int { Int(boardSize * boardSize) }
    var tileWidth: Float { 1 / Float(boardSize) }
    var tilePoints: [Point2D] {
        var points: [Point2D] = []
        for row in 0 ..< boardSize {
            for col in 0 ..< boardSize {
                points.append(Point2D(row: row, col: col))
            }
        }
        return points
    }

    func toggleSelectedVehicle(vehicle: ModelEntity?) {
        if selectedVehicle == vehicle {
            selectedVehicle = nil
        } else {
            selectedVehicle = vehicle
        }
    }
}

@Observable @MainActor
final class ImmersiveViewModel {
    let rootEntity: Entity = .init()

    // Board Configuration
    var point2Entity: [Point2D: Entity]
    var buildings: [Point2D: Entity]
    var roads: [Point2D: Entity]
    var warehouses: [Point2D: Entity]
    var vehicles: [ModelEntity]

    init(boardSize: Int) {
        GlobalGameState.shared.boardSize = boardSize
        rootEntity.name = "GameRoot"

        self.point2Entity = [:]
        self.buildings = [:]
        self.roads = [:]
        self.warehouses = [:]
        self.vehicles = []

        let boardEntity = ModelEntity(
            mesh: .generateBox(width: 1, height: 0.01, depth: 1, cornerRadius: 0.02),
            materials: [SimpleMaterial(color: .systemGreen, isMetallic: true)]
        )
        boardEntity.name = "Board"
        rootEntity.addChild(boardEntity)
//        rootEntity.position = [0, 1.0, -1.1]
        rootEntity.position = [0, -0.2, 0.5]
    }

    var isAlreadySetup: Bool {
        point2Entity.count > 0
    }
}
