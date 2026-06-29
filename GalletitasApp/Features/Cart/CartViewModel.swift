import SwiftUI

@Observable
class CartViewModel {
    var items: [CartItem] = []
    var isLoading = false

    private let persistenceService = CartPersistenceService()

    var subtotal: Int {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var subtotalFormatted: String {
        let pesos = Double(subtotal) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.locale = Locale(identifier: "es-AR")
        return formatter.string(from: NSNumber(value: pesos)) ?? "$\(pesos)"
    }

    func addItem(product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.productId == product.id }) {
            items[index].quantity += quantity
        } else {
            let item = CartItem(
                id: UUID().uuidString,
                productId: product.id,
                name: product.name,
                price: product.price,
                quantity: quantity,
                notes: ""
            )
            items.append(item)
        }
        saveCart()
    }

    func loadCart() {
        Task {
            items = await persistenceService.loadCart()
        }
    }

    func saveCart() {
        Task {
            await persistenceService.saveCart(items)
        }
    }

    func updateQuantity(itemId: String, delta: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        let newQty = items[index].quantity + delta
        if newQty <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQty
        }
        saveCart()
    }

    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveCart()
    }

    func removeItem(id: String) {
        items.removeAll { $0.id == id }
        saveCart()
    }

    func clearCart() {
        items.removeAll()
        Task {
            await persistenceService.clearCart()
        }
    }
}
