//
//  PalangColor.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/3/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

extension ShapeStyle where Self == Color {
  static var palangText00: Color { PalangPalangAsset.Assets.text00.swiftUIColor }
  static var palangText01: Color { PalangPalangAsset.Assets.text01.swiftUIColor }
  static var palangText02: Color { PalangPalangAsset.Assets.text02.swiftUIColor }
  static var palangText03: Color { PalangPalangAsset.Assets.text03.swiftUIColor }
  static var palangGray: Color { PalangPalangAsset.Assets.gray.swiftUIColor }
  static var palangWhite: Color { PalangPalangAsset.Assets.white.swiftUIColor }
  static var palangYellow: Color { PalangPalangAsset.Assets.yellow.swiftUIColor }
  static var palangGray01: Color { PalangPalangAsset.Assets.gray01.swiftUIColor }
  static var palangGray02: Color { PalangPalangAsset.Assets.gray02.swiftUIColor }
  static var palangYellow01: Color { PalangPalangAsset.Assets.yellow01.swiftUIColor }
  static var palangButton01: Color { PalangPalangAsset.Assets.button01.swiftUIColor }
  static var palangButton02: Color { PalangPalangAsset.Assets.button02.swiftUIColor }
}


extension UIColor {
  convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
