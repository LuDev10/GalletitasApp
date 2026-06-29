import Foundation

struct Category: Identifiable, Codable {
    let id: String
    let name: String
    let order: Int
    let imageUrl: String?
}
