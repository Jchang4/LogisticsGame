//
//  WarehouseView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/2/24.
//

import SwiftUI

import RealityKit
import SwiftUI

struct WarehouseView: View {
    var warehouse: Entity

    var body: some View {
        RealityView { _, _ in

        } update: { _, attachments in
            if let warehouseCreatePackageAttachment = attachments.entity(for: "WarehouseCreatePackageCountdown") {
                if warehouse.createsPackagesComp != nil && warehouse.hasPackagesComp != nil {
                    warehouse.addChild(warehouseCreatePackageAttachment)
                    warehouseCreatePackageAttachment.position = [0, 0.12, 0]
                } else {
                    warehouseCreatePackageAttachment.removeFromParent()
                }
            }
        } attachments: {
            Attachment(id: "WarehouseCreatePackageCountdown") {
                ProgressView(value: Float(warehouse.createsPackagesComp!.secsRemaining), total: Float(warehouse.createsPackagesComp!.secsToCreate)) {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .font(.extraLargeTitle)
                            .foregroundStyle(.cyan)
                        Text("\(warehouse.hasPackagesComp!.numPackages)")
                    }
                }
                .frame(width: 100)
                .tint(.cyan)
            }
        }
    }
}

// #Preview {
//    WarehouseView(warehouse: Entity())
// }
