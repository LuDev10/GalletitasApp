import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            AppTheme.cream
                .ignoresSafeArea()

            VStack(spacing: AppTheme.padding) {
                Spacer()

                CookieIcon(size: 80)

                Text("Iniciar sesión")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.accent)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)

                SecureField("Contraseña", text: $password)
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)

                if let error = authViewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(AppTheme.error)
                        .font(AppTheme.captionFont)
                }

                PrimaryButton(
                    title: "Entrar",
                    action: {
                        Task {
                            await authViewModel.signIn(email: email, password: password)
                            if authViewModel.isAuthenticated {
                                dismiss()
                            }
                        }
                    },
                    isLoading: authViewModel.isLoading,
                    isDisabled: email.isEmpty || password.isEmpty
                )

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(AuthViewModel())
    }
}
