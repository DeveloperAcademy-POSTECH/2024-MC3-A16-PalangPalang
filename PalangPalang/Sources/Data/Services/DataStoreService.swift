//
//  DataService.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import Foundation

struct DataStoreService<T: Storable> {
  func save(_ item: T) {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    do {
      let data = try encoder.encode(item)
      UserDefaults.standard.set(data, forKey: T.storageKey)
      print("UserDefaults에 새로운 데이터 저장됨")
    } catch {
      print("데이터 저장 실패: \(error)")
    }
  }
  
  func load() -> T? {
    guard let savedData = UserDefaults.standard.data(forKey: T.storageKey) else { return nil }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try? decoder.decode(T.self, from: savedData)
  }
  
  func remove() {
    UserDefaults.standard.removeObject(forKey: T.storageKey)
    print("UserDefaults에서 데이터 제거됨")
  }
}
