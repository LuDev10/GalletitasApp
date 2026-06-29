import Foundation

struct CartItem: Identifiable, Codable {
    let id: String
    let productId: String
    let name: String
    let price: Int
    var quantity: Int
    var notes: String
}

extension CartItem {
    var subtotal: Int {
        price * quantity
    }

    var priceFormatted: String {
        Self.format(price)
    }

    var subtotalFormatted: String {
        Self.format(subtotal)
    }

    private static func format(_ cents: Int) -> String {
        let pesos = Double(cents) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.locale = Locale(identifier: "es-AR")
        return formatter.string(from: NSNumber(value: pesos)) ?? "$\(pesos)"
    }
}
