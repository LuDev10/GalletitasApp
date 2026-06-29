import SwiftUI
import FirebaseAuth

@Observable
class AuthViewModel {
    var isAuthenticated = false
    var isLoading = false
    var error: Error?
    var currentUser: UserProfile?

    private let authService: AuthServiceProtocol
    private let firestoreService = FirestoreService()

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func checkAuthState() {
        if let user = authService.currentUser {
            currentUser = user
            isAuthenticated = true
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        error = nil
        do {
            let user = try await authService.signIn(email: email, password: password)
            if let saved = try? await firestoreService.fetchUserProfile(uid: user.id) {
                currentUser = saved
            } else {
                currentUser = user
            }
            isAuthenticated = true
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func signUp(email: String, password: String, name: String) async {
        isLoading = true
        error = nil
        do {
            let user = try await authService.signUp(email: email, password: password, name: name)
            try await firestoreService.saveUserProfile(user)
            currentUser = user
            isAuthenticated = true
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func signInWithApple() async {
        isLoading = true
        error = nil
        do {
            let user = try await authService.signInWithApple()
            currentUser = user
            isAuthenticated = true
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func signInWithGoogle() async {
        isLoading = true
        error = nil
        do {
            let user = try await authService.signInWithGoogle()
            currentUser = user
            isAuthenticated = true
        } catch {
            self.error = error
        }
        isLoading = false
    }

    func resetPassword(email: String) async {
        error = nil
        do {
            try await authService.resetPassword(email: email)
        } catch {
            self.error = error
        }
    }

    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            self.error = error
        }
    }
}
