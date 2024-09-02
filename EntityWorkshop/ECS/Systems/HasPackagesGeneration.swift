//
//  HasPackagesGeneration.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/2/24.
//

import Foundation
import RealityKit

final class HasPackagesGeneration: System {
    static var dependencies: [SystemDependency] {
        [.after(PackagePickup.self), .after(PackageDelivery.self), .after(PathWalking.self)]
    }

    static let query = EntityQuery(where: .has(CreatesPackagesComponent.self) && .has(HasPackagesComponent.self))

    var lastTicked: Date?

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        if lastTicked != nil && Date().timeIntervalSince(lastTicked!) < 1 {
            return
        }

        lastTicked = Date()

        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            var createPackagesComp = entity.createsPackagesComp!
            var hasPackagesComp = entity.hasPackagesComp!

            createPackagesComp.secsRemaining -= 1
            if createPackagesComp.secsRemaining <= 0 {
                createPackagesComp.secsRemaining = createPackagesComp.secsToCreate
                hasPackagesComp.numPackages += 1
            }
        }

//        let allBuildings = Array(context.entities(matching: Self.query, updatingSystemWhen: .rendering))
//        let buildingsWithPackages = allBuildings.filter { $0.requiresPackagesComp!.numPackages > 0 }
//
//        let pctBuildingsWithPackages = Double(buildingsWithPackages.count) / Double(allBuildings.count)
//
//        if pctBuildingsWithPackages < Self.minPctBuildingsWithPackages {
//            let numPackagesToGenerate = Int((Self.minPctBuildingsWithPackages - pctBuildingsWithPackages) * Double(allBuildings.count))
//            let buildingsNoPackages = allBuildings.filter { $0.requiresPackagesComp!.numPackages <= 0 }.shuffled()
//            for (i, building) in buildingsNoPackages.enumerated() {
//                if i >= numPackagesToGenerate { break }
//
//                building.requiresPackagesComp!.reset()
//                building.requiresPackagesComp!.numPackages = 1
//            }
//        }
    }
}
