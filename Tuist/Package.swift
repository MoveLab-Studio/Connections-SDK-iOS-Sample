// swift-tools-version: 6.0.3
import PackageDescription

#if TUIST
    import ProjectDescription
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [:]
    )
#endif

// Credentials are injected via git URL rewriting in the Makefile before Tuist runs.
// See: make generate (sources .env → configures git url.insteadOf → runs tuist)
let package = Package(
    name: "ConnectionsSDKSample",
    dependencies: [
        .package(
            url: "https://github.com/MoveLab-Studio/Connections-SDK-Apple-Distribution.git",
            revision: "3.0.0-beta02"
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
