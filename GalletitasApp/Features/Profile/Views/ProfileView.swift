import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showAuth = false

    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isAuthenticated, let user = authViewModel.currentUser {
                    List {
                        Section {
                            HStack {
                                CookieIcon(size: 50)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.name)
                                        .fontWeight(.semibold)
                                    Text(user.email)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .font(AppTheme.captionFont)
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        Section {
                            NavigationLink(destination: SettingsView()) {
                                Label("Configuración", systemImage: "gear")
                            }
                            NavigationLink(destination: AddressListView()) {
                                Label("Direcciones", systemImage: "location")
                            }
                        }

                        Section {
                            Button("Cerrar sesión", role: .destructive) {
                                authViewModel.signOut()
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    VStack(spacing: AppTheme.padding) {
                        ContentUnavailableView(
                            "Sin sesión",
                            systemImage: "person",
                            description: Text("Iniciá sesión para ver tu perfil")
                        )
                        Button(action: { showAuth = true }) {
                            PrimaryButton(title: "Iniciar sesión", action: {})
                        }
                    }
                    .padding()
                }
            }
            .background(AppTheme.cream)
            .navigationTitle("Perfil")
            .fullScreenCover(isPresented: $showAuth) {
                AuthLandingView()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
