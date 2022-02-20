// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import SwiftUI

extension Color {
    
    init(R: Int, G: Int, B: Int) {
        self.init(red: Double(R) / 0xff, green: Double(G) / 0xff, blue: Double(B) / 0xff)
    }
    
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init( .sRGB, red: components.R, green: components.G, blue: components.B, opacity: alpha)
    }
}

extension UIColor {
    
    convenience init(R: Int, G: Int, B: Int) {
        self.init(red: CGFloat(R / 0xff), green: CGFloat(G / 0xff), blue: CGFloat(B / 0xff),alpha: CGFloat(1))
    }
    
    convenience init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(red: CGFloat(components.R), green: CGFloat(components.G), blue: CGFloat(components.B),
                  alpha: CGFloat(alpha))
    }
}
