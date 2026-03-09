import ProjectDescription

public enum ProjectEnvironment {
    public static let deploymentTarget = "18.0"
    public static let bundleIdPrefix = "mls.connections"

    public static let recommendedSettings: SettingsDictionary = [
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
        "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
    ]
}
