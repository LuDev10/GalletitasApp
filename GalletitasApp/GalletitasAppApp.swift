import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct GalletitasAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authViewModel = AuthViewModel()
    @StateObject private var languageManager = LanguageManager()
    @AppStorage("appTheme") private var themeRaw: String = ThemeMode.system.rawValue

    private var colorScheme: ColorScheme? {
        guard let mode = ThemeMode(rawValue: themeRaw) else { return nil }
        switch mode {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(authViewModel)
                .environmentObject(languageManager)
                .environment(\.locale, languageManager.locale)
                .preferredColorScheme(colorScheme)
        }
    }
}
