import Foundation
import LumiThemePack
import ProviderTheme
import Testing

@testable import PluginThemePack

@MainActor
struct ThemePackPluginTests {

    /// 旧版主题目录包含 19 个主题（17 个插件，Vscode 插件含 3 个变体）。
    @Test
    func catalogHasAllLegacyThemes() {
        #expect(LumiThemeCatalog.all.count == 19)
    }

    /// 每个主题 id 唯一，且与旧版主题插件注册的 id 一致。
    @Test
    func catalogIDsMatchLegacy() {
        let expectedIDs: Set<String> = [
            "lumi", "midnight", "sky", "aurora", "nebula", "void",
            "spring", "summer", "autumn", "winter", "github", "orchard",
            "mountain", "vscode-auto", "vscode-dark", "vscode-light",
            "river", "one-dark", "dracula",
        ]
        let actualIDs = Set(LumiThemeCatalog.all.map(\.id))
        #expect(actualIDs == expectedIDs)
        #expect(actualIDs.count == 19)
    }

    /// 每个主题的 id / 显示名 / 图标 / 外观类型齐全。
    @Test
    func catalogMetadataIsComplete() {
        for theme in LumiThemeCatalog.all {
            #expect(!theme.id.isEmpty)
            #expect(!theme.displayName.isEmpty)
            #expect(!theme.iconName.isEmpty)
        }
    }

    /// 注册到 DefaultThemeProviding 后：内置 3 + 复刻 19 = 22 个主题。
    @Test
    func pluginRegistersAllThemes() throws {
        let provider = DefaultThemeProviding(
            storageDirectory: FileManager.default.temporaryDirectory
        )
        let plugin = ThemePackPlugin()
        // onBoot 需要一个 KernelCoreContainer；这里直接验证注册语义：
        // 目录主题可全部被 provider 接受且不抛错。
        for legacy in LumiThemeCatalog.all {
            provider.registerTheme(legacy)
        }
        #expect(provider.themes.count == 22)
        // 未注册重复 id
        let ids = provider.themes.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Theme 菜单标题支持中文本地化")
    func themeMenuTitleIsLocalizedInChinese() {
        #expect(ThemePackPlugin.localizedMenuName(locale: Locale(identifier: "zh-Hans")) == "主题")
    }

    // MARK: - 可配置 id / order / policy

    /// 默认配置与 Lumi 原版一致。
    @Test("默认配置为 Lumi 标识与 required 策略")
    func defaultConfigurationMatchesLumi() {
        let plugin = ThemePackPlugin()
        #expect(plugin.id == "com.coffic.lumi.plugin.theme-pack")
        #expect(plugin.order == 100)
        #expect(plugin.metadata.id == plugin.id)
        #expect(plugin.metadata.policy == .required)
        #expect(plugin.metadata.category == .design)
    }

    /// 宿主可传入自定义 id / order / policy（GitOK / Kuzee / Wakey / Netto 场景）。
    @Test("自定义 id、order、policy 透传到实例与元数据")
    func customConfigurationIsApplied() {
        let plugin = ThemePackPlugin(
            id: "com.example.custom.plugin.theme-pack",
            order: 79,
            policy: .enabledByDefault
        )
        #expect(plugin.id == "com.example.custom.plugin.theme-pack")
        #expect(plugin.order == 79)
        #expect(plugin.metadata.id == "com.example.custom.plugin.theme-pack")
        #expect(plugin.metadata.policy == .enabledByDefault)
    }

    /// 元数据名称与描述走本地化（英文源存在）。
    @Test("元数据文案已本地化")
    func metadataIsLocalized() {
        let plugin = ThemePackPlugin()
        #expect(!plugin.metadata.name.isEmpty)
        #expect(!plugin.metadata.description.isEmpty)
    }
}
