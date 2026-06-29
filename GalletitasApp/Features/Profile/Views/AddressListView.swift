import SwiftUI

struct AddressListView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showForm = false
    @State private var isLoading = false
    @State private var error: Error?

    private let firestoreService = FirestoreService()

    var body: some View {
        List {
            if let addresses = authViewModel.currentUser?.addresses, !addresses.isEmpty {
                Section("Tus direcciones") {
                    ForEach(addresses.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(addresses[index].alias)
                                .fontWeight(.semibold)
                            Text(addresses[index].street)
                                .foregroundColor(AppTheme.textSecondary)
                            Text(addresses[index].city)
                                .foregroundColor(AppTheme.textSecondary)
                                .font(AppTheme.captionFont)
                        }
                    }
                    .onDelete { offsets in
                        Task { await deleteAddress(at: offsets) }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Sin direcciones",
                    systemImage: "location.slash",
                    description: Text("Agregá una dirección para recibir tus pedidos")
                )
            }

            Section {
                Button(action: { showForm = true }) {
                    Label("Agregar dirección", systemImage: "plus")
                }
            }

            if isLoading {
                HStack { Spacer(); ProgressView(); Spacer() }
            }

            if let error {
                Section { Text(error.localizedDescription).foregroundColor(AppTheme.error) }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Direcciones")
        .sheet(isPresented: $showForm) {
            AddressFormView { address in
                Task { await addAddress(address) }
                showForm = false
            }
        }
    }

    private func addAddress(_ address: DeliveryAddress) async {
        guard var user = authViewModel.currentUser else { return }
        isLoading = true
        error = nil
        user.addresses.append(address)
        do {
            try await firestoreService.saveUserProfile(user)
            authViewModel.currentUser = user
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func deleteAddress(at offsets: IndexSet) async {
        guard var user = authViewModel.currentUser else { return }
        isLoading = true
        error = nil
        user.addresses.remove(atOffsets: offsets)
        do {
            try await firestoreService.saveUserProfile(user)
            authViewModel.currentUser = user
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        AddressListView()
            .environment(AuthViewModel())
    }
}
