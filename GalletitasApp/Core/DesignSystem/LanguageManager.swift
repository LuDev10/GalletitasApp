import Combine
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case es = "Español"
    case en = "English"

    var code: String {
        switch self {
        case .es: return "es"
        case .en: return "en"
        }
    }

    var locale: Locale {
        Locale(identifier: code)
    }
}

class LanguageManager: ObservableObject {
    @AppStorage("appLanguage") var rawValue: String = AppLanguage.es.code {
        didSet { objectWillChange.send() }
    }

    @Published var showRestartAlert = false

    var current: AppLanguage {
        get { AppLanguage.allCases.first { $0.code == rawValue } ?? .es }
        set {
            guard newValue.code != rawValue else { return }
            rawValue = newValue.code
            UserDefaults.standard.set([newValue.code], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            showRestartAlert = true
        }
    }

    var locale: Locale {
        current.locale
    }
}
