//
//  GhostViewModel.swift
//  PalangPalang
//
//  Created by 조민  on 8/7/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI
import Foundation

class GhostViewModel: ObservableObject { // modelview이름이 유령을 건든다고 생각해서 ghostview라고 생각했는데, 적절한지 모르겠음
  /*
   1. @Published 쓴 이유는 position이랑 isFlipped는 UI에서 계속 바뀌어서 가져왔어요 나머지는 안써서 안붙임
   2. identifiable를 사용하는 이유는 foreach문을 사용해서 반복문을 사용하고 싶어서 알아보니까 foreach문에는 고유한 identifier가 있어야 한다고 공부해서 그거를 쓰는 방법은 id를 일일히 불러오는 방식과 identifiable과 id를 인덱스 값으로 불러오는 방식이 있는데 전자가 더 가독성이 뛰어나다고 생각해서 갖고옴 */
  @Published var position: CGPoint
  @Published var isFlipped: Bool
  var velocity: CGPoint
  var imageName: String
  
  private var timer: Timer? // 이게 어떻게 쓰는지 잘 모르겠다는 느낌을 받아요! 이런 형식으로 받으면 다른 코드에서 안헷갈리는지? 일부러 private를 쓰긴 했는데
  private let ghostSize: CGFloat = 60 // 이거는 image값이 width가 61, height가 59라서
  private let offset: CGFloat = 59 // 유령이 바닥의 경계를 침범하지 않도록 막는 역할
  private let screenWidth = UIScreen.main.bounds.width // 이친구는 uikit에서 쓰는 개념인것 같던데 
  private let screenHeight = UIScreen.main.bounds.height
  
  init(initialPosition: CGPoint, imageName: String) {
    self.position = initialPosition
    self.imageName = imageName
    self.velocity = CGPoint(x: 4.0, y: 4.0) // 초기 속도
    self.isFlipped = false // 이미지가 좌우 반전되었는지 여부
    
    // 유령의 위치를 0.02초마다 업데이트하는 타이머 설정, 이 부분은 봐도 모르겠어서 보노코드랑 gpt 도움좀 얻음
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
      self?.moveGhost()
    }
  }
  
  deinit { // deinit을 해야 오버엔지니어링이 안된다고 들어서 deinit 사용
    timer?.invalidate() // 타이머 해제
  }
  
  private func moveGhost() { //얘는 여기서만 알아도 되는 로직이라 private를 사용했고, 로직은 지피티의 도움을 받았음!
    let newPosition = CGPoint(x: position.x + velocity.x, y: position.y + velocity.y)
    
    if newPosition.x <= ghostSize / 2 || newPosition.x >= screenWidth - ghostSize / 2 {
      velocity.x *= -1
      isFlipped.toggle() // 이미지 반전 상태를 토글
    }
    
    if newPosition.y <= ghostSize / 2 || newPosition.y >= screenHeight - (ghostSize / 2) - offset {
      velocity.y *= -1
    }
    position = newPosition
  }
}
