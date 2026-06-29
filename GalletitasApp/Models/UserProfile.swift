import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var phone: String?
    var addresses: [DeliveryAddress]
    let createdAt: Date
}
