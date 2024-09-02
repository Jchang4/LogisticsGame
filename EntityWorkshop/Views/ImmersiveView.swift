//
//  ImmersiveView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import RealityKit
import RealityKitContent
import SwiftUI

@MainActor
struct ImmersiveView: View {
    @State private var viewModel: ImmersiveViewModel = .init(boardSize: 10)

    var body: some View {
        Group {
            if GlobalGameState.shared.gamePhase == .setup {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.extraLarge)
            } else if GlobalGameState.shared.gamePhase == .gameOver {
                GameOverView()
            } else {
                GameBoardView(viewModel: viewModel)
            }
        }
        .onAppear {
            if viewModel.isAlreadySetup { return }

            Task {
                let boardSize = GlobalGameState.shared.boardSize

                /// Create board tile entities for positioning
                for row in 0 ..< boardSize {
                    for col in 0 ..< boardSize {
                        _ = try await viewModel.createBoardTile(row: row, col: col)
                    }
                }

                /// Continuously try to create a valid game board
                while GlobalGameState.shared.gamePhase == .setup {
                    do {
                        /// Create Warehouses
                        let warehousePoint = try Point2D.getRandomPoints(boardSize: boardSize, numPoints: 1).first!
                        _ = try await viewModel.createWarehouse(row: warehousePoint.row, col: warehousePoint.col)

                        /// Create Buildings
                        let pctBuildings = 0.25
                        let totalNumTiles = Double(boardSize) * Double(boardSize)
                        let numBuildings = Int(totalNumTiles * pctBuildings)
                        let warehouseNeighbors = Point2D.getNeighbors(for: warehousePoint, boardSize: GlobalGameState.shared.boardSize)
                        let buildingPoints = try Point2D.getRandomPoints(
                            boardSize: boardSize,
                            numPoints: numBuildings,
                            excludedPoints: Set([warehousePoint] + warehouseNeighbors)
                        )
                        for point in buildingPoints {
                            _ = try await viewModel.createBuilding(row: point.row, col: point.col)
                        }

                        /// Create Roads
                        let roadPoints = try RoadGenerator.getRoadPoints(
                            warehousePoints: [warehousePoint],
                            buildingPoints: buildingPoints
                        )
                        for roadPoint in roadPoints {
                            _ = try await viewModel.createRoadTile(row: roadPoint.row, col: roadPoint.col)
                        }
                    } catch {
                        // Remove all warehouses, buildings, and roads
                        viewModel.warehouses.values.forEach { $0.removeFromParent() }
                        viewModel.buildings.values.forEach { $0.removeFromParent() }
                        viewModel.roads.values.forEach { $0.removeFromParent() }

                        viewModel.warehouses = [:]
                        viewModel.buildings = [:]
                        viewModel.roads = [:]

                        /// Retry generating valid board
                        continue
                    }

                    /// Show game to user
                    GlobalGameState.shared.gamePhase = .playing
                }

                /// Create Vehicles
                let randomWarehousePoint = viewModel.warehouses.keys.first!
                let randomWarehouseNeighbor = Point2D.getNeighbors(
                    for: randomWarehousePoint,
                    boardSize: GlobalGameState.shared.boardSize
                ).filter { viewModel.roads[$0] != nil }.first!
                _ = try await viewModel.spawnVehicle(row: randomWarehouseNeighbor.row, col: randomWarehouseNeighbor.col)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ImmersiveView()
}
