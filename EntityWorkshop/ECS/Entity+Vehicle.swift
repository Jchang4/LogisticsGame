//
//  Entity+Vehicle.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation
import RealityKit

extension Entity {
    static func makeVehicle(width: Float, color: SimpleMaterial.Color) async throws -> ModelEntity {
        // The vehicle uses physics forces and collisions. By declaring it as a `ModelEntity`,
        // it inherits the functionality afforded by the `HasPhysics` protocol.
        let vehicle = ModelEntity()
        vehicle.name = "Vehicle"

        let width = width * 0.5
        let height = width / 2
        let vehicleModel = ModelEntity(mesh: .generateBox(width: width, height: height, depth: width, cornerRadius: 0.02),
                                       materials: [SimpleMaterial(color: color, isMetallic: true)])
        vehicleModel.name = "VehicleModel"
        vehicle.addChild(vehicleModel)

//        var physicsBody = PhysicsBodyComponent(mode: .dynamic)
//        physicsBody.isAffectedByGravity = false
//        physicsBody.linearDamping = 0.2
//        physicsBody.massProperties.mass = 0.4
//        vehicle.components.set(physicsBody)

        let bodyCollisionShape = ShapeResource
            .generateBox(size: [width, height / 2, width])

        vehicle.components.set(CollisionComponent(shapes: [bodyCollisionShape]))

        return vehicle
    }

    func fadeOpacity(from start: Float? = nil, to end: Float, duration: Double) {
        let start = start ?? components[OpacityComponent.self]?.opacity ?? 0
        let fadeInAnimationDefinition = FromToByAnimation(
            from: Float(start),
            to: Float(end),
            duration: duration,
            timing: .easeInOut,
            bindTarget: .opacity
        )
        let fadeInAnimation = try! AnimationResource.generate(with: fadeInAnimationDefinition)
        components.set(OpacityComponent(opacity: start))
        playAnimation(fadeInAnimation)
    }
}
