import SwiftUI

@Observable
class ProfileViewModel {
    var user: UserProfile?
    var isLoading = false
    var error: Error?
    var saveSuccess = false

    private let authService: AuthServiceProtocol
    private let firestoreService: FirestoreServiceProtocol

    init(
        authService: AuthServiceProtocol = AuthService(),
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.authService = authService
        self.firestoreService = firestoreService
    }

    func loadProfile() {
        user = authService.currentUser
    }

    func saveProfile(name: String, phone: String) async {
        guard var user else { return }
        isLoading = true
        error = nil
        user.name = name
        user.phone = phone.isEmpty ? nil : phone
        do {
            try await firestoreService.saveUserProfile(user)
            self.user = user
            saveSuccess = true
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func addAddress(_ address: DeliveryAddress) async {
        guard var user else { return }
        isLoading = true
        error = nil
        user.addresses.append(address)
        do {
            try await firestoreService.saveUserProfile(user)
            self.user = user
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func deleteAddress(at offsets: IndexSet) async {
        guard var user else { return }
        isLoading = true
        error = nil
        user.addresses.remove(atOffsets: offsets)
        do {
            try await firestoreService.saveUserProfile(user)
            self.user = user
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func signOut() {
        do {
            try authService.signOut()
            user = nil
        } catch {
            self.error = error
        }
    }
}
