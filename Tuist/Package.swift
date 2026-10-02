// swift-tools-version: 6.0.3
import PackageDescription

#if TUIST
    import ProjectDescription
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [:],
        // Xcode 27 no longer supports the iOS 12 deployment target these dependencies declare.
        targetSettings: Dictionary(
            uniqueKeysWithValues: [
                "AsyncAlgorithms",
                "Bluetooth-iOS",
                "Cancellation",
                "ContainersPreview",
                "DequeModule",
                "InternalCollectionsUtilities",
                "Logging",
                "OrderedCollections",
                "Units",
            ].map { ($0, .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "15.0"])) }
        )
    )
#endif

// Credentials are injected via git URL rewriting in the Makefile before Tuist runs.
// See: make generate (sources .env → configures git url.insteadOf → runs tuist)
let package = Package(
    name: "ConnectionsSDKSample",
    dependencies: [
        .package(
            url: "https://github.com/MoveLab-Studio/Connections-SDK-Apple-Distribution.git",
            revision: "3.9.1"
        ),
        .package(
            url: "https://github.com/MoveLab-Studio/Domain-iOS.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/MoveLab-Studio/Bluetooth-iOS.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ]
)
