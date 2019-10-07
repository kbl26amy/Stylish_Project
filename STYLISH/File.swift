//
//  File.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/22.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let redColor = Int(color >> 16) & mask
        let greenColor = Int(color >> 8) & mask
        let blueColor = Int(color) & mask
        let red   = CGFloat(redColor) / 255.0
        let green = CGFloat(greenColor) / 255.0
        let blue  = CGFloat(blueColor) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    func toHexString() -> String {
        var redNumber: CGFloat = 0
        var greenNumber: CGFloat = 0
        var blueNumber: CGFloat = 0
        var alphaNumber: CGFloat = 0
        getRed(&redNumber, green: &greenNumber, blue: &blueNumber, alpha: &alphaNumber)
        let rgb: Int = (Int)(redNumber*255)<<16 | (Int)(greenNumber*255)<<8 | (Int)(blueNumber*255)<<0
        return String(format: "#%06x", rgb)
    }
}
