//
//  BuildingView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import RealityKit
import SwiftUI

struct BuildingView: View {
    var building: Entity

    var body: some View {
        RealityView { _, _ in

        } update: { _, attachments in
            if let buildingPackageCountdownAttachment = attachments.entity(for: "BuildingPackageCountdown") {
                if building.requiresPackagesComp != nil && building.requiresPackagesComp!.numPackages > 0 {
                    building.addChild(buildingPackageCountdownAttachment)
                    buildingPackageCountdownAttachment.position = [0, 0.12, 0]
                } else {
                    buildingPackageCountdownAttachment.removeFromParent()
                }
            }
        } attachments: {
            Attachment(id: "BuildingPackageCountdown") {
                if let requiredPackages = building.requiresPackagesComp {
                    if requiredPackages.numPackages > 0 {
                        ProgressView(value: Float(requiredPackages.secsRemaining), total: Float(requiredPackages.secsToDeliver)) {
                            Image(systemName: "shippingbox.circle.fill")
                                .font(.extraLargeTitle)
                                .foregroundStyle(.cyan)
                        }
                        .frame(width: 100)
                        .tint(.cyan)
                    }
                }
            }
        }
    }
}

// #Preview {
//    BuildingView(building: Entity())
// }
