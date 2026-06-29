import SwiftUI

struct CookieIcon: View {
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            cookieBase
            chocolateChips
        }
        .frame(width: size, height: size)
    }

    private var cookieBase: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.72, green: 0.53, blue: 0.27),
                        Color(red: 0.55, green: 0.35, blue: 0.15),
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size * 0.5
                )
            )
            .overlay(
                Circle()
                    .stroke(Color(red: 0.45, green: 0.28, blue: 0.10), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private var chocolateChips: some View {
        let chipColor = Color(red: 0.25, green: 0.12, blue: 0.05)
        let chipSize = size * 0.12

        return ZStack {
            Circle()
                .fill(chipColor)
                .frame(width: chipSize, height: chipSize)
                .offset(x: -size * 0.25, y: -size * 0.2)
                .rotationEffect(.degrees(15))

            Circle()
                .fill(chipColor)
                .frame(width: chipSize * 0.8, height: chipSize * 0.8)
                .offset(x: size * 0.3, y: -size * 0.25)

            Circle()
                .fill(chipColor)
                .frame(width: chipSize * 0.9, height: chipSize * 0.9)
                .offset(x: size * 0.1, y: size * 0.3)

            Circle()
                .fill(chipColor)
                .frame(width: chipSize * 0.7, height: chipSize * 0.7)
                .offset(x: -size * 0.35, y: size * 0.15)

            Circle()
                .fill(chipColor)
                .frame(width: chipSize * 1.1, height: chipSize * 1.1)
                .offset(x: -size * 0.05, y: -size * 0.35)

            Circle()
                .fill(chipColor)
                .frame(width: chipSize * 0.85, height: chipSize * 0.85)
                .offset(x: size * 0.35, y: size * 0.2)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CookieIcon(size: 60)
        CookieIcon(size: 120)
        CookieIcon(size: 200)
    }
}
