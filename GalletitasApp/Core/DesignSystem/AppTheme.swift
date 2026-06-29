import SwiftUI

extension UIColor {
    static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(uiColor: .adaptive(light: UIColor(light), dark: UIColor(dark)))
    }
}

enum AppTheme {
    static let accent = Color.brown
    static let secondaryAccent = Color.adaptive(light: Color.orange, dark: Color.orange.opacity(0.8))
    static let cream = Color.adaptive(light: Color(red: 0.929, green: 0.910, blue: 0.816), dark: Color(red: 0.15, green: 0.13, blue: 0.11))
    static let background = Color(.systemGroupedBackground)
    static let surface = Color(.systemBackground)
    static let cardBackground = Color.adaptive(light: .white, dark: Color(red: 0.2, green: 0.18, blue: 0.16))
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let success = Color.green
    static let error = Color.red

    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8

    static let titleFont = Font.title2.bold()
    static let bodyFont = Font.body
    static let captionFont = Font.caption
}

enum ThemeMode: String, CaseIterable {
    case system = "Sistema"
    case light = "Claro"
    case dark = "Oscuro"
}
