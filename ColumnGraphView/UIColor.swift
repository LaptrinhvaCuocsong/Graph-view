//
//  UIColor.swift
//  ColumnGraphView
//
//  Created by Apple on 1/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func hex(_ hex: String?, alpha: CGFloat = 1) -> UIColor {
        guard let hex = hex else { return .clear }
        let hexInt = UIColor.intFromHex(hex)
        let color = UIColor(red: (CGFloat)((hexInt & 0xFF0000) >> 16) / 255,
                            green: (CGFloat)((hexInt & 0xFF00) >> 8) / 255,
                            blue: (CGFloat)(hexInt & 0xFF) / 255,
                            alpha: alpha)
        return color
    }

    private class func intFromHex(_ hex: String) -> UInt64 {
        var hexInt: UInt64 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt64(&hexInt)
        return hexInt
    }

    static func + (color1: UIColor, color2: UIColor) -> UIColor {
        return addColor(color1, with: color2)
    }

    static func * (color: UIColor, multiplier: Double) -> UIColor {
        return multiplyColor(color, by: CGFloat(multiplier))
    }

    static func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }

    static func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }
}
