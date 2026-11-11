// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumiPluginThemePack",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PluginThemePack",
            targets: ["PluginThemePack"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lumi-softworks/LumiThemePack.git", from: "1.0.12"),
        .package(url: "https://github.com/lumi-softworks/LumiKernel.git", from: "1.1.0"),
        .package(url: "https://github.com/lumi-softworks/LumiLogging.git", from: "1.0.1"),
        .package(url: "https://github.com/lumi-softworks/LumiUI.git", from: "1.11.1"),
        .package(url: "https://github.com/lumi-softworks/LumiProviders.git", from: "1.18.0"),
        .package(url: "https://github.com/lumi-softworks/LumiSettings.git", from: "1.1.0"),
        .package(url: "https://github.com/lumi-softworks/LumiLocalization.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "PluginThemePack",
            dependencies: [
                .product(name: "LumiThemePack", package: "LumiThemePack"),
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "LumiLoggingKit", package: "LumiLogging"),
                .product(name: "LumiUI", package: "LumiUI"),
                .product(name: "ProviderCommand", package: "LumiProviders"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
                .product(name: "ProviderSettingView", package: "LumiSettings"),
                .product(name: "ProviderTheme", package: "LumiProviders"),
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
            ],
            path: "Sources/PluginThemePack",
            resources: [.process("../../Resources/Localizable.xcstrings")]
        ),
        .testTarget(
            name: "PluginThemePackTests",
            dependencies: ["PluginThemePack", .product(name: "LumiThemePack", package: "LumiThemePack")]
        )
    ]
)
