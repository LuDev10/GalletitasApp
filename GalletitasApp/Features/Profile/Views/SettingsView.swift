import SwiftUI

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var isLoading = false
    @State private var error: Error?
    @State private var saveSuccess = false
    @State private var showAddresses = false
    @AppStorage("appTheme") private var themeRaw: String = ThemeMode.system.rawValue

    private let firestoreService = FirestoreService()

    private var theme: Binding<ThemeMode> {
        Binding(
            get: { ThemeMode.allCases.first { $0.rawValue == themeRaw } ?? .system },
            set: { themeRaw = $0.rawValue }
        )
    }

    var body: some View {
        Form {
            Section("Editar perfil") {
                TextField("Nombre", text: $name)
                    .textContentType(.name)
                TextField("Teléfono", text: $phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }

            Section {
                Button(action: { showAddresses = true }) {
                    HStack {
                        Label("Direcciones", systemImage: "location")
                        Spacer()
                        Text("\(authViewModel.currentUser?.addresses.count ?? 0)")
                            .foregroundColor(AppTheme.textSecondary)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }

            Section("Apariencia") {
                Picker("Tema", selection: theme) {
                    ForEach(ThemeMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
            }

            Section("Idioma") {
                Picker("Idioma", selection: Binding(
                    get: { languageManager.current },
                    set: { languageManager.current = $0 }
                )) {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Text(lang.rawValue).tag(lang)
                    }
                }
            }

            Section {
                if isLoading {
                    HStack { Spacer(); ProgressView(); Spacer() }
                } else {
                    Button("Guardar cambios") { Task { await save() } }
                }
            }

            if let error {
                Section { Text(error.localizedDescription).foregroundColor(AppTheme.error) }
            }

            if saveSuccess {
                Section { Text("Cambios guardados").foregroundColor(AppTheme.success) }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Configuración")
        .onAppear {
            name = authViewModel.currentUser?.name ?? ""
            phone = authViewModel.currentUser?.phone ?? ""
        }
        .navigationDestination(isPresented: $showAddresses) {
            AddressListView()
        }
        .alert("Cambiar idioma", isPresented: $languageManager.showRestartAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("El cambio de idioma se aplicará al reiniciar la app.")
        }
    }

    private func save() async {
        guard var user = authViewModel.currentUser else { return }
        isLoading = true
        error = nil
        saveSuccess = false
        user.name = name
        user.phone = phone.isEmpty ? nil : phone
        do {
            try await firestoreService.saveUserProfile(user)
            authViewModel.currentUser = user
            saveSuccess = true
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(AuthViewModel())
            .environmentObject(LanguageManager())
    }
}
