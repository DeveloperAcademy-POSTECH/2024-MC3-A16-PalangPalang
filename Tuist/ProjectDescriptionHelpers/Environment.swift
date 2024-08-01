//
//  Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 7/29/24.
//

import ProjectDescription

public enum Environment {
  public static let appName = "PalangPalang"
  public static let targetName = ""
  public static let targetTestName = "\(targetName)Tests"
  public static let organizationName = "com.mc3"
  public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
  public static let platform = Platform.iOS
  public static let baseSetting: SettingsDictionary = SettingsDictionary()
}

//public extension SettingsDictionary {
//  static let codeSign = SettingsDictionary()
//    .codeSignIdentityAppleDevelopment()
//    .automaticCodeSigning(devTeam: "Q2JZBR7H7Y")
//}
