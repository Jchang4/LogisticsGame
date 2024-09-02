//
//  Damage.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

struct DamageComponent: Component {
    var damage: Float = .zero

    init() {
        DamageComponent.registerComponent()
    }
}
