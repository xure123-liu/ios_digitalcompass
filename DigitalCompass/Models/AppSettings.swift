import Foundation
import SwiftUI
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    @Published var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
            updateLanguage()
        }
    }
    
    @Published var isAccuracyTipsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isAccuracyTipsEnabled, forKey: "isAccuracyTipsEnabled")
        }
    }
    
    @Published var isSoundFeedbackEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundFeedbackEnabled, forKey: "isSoundFeedbackEnabled")
        }
    }
    
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var isRTL: Bool = false
    
    init() {
        let themeRaw = UserDefaults.standard.string(forKey: "selectedTheme") ?? "classic"
        self.selectedTheme = AppTheme(rawValue: themeRaw) ?? .classic
        
        let langRaw = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "system"
        self.selectedLanguage = AppLanguage(rawValue: langRaw) ?? .system
        
        self.isAccuracyTipsEnabled = UserDefaults.standard.bool(forKey: "isAccuracyTipsEnabled")
        if !UserDefaults.standard.bool(forKey: "hasSetAccuracyTips") {
            self.isAccuracyTipsEnabled = true
            UserDefaults.standard.set(true, forKey: "hasSetAccuracyTips")
        }
        
        self.isSoundFeedbackEnabled = UserDefaults.standard.bool(forKey: "isSoundFeedbackEnabled")
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        updateLanguage()
    }
    
    private func updateLanguage() {
        let effectiveLanguage = selectedLanguage.effectiveLanguage
        isRTL = effectiveLanguage == "ar"
        
        if selectedLanguage != .system {
            UserDefaults.standard.set([effectiveLanguage], forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }
    }
    
    func localizedString(_ key: String) -> String {
        let effectiveLanguage = selectedLanguage.effectiveLanguage
        guard let path = Bundle.main.path(forResource: effectiveLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: NSLocalizedString(key, comment: ""), comment: "")
    }
    
    var themeColors: AppColors {
        switch selectedTheme {
        case .light: return .light
        case .proOcean: return .proOcean
        case .proSunset: return .proSunset
        case .classic, .dark: return .dark
        }
    }
}

enum AppTheme: String, CaseIterable {
    case classic = "classic"
    case dark = "dark"
    case light = "light"
    case proOcean = "proOcean"
    case proSunset = "proSunset"
    
    var localizationKey: String {
        switch self {
        case .classic: return "theme_classic"
        case .dark: return "theme_dark"
        case .light: return "theme_light"
        case .proOcean: return "theme_pro_ocean"
        case .proSunset: return "theme_pro_sunset"
        }
    }
    
    var isPro: Bool {
        switch self {
        case .proOcean, .proSunset: return true
        default: return false
        }
    }
}

enum AppLanguage: String, CaseIterable {
    case system = "system"
    case english = "en"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case german = "de"
    case french = "fr"
    case korean = "ko"
    case japanese = "ja"
    case spanish = "es"
    case portuguese = "pt"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .system: return NSLocalizedString("lang_system", comment: "")
        case .english: return "English"
        case .chineseSimplified: return "简体中文"
        case .chineseTraditional: return "繁體中文"
        case .german: return "Deutsch"
        case .french: return "Français"
        case .korean: return "한국어"
        case .japanese: return "日本語"
        case .spanish: return "Español"
        case .portuguese: return "Português"
        case .arabic: return "العربية"
        }
    }
    
    var effectiveLanguage: String {
        if self == .system {
            let preferred = Locale.preferredLanguages.first ?? "en"
            let prefix = String(preferred.prefix(2))
            
            if prefix == "zh" {
                if preferred.contains("Hant") || preferred.contains("TW") || preferred.contains("HK") {
                    return "zh-Hant"
                }
                return "zh-Hans"
            }
            
            let supported = ["en", "de", "fr", "ko", "ja", "es", "pt", "ar"]
            return supported.contains(prefix) ? prefix : "en"
        }
        return rawValue
    }
}

struct AppColors {
    let backgroundPrimary: Color
    let backgroundSecondary: Color
    let backgroundTertiary: Color
    let accentPrimary: Color
    let accentWarning: Color
    let accentOrange: Color
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    let strokePrimary: Color
    
    static let dark = AppColors(
        backgroundPrimary: Color(hex: "#1A1A2E"),
        backgroundSecondary: Color(hex: "#0F0F1A"),
        backgroundTertiary: Color(hex: "#2D2D44"),
        accentPrimary: Color(hex: "#00E676"),
        accentWarning: Color(hex: "#FF5252"),
        accentOrange: Color(hex: "#FFB74D"),
        textPrimary: Color(hex: "#FFFFFF"),
        textSecondary: Color(hex: "#8A8AA0"),
        textTertiary: Color(hex: "#5A5A7A"),
        strokePrimary: Color(hex: "#3A3A5C")
    )
    
    static let light = AppColors(
        backgroundPrimary: Color(hex: "#F5F5F7"),
        backgroundSecondary: Color(hex: "#FFFFFF"),
        backgroundTertiary: Color(hex: "#E8E8ED"),
        accentPrimary: Color(hex: "#00C853"),
        accentWarning: Color(hex: "#FF5252"),
        accentOrange: Color(hex: "#FF9800"),
        textPrimary: Color(hex: "#1A1A2E"),
        textSecondary: Color(hex: "#6E6E80"),
        textTertiary: Color(hex: "#8E8E93"),
        strokePrimary: Color(hex: "#C7C7CC")
    )
    
    static let proOcean = AppColors(
        backgroundPrimary: Color(hex: "#0A1929"),
        backgroundSecondary: Color(hex: "#05101C"),
        backgroundTertiary: Color(hex: "#132F4C"),
        accentPrimary: Color(hex: "#00B4D8"),
        accentWarning: Color(hex: "#FF5252"),
        accentOrange: Color(hex: "#FFB74D"),
        textPrimary: Color(hex: "#FFFFFF"),
        textSecondary: Color(hex: "#8A8AA0"),
        textTertiary: Color(hex: "#5A6A7A"),
        strokePrimary: Color(hex: "#2A4A6A")
    )
    
    static let proSunset = AppColors(
        backgroundPrimary: Color(hex: "#1F0A14"),
        backgroundSecondary: Color(hex: "#150610"),
        backgroundTertiary: Color(hex: "#3D1A2A"),
        accentPrimary: Color(hex: "#FF6B9D"),
        accentWarning: Color(hex: "#FF5252"),
        accentOrange: Color(hex: "#FFC857"),
        textPrimary: Color(hex: "#FFFFFF"),
        textSecondary: Color(hex: "#C9A0B0"),
        textTertiary: Color(hex: "#8A6A7A"),
        strokePrimary: Color(hex: "#5A3A4A")
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
