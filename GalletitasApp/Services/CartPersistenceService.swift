import Foundation

actor CartPersistenceService {
    private let userDefaultsKey = "saved_cart"

    func saveCart(_ items: [CartItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    func loadCart() -> [CartItem] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let items = try? JSONDecoder().decode([CartItem].self, from: data)
        else { return [] }
        return items
    }

    func clearCart() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
