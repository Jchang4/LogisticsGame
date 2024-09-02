//
//  Vehicle.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

let VEHICLE_COLORS: [SimpleMaterial.Color] = [
    .red,
    .green,
    .magenta,
    .orange,
    .purple,
    .systemPink
]

struct VehicleComponent: Component {
    var color: SimpleMaterial.Color

    init(color: SimpleMaterial.Color = .red) {
        self.color = color

        VehicleComponent.registerComponent()
        VehicleCollision.registerSystem()
    }
}

extension Entity {
    var vehicleComp: VehicleComponent? {
        get { components[VehicleComponent.self] }
        set { components[VehicleComponent.self] = newValue }
    }
}
