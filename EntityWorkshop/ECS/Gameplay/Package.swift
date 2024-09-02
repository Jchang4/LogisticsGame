//
//  Package.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation
import RealityKit

struct HasPackagesComponent: Component {
    @Observable
    class Storage {
        var carryingCapacity: Int = .max
        var numPackages: Int = .zero
    }

    private var storage = Storage()

    var numPackages: Int {
        get { storage.numPackages }
        set { storage.numPackages = newValue }
    }

    var carryingCapacity: Int {
        get { storage.carryingCapacity }
        set { storage.carryingCapacity = newValue }
    }

    init(carryingCapacity: Int = .max, numPackages: Int = .zero) {
        self.carryingCapacity = carryingCapacity
        self.numPackages = numPackages

        HasPackagesComponent.registerComponent()
        PackagePickup.registerSystem()
        PackageDelivery.registerSystem()
        HasPackagesGeneration.registerSystem()
    }
}

struct CreatesPackagesComponent: Component {
    @Observable
    class Storage {
        var secsToCreate: Int = 10
        var secsRemaining: Int = 10
    }

    private var storage = Storage()

    var secsToCreate: Int {
        get { storage.secsToCreate }
        set { storage.secsToCreate = newValue }
    }

    var secsRemaining: Int {
        get { storage.secsRemaining }
        set { storage.secsRemaining = newValue }
    }

    init(secsToCreate: Int = 10) {
        self.secsToCreate = secsToCreate
        self.secsRemaining = secsToCreate

        HasPackagesGeneration.registerSystem()
    }
}

struct RequiresPackagesComponent: Component {
    @Observable
    class Storage {
        var numPackages: Int = .zero
        var secsToDeliver: Int = 45
        var secsRemaining: Int = 45
    }

    private var storage = Storage()

    var numPackages: Int {
        get { storage.numPackages }
        set { storage.numPackages = newValue }
    }

    var secsToDeliver: Int {
        get { storage.secsToDeliver }
        set { storage.secsToDeliver = newValue }
    }

    var secsRemaining: Int {
        get { storage.secsRemaining }
        set { storage.secsRemaining = newValue }
    }

    init(secsToDeliver: Int, numPackages: Int = 1) {
        self.numPackages = numPackages
        self.secsToDeliver = secsToDeliver
        self.secsRemaining = secsToDeliver

        RequiresPackagesComponent.registerComponent()
        PackageDelivery.registerSystem()
        RequiresPackageGeneration.registerSystem()
        GameOver.registerSystem()
    }

    func reset() {
        storage.numPackages = .zero
        storage.secsToDeliver = 45
        storage.secsRemaining = 45
    }
}

extension Entity {
    var hasPackagesComp: HasPackagesComponent? {
        get { components[HasPackagesComponent.self] }
        set { components[HasPackagesComponent.self] = newValue }
    }

    var requiresPackagesComp: RequiresPackagesComponent? {
        get { components[RequiresPackagesComponent.self] }
        set { components[RequiresPackagesComponent.self] = newValue }
    }

    var createsPackagesComp: CreatesPackagesComponent? {
        get { components[CreatesPackagesComponent.self] }
        set { components[CreatesPackagesComponent.self] = newValue }
    }
}
