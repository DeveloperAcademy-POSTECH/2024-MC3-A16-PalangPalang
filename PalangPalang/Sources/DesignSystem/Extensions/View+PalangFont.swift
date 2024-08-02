//
//  Font+PalangFont.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/2/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

public enum PalangFontType {
  // MARK: - 텍스트 전용 폰트타입
  case textH1
  case textH2
  case textBody01
  case textBody01Bold
  case textBody02
  case textCaption01
  case textCaption02
  
  // MARK: - 숫자 전용 폰트타입
  case numH1
  case numH1Bold
  case numH2
  case numH3
  case numH4
  case numSymbol01
  case numSymbol02
  case numSymbol03
}

extension View {
  func palangFont(_ fontStyle: PalangFontType) -> some View {
    switch fontStyle {
    case .textH1:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 30)
        )
    case .textH2:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 26)
        )
    case .textBody01:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 24)
        )
    case .textBody01Bold:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 24)
        )
    case .textBody02:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 20)
        )
    case .textCaption01:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .bold
            .swiftUIFont(size: 18)
        )
    case .textCaption02:
      return self
        .font(
          PalangPalangFontFamily
            .Pretendard
            .medium
            .swiftUIFont(size: 16)
        )
      
      
    case .numH1:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .medium
            .swiftUIFont(size: 96)
        )
    case .numH1Bold:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 96)
        )
    case .numH2:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 86)
        )
    case .numH3:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 64)
        )
    case .numH4:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 50)
        )
    case .numSymbol01:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 80)
        )
    case .numSymbol02:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 72)
        )
    case .numSymbol03:
      return self
        .font(
          PalangPalangFontFamily
            .Ubuntu
            .bold
            .swiftUIFont(size: 52)
        )
    }
  }
}

