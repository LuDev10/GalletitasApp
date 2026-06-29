import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Int
    let imageUrl: String?
    let categoryId: String?
    let isAvailable: Bool
    let tags: [String]
}

extension Product {
    var priceFormatted: String {
        let pesos = Double(price) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.locale = Locale(identifier: "es-AR")
        return formatter.string(from: NSNumber(value: pesos)) ?? "$\(pesos)"
    }
}
