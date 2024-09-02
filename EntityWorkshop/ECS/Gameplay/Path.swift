//
//  Path.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

enum PathPhase {
    case waitingInput
    case moving
    case settingPath
    case crashed
    /// Prevent user input when locked
    case locked
}

let LOCKED_PATH_PHASES: Set<PathPhase> = Set([.crashed, .locked])

@Observable
class PathState {
    /// Determines when to start moving
    var phase: PathPhase = .waitingInput
    var destinationPoint: Point2D?

    /// Movement Properties
    var secsPerTile: Double = 1.0
    var lastMovement: Date?
    var path: [Point2D]?

    init() {}

    func resetPath() {
        phase = .waitingInput
        destinationPoint = nil
        lastMovement = nil
        path = nil
    }
}

struct PathComponent: Component {
    @Observable
    class Storage {
        /// Determines when to start moving
        var phase: PathPhase = .waitingInput
        var destinationPoint: Point2D?

        /// Movement Properties
        var secsPerTile: Double = 1.0
        var lastMovement: Date?
        var path: [Point2D]?

        init() {}
    }

    private var storage = Storage()

    var phase: PathPhase {
        get { storage.phase }
        set { storage.phase = newValue }
    }

    var destinationPoint: Point2D? {
        get { storage.destinationPoint }
        set { storage.destinationPoint = newValue }
    }

    var secsPerTile: Double {
        get { storage.secsPerTile }
        set { storage.secsPerTile = newValue }
    }

    var lastMovement: Date? {
        get { storage.lastMovement }
        set { storage.lastMovement = newValue }
    }

    var path: [Point2D]? {
        get { storage.path }
        set { storage.path = newValue }
    }

    init() {
        PathComponent.registerComponent()
        PathWalking.registerSystem()
        SelectDestination.registerSystem()
    }

    func resetPath() {
        storage.phase = .waitingInput
        storage.destinationPoint = nil
        storage.lastMovement = nil
        storage.path = nil
    }
}

extension Entity {
    var pathComp: PathComponent? {
        get { components[PathComponent.self] }
        set { components[PathComponent.self] = newValue }
    }
}
