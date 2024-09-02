//
//  SelectionTile.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation
import RealityKit

struct SelectionTileComponent: Component {
    init() {
        SelectionTileComponent.registerComponent()
        SelectDestination.registerSystem()
    }
}
