import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case notImplemented
    case invalidCredentials
    case userNotFound
    case networkError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .notImplemented: return "Función no implementada"
        case .invalidCredentials: return "Email o contraseña incorrectos"
        case .userNotFound: return "Usuario no encontrado"
        case .networkError: return "Error de conexión"
        case .unknown(let error): return error.localizedDescription
        }
    }
}

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> UserProfile
    func signUp(email: String, password: String, name: String) async throws -> UserProfile
    func signInWithApple() async throws -> UserProfile
    func signInWithGoogle() async throws -> UserProfile
    func signOut() throws
    func resetPassword(email: String) async throws
    var currentUser: UserProfile? { get }
}

class AuthService: AuthServiceProtocol {
    private var auth: Auth {
        Auth.auth()
    }

    var currentUser: UserProfile? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return UserProfile(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Usuario",
            email: firebaseUser.email ?? "",
            phone: nil,
            addresses: [],
            createdAt: firebaseUser.metadata.creationDate ?? Date()
        )
    }

    func signIn(email: String, password: String) async throws -> UserProfile {
        let result = try await auth.signIn(withEmail: email, password: password)
        return profile(from: result.user)
    }

    func signUp(email: String, password: String, name: String) async throws -> UserProfile {
        let result = try await auth.createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        return profile(from: result.user)
    }

    func signInWithApple() async throws -> UserProfile {
        throw AuthError.notImplemented
    }

    func signInWithGoogle() async throws -> UserProfile {
        throw AuthError.notImplemented
    }

    func signOut() throws {
        try auth.signOut()
    }

    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    private func profile(from firebaseUser: User) -> UserProfile {
        UserProfile(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Usuario",
            email: firebaseUser.email ?? "",
            phone: nil,
            addresses: [],
            createdAt: firebaseUser.metadata.creationDate ?? Date()
        )
    }
}
