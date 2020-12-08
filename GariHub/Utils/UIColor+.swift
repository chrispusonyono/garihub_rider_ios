//
//  UIColor+.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/30/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
        
    static let appBlack = UIColor.hex("#000000")
    static let appYellow = UIColor.hex("1B8241")
    static let filledColor = UIColor.hex("#4CBB17")
    static let inactiveColor = UIColor.hex("#CCCCCC")
    
}


extension UIColor {
    static func hex(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }

        if ((cString.count) != 6) { return UIColor.gray }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    static func randomColor() -> UIColor {
        let r = UIColor.randomCGFloat()
        let g = UIColor.randomCGFloat()
        let b = UIColor.randomCGFloat()

        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
