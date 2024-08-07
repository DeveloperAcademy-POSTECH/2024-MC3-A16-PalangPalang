//
//  LottieGhost.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/7/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
  
  var animationFileName: String
  let loopMode: LottieLoopMode
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
  func makeUIView(context: Context) -> Lottie.LottieAnimationView {
    let animationView = LottieAnimationView(name: animationFileName)
    animationView.loopMode = loopMode
    animationView.play()
    animationView.contentMode = .scaleAspectFill
    return animationView
  }
}
