import SwiftUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            AppTheme.cream
                .ignoresSafeArea()

            VStack(spacing: AppTheme.padding) {
                Spacer()

                CookieIcon(size: 80)

                Text("Crear cuenta")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.accent)

                TextField("Nombre", text: $name)
                    .textContentType(.name)
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)

                SecureField("Contraseña", text: $password)
                    .textContentType(.newPassword)
                    .textFieldStyle(.roundedBorder)

                if let error = authViewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(AppTheme.error)
                        .font(AppTheme.captionFont)
                }

                PrimaryButton(
                    title: "Crear cuenta",
                    action: {
                        Task {
                            await authViewModel.signUp(email: email, password: password, name: name)
                            if authViewModel.isAuthenticated {
                                dismiss()
                            }
                        }
                    },
                    isLoading: authViewModel.isLoading,
                    isDisabled: name.isEmpty || email.isEmpty || password.isEmpty
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
        RegisterView()
            .environment(AuthViewModel())
    }
}
