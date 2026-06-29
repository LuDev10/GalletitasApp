import SwiftUI

struct SplashView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var opacity: CGFloat = 0
    @State private var scale: CGFloat = 0.8
    @State private var ready = false

    var body: some View {
        Group {
            if ready {
                if authViewModel.isAuthenticated {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    AuthLandingView()
                        .transition(.opacity)
                }
            } else {
                ZStack {
                    AppTheme.cream
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        CookieIcon(size: 140)
                            .opacity(opacity)
                            .scaleEffect(scale)

                        Text("Galletitas")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.accent)
                            .opacity(opacity)
                    }
                }
            }
        }
        .onAppear {
            authViewModel.checkAuthState()
            withAnimation(.easeOut(duration: 0.6)) {
                opacity = 1
                scale = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    ready = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(AuthViewModel())
}
