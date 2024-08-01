import ProjectDescription
import Foundation

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/
///
///

extension Project {
  /// Helper function to create the Project for this ExampleApp
  public static func app(
    name: String,
    destinations: Destinations,
    settings: Settings?,
    additionalTargets: [String]
  ) -> Project {
    
    var targets = makeAppTargets(
      name: name,
      destinations: destinations,
      dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
    targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, destinations: destinations) })
    return Project(name: name,
                   organizationName: Environment.organizationName,
                   settings: settings,
                   targets: targets)
  }
  
  // MARK: - Private
  
  /// Helper function to create a framework target and an associated unit test target
  private static func makeFrameworkTargets(name: String, destinations: Destinations) -> [Target] {
    let sources = Target(name: name,
                         destinations: destinations,
                         product: .framework,
                         bundleId: "\(Environment.organizationName).\(name.lowercased())",
                         infoPlist: .default,
                         sources: ["Sources/**"],
                         resources: [],
                         dependencies: [])
    let tests = Target(name: "\(name)Tests",
                       destinations: destinations,
                       product: .unitTests,
                       bundleId: "\(Environment.organizationName).\(name.lowercased())Tests",
                       infoPlist: .default,
                       sources: ["Tests/**"],
                       resources: [],
                       dependencies: [.target(name: name)])
    return [sources, tests]
  }
  
  /// Helper function to create the application target and the unit test target.
  private static func makeAppTargets(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
    
    let mainTarget = Target(
      name: name,
      destinations: destinations,
      product: .app,
      bundleId: "\(Environment.organizationName).\(name.lowercased())",
      deploymentTargets: Environment.deploymentTarget,
      infoPlist: .file(path: "Resources/InfoPlists/\(Environment.appName)-Info.plist"),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies
    )
    
    let testTarget = Target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(Environment.organizationName).\(name.lowercased())Tests",
      deploymentTargets: Environment.deploymentTarget,
      infoPlist: .file(path: "Resources/InfoPlists/\(Environment.appName)Tests-Info.plist"),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "\(name)")
      ])
    return [mainTarget, testTarget]
  }
}
