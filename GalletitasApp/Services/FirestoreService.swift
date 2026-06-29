import Foundation
import FirebaseFirestore

enum FirestoreError: LocalizedError {
    case notImplemented
    case documentNotFound
    case permissionDenied
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .notImplemented: return "Función no implementada"
        case .documentNotFound: return "Documento no encontrado"
        case .permissionDenied: return "Permiso denegado"
        case .unknown(let error): return error.localizedDescription
        }
    }
}

protocol FirestoreServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchCategories() async throws -> [Category]
    func fetchOrders(for uid: String) async throws -> [Order]
    func createOrder(_ order: Order) async throws
    func updateOrderStatus(orderId: String, orderUid: String, status: OrderStatus) async throws
    func saveUserProfile(_ profile: UserProfile) async throws
    func fetchUserProfile(uid: String) async throws -> UserProfile
}

class FirestoreService: FirestoreServiceProtocol {
    private var db: Firestore {
        Firestore.firestore()
    }

    func saveUserProfile(_ profile: UserProfile) async throws {
        let data: [String: Any] = [
            "name": profile.name,
            "email": profile.email,
            "phone": profile.phone as Any,
            "addresses": profile.addresses.map { address in
                [
                    "alias": address.alias,
                    "street": address.street,
                    "city": address.city,
                    "latitude": address.latitude as Any,
                    "longitude": address.longitude as Any,
                ]
            },
            "createdAt": profile.createdAt,
        ]
        do {
            try await db.collection("users").document(profile.id).setData(data, merge: true)
        } catch {
            print("[Firestore] saveUserProfile error: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchUserProfile(uid: String) async throws -> UserProfile {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            guard snapshot.exists else { throw FirestoreError.documentNotFound }
            return try snapshot.data(as: UserProfile.self)
        } catch {
            print("[Firestore] fetchUserProfile error: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchProducts() async throws -> [Product] {
        throw FirestoreError.notImplemented
    }

    func fetchCategories() async throws -> [Category] {
        throw FirestoreError.notImplemented
    }

    func fetchOrders(for uid: String) async throws -> [Order] {
        let snapshot = try await db.collection("orders").document(uid).collection("user_orders")
            .order(by: "createdAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Order.self) }
    }

    func createOrder(_ order: Order) async throws {
        let data = try Firestore.Encoder().encode(order)
        try await db.collection("orders").document(order.uid).collection("user_orders")
            .document(order.id).setData(data)
    }

    func updateOrderStatus(orderId: String, orderUid: String, status: OrderStatus) async throws {
        let data: [String: Any] = [
            "status": status.rawValue,
            "statusHistory": FieldValue.arrayUnion([
                ["status": status.rawValue, "timestamp": Timestamp(date: Date())]
            ])
        ]
        try await db.collection("orders").document(orderUid).collection("user_orders")
            .document(orderId).updateData(data)
    }
}
