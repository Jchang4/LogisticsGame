//
//  VehicleView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import RealityKit
import SwiftUI

struct VehicleView: View {
    let vehicle: ModelEntity

    var body: some View {
        RealityView { _, _ in

        } update: { _, attachments in
            if let packageCountAttachment = attachments.entity(for: "VehiclePackageCount") {
                if vehicle.hasPackagesComp!.numPackages > 0 {
                    vehicle.addChild(packageCountAttachment)
                    packageCountAttachment.position = [0, 0.05, 0]
                } else {
                    vehicle.removeChild(packageCountAttachment)
                }
            }
        } attachments: {
            Attachment(id: "VehiclePackageCount") {
                let pathComp = vehicle.pathComp!
                HStack {
                    if ![.waitingInput, .settingPath].contains(pathComp.phase) {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    if vehicle.hasPackagesComp!.numPackages > 0 {
                        Image(systemName: "shippingbox.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.cyan)
                        Text("\(vehicle.hasPackagesComp!.numPackages)")
                    }
                }
            }
        }
    }
}

#Preview {
    VehicleView(vehicle: ModelEntity())
}
