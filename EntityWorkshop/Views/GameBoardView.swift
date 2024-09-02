//
//  GameBoardView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import RealityKit
import SwiftUI

struct GameBoardView: View {
    var viewModel: ImmersiveViewModel

    var body: some View {
        ZStack {
            RealityView { content in
                content.add(viewModel.rootEntity)
            }
            /// Vehicle Tap
            .gesture(
                SpatialTapGesture()
                    .targetedToEntity(where: .has(VehicleComponent.self))
                    .onEnded { value in
                        if value.entity.pathComp!.phase != .waitingInput { return }
                        GlobalGameState.shared.toggleSelectedVehicle(vehicle: value.entity as? ModelEntity)
                    }
            )
            /// Selection Tile Tap
            .gesture(
                SpatialTapGesture()
                    .targetedToEntity(where: .has(SelectionTileComponent.self))
                    .onEnded { value in
                        if let vehicle = GlobalGameState.shared.selectedVehicle {
                            vehicle.pathComp!.destinationPoint = Point2D(
                                row: value.entity.boardPositionComp!.row,
                                col: value.entity.boardPositionComp!.col
                            )
                            vehicle.pathComp!.phase = .moving
                        }

                        GlobalGameState.shared.toggleSelectedVehicle(vehicle: nil)
                    }
            )

            ForEach(viewModel.vehicles) { vehicle in
                VehicleView(vehicle: vehicle)
            }

            ForEach(viewModel.buildings.values.sorted(by: { $0.id < $1.id }), id: \.id) { building in
                BuildingView(building: building)
            }

            ForEach(viewModel.warehouses.values.sorted(by: { $0.id < $1.id }), id: \.id) { warehouse in
                WarehouseView(warehouse: warehouse)
            }
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            HStack {
                Button("Spawn Warehouse") {
                    let validPoints = Set(
                        viewModel.roads
                            .keys
                            .flatMap { Point2D.getNeighbors(for: $0, boardSize: GlobalGameState.shared.boardSize) }
                    )
                    .subtracting(viewModel.roads.keys)
                    .subtracting(viewModel.buildings.keys)
                    .subtracting(viewModel.warehouses.keys)

                    if validPoints.count == 0 { return }

                    let warehousePoint = validPoints.shuffled().first!
                    let vehiclePoint = Point2D.getNeighbors(for: warehousePoint, boardSize: GlobalGameState.shared.boardSize)
                        .filter { viewModel.roads[$0] != nil }
                        .shuffled()
                        .first!

                    Task {
                        try! await viewModel.createWarehouse(row: warehousePoint.row, col: warehousePoint.col)
                        try! await viewModel.spawnVehicle(row: vehiclePoint.row, col: vehiclePoint.col)
                    }
                }
                Button("Spawn Vehicle") {
                    let warehouse = viewModel.warehouses.values.shuffled().first!
                    let warehousePoint = Point2D(row: warehouse.boardPositionComp!.row, col: warehouse.boardPositionComp!.col)
                    let neighbors = Point2D.getNeighbors(for: warehousePoint, boardSize: GlobalGameState.shared.boardSize).shuffled()

                    for neighbor in neighbors {
                        if viewModel.roads[neighbor] != nil {
                            Task {
                                try! await viewModel.spawnVehicle(row: neighbor.row, col: neighbor.col)
                            }
                            break
                        }
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    GameBoardView(viewModel: .init(boardSize: 7))
}
