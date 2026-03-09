import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "ConnectionsSDKSample",
    settings: .settings(
        base: ProjectEnvironment.recommendedSettings,
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "ConnectionsSDKSample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(ProjectEnvironment.bundleIdPrefix).connectionssample",
            deploymentTargets: .iOS(ProjectEnvironment.deploymentTarget),
            infoPlist: .extendingDefault(with: [
                "NSBluetoothAlwaysUsageDescription": .string(
                    "This app uses Bluetooth to connect to a rowing machine."
                ),
                "NSBluetoothPeripheralUsageDescription": .string(
                    "This app uses Bluetooth to connect to a rowing machine."
                ),
                "UIBackgroundModes": .array([.string("bluetooth-peripheral")]),
                "CFBundleDisplayName": .string("Connections Sample"),
                "UILaunchScreen": .dictionary([:]),
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "ConnectionsSDK"),
            ]
        ),
    ]
)
