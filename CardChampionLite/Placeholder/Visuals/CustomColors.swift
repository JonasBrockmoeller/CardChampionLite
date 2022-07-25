//
//  CustomColors.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 06.04.22.
//

import SwiftUI

struct CustomColors {
    static let textColor = Color("textColor")
    static let buttonColor = Color("buttonColor")
    static let backgroundColor = Color("backgroundColor")
    static let legendary = hexStringToUIColor(hex: "#cc5fac")
    static let epic = hexStringToUIColor(hex: "#e19938")
    static let rare = hexStringToUIColor(hex: "#cdd6e3")
    static let common = hexStringToUIColor(hex: "#bb673e")

    // Add more here...
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
