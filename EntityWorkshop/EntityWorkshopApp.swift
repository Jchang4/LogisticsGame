//
//  EntityWorkshopApp.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import RealityKitContent
import SwiftUI

@main
struct EntityWorkshopApp: App {
    @State private var immersionState: ImmersionStyle = .mixed

    var body: some Scene {
        WindowGroup(id: "GameBoard") {
            ImmersiveView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.02, height: 0.5, depth: 1.02, in: .meters)
    }
}
