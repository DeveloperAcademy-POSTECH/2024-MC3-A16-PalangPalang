//
//  Dependencies.swift
//  Config
//
//  Created by 박혜운 on 8/7/24.
//

// Dependencies.swift
import ProjectDescription

let spm = SwiftPackageManagerDependencies(
  [
    .remote(
      url: "https://github.com/airbnb/lottie-spm.git",
      requirement: .exact("4.5.0")
    )
  ]
  ,
  baseSettings: .settings(
        configurations: [
          .debug(name: .debug),
          .release(name: .release)
        ]
      )
//  ,
//   baseSettings: .settings(configurations: XCConfig.module)
)

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
