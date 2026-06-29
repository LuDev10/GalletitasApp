import SwiftUI

struct AuthLandingView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var showForgotPassword = false
    @State private var forgotEmail = ""
    @State private var showResetSent = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.cream
                    .ignoresSafeArea()

                VStack(spacing: AppTheme.padding) {
                    Spacer()

                    CookieIcon(size: 100)

                    Text("Galletitas")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.accent)

                    VStack(spacing: 4) {
                        Text("Las mejores galletas artesanales")
                            .foregroundColor(AppTheme.textSecondary)

                        HStack(spacing: 4) {
                            Text("¿No tenés cuenta?")
                                .foregroundColor(AppTheme.textSecondary)
                            Button("Creá tu cuenta aquí") {
                                showRegister = true
                            }
                            .foregroundColor(AppTheme.accent)
                            .fontWeight(.semibold)
                        }
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .font(.title3)
                                Text("Continuar con Google")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }

                        Button(action: {}) {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .font(.title3)
                                Text("Continuar con Apple")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }

                        HStack {
                            VStack { Divider() }
                            Text("o")
                                .foregroundColor(AppTheme.textSecondary)
                                .font(AppTheme.captionFont)
                                .padding(.horizontal, 8)
                            VStack { Divider() }
                        }
                        .padding(.vertical, AppTheme.smallPadding)

                        PrimaryButton(title: "Iniciar sesión", action: { showLogin = true })

                        Button("¿Olvidaste tu contraseña?") {
                            showForgotPassword = true
                        }
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.top, AppTheme.smallPadding)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .alert("Restablecer contraseña", isPresented: $showForgotPassword) {
                TextField("Email", text: $forgotEmail)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                Button("Enviar") { sendReset() }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Ingresá tu email y te enviaremos un link para restablecer tu contraseña.")
            }
            .alert("Email enviado", isPresented: $showResetSent) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Si la cuenta existe, recibirás un email con las instrucciones.")
            }
        }
    }

    private func sendReset() {
        Task {
            try? await authViewModel.resetPassword(email: forgotEmail)
            showResetSent = true
            forgotEmail = ""
        }
    }
}

#Preview {
    AuthLandingView()
        .environment(AuthViewModel())
}
