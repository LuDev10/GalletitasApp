import SwiftUI

@Observable
class OrdersViewModel {
    var orders: [Order] = []
    var isLoading = false
    var error: Error?

    private let firestoreService: FirestoreServiceProtocol

    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func loadOrders(for uid: String) async {
        isLoading = true
        error = nil
        do {
            orders = try await firestoreService.fetchOrders(for: uid)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
