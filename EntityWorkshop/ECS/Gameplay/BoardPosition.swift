//
//  BoardPosition.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

struct BoardPositionComponent: Component {
    var row: Int
    var col: Int

    init(row: Int, col: Int) {
        self.row = row
        self.col = col

        BoardPositionComponent.registerComponent()
    }
}

extension Entity {
    var boardPositionComp: BoardPositionComponent? {
        get { components[BoardPositionComponent.self] }
        set { components[BoardPositionComponent.self] = newValue }
    }
}
