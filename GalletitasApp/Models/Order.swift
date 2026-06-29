import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let uid: String
    let items: [CartItem]
    let subtotal: Int
    let deliveryFee: Int
    let total: Int
    let status: OrderStatus
    let address: DeliveryAddress?
    let paymentId: String?
    let createdAt: Date
    let statusHistory: [StatusEntry]
}

extension Order {
    var totalFormatted: String {
        let pesos = Double(total) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.locale = Locale(identifier: "es-AR")
        return formatter.string(from: NSNumber(value: pesos)) ?? "$\(pesos)"
    }
}

enum OrderStatus: String, Codable {
    case pendingPayment = "pending_payment"
    case paid
    case preparing
    case ready
    case delivered
    case cancelled

    var label: String {
        switch self {
        case .pendingPayment: return "Pendiente de pago"
        case .paid: return "Pagado"
        case .preparing: return "Preparando"
        case .ready: return "Listo para retirar"
        case .delivered: return "Entregado"
        case .cancelled: return "Cancelado"
        }
    }

    var icon: String {
        switch self {
        case .pendingPayment: return "clock"
        case .paid: return "creditcard"
        case .preparing: return "flame"
        case .ready: return "bag.badge.checkmark"
        case .delivered: return "checkmark.circle"
        case .cancelled: return "xmark.circle"
        }
    }
}

struct DeliveryAddress: Codable {
    let alias: String
    let street: String
    let city: String
    let latitude: Double?
    let longitude: Double?
}

struct StatusEntry: Codable {
    let status: OrderStatus
    let timestamp: Date
}
