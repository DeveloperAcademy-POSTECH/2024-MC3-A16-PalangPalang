import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
 +-------------+
 |             |
 |     App     | Contains PalangPalang App target and PalangPalang unit-test target
 |             |
 +------+-------------+-------+
 |         depends on         |
 |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+
 
 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let settinges: Settings =
  .settings(
    base: Environment.baseSetting,
    configurations: [
      .debug(name: "Debug", xcconfig: Path("../Config/Debug.xcconfig")),
      .release(name: "Release", xcconfig: Path("../Config/Release.xcconfig"))
    ],
    defaultSettings: .recommended
  )

let project = Project.app(
  name: "PalangPalang",
  destinations: .iOS,
  settings: settinges,
  additionalTargets: []
)
