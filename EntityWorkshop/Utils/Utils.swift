//
//  Utils.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 9/1/24.
//

import Foundation

func deg2rad(_ number: Double) -> Float {
    return Float(number * .pi / 180)
}

func sec2nanosec(_ seconds: Double) -> UInt64 {
    return UInt64(seconds * Double(NSEC_PER_SEC))
}

func prettyDecimal(num: Double, numDecimals: Int = 2) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = numDecimals
    formatter.minimumFractionDigits = numDecimals

    if let stringDecimal = formatter.string(for: num) {
        return stringDecimal
    }

    return ""
}
