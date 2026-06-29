import SwiftUI

@Observable
class MenuViewModel {
    var products: [Product] = []
    var categories: [Category] = []
    var isLoading = false
    var error: Error?

    init() {
        loadSampleProducts()
    }

    private func loadSampleProducts() {
        products = [
            Product(id: "1", name: "Choco Chip", description: "La clásica galleta con chips de chocolate semiamargo", price: 120000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["chocolate", "clásica"]),
            Product(id: "2", name: "Chocolate Dubai", description: "Galleta con chocolate Dubai y pistacho", price: 150000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["chocolate", "premium"]),
            Product(id: "3", name: "Red Velvet", description: "Galleta red velvet con frosting de queso crema", price: 180000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["red velvet", "frosting"]),
            Product(id: "4", name: "Nueces", description: "Galleta crocante con nueces pecanas y canela", price: 140000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["nueces", "crocante"]),
            Product(id: "5", name: "Brownie", description: "Galleta brownie con corazón de chocolate fundido", price: 160000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["brownie", "chocolate"]),
            Product(id: "6", name: "Vainilla con Chocolate", description: "Galleta de vainilla con chips de chocolate blanco", price: 120000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["vainilla", "chocolate blanco"]),
            Product(id: "7", name: "Nutella", description: "Galleta rellena de Nutella con avellanas", price: 200000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["nutella", "rellena"]),
            Product(id: "8", name: "Maní", description: "Galleta salada con maní tostado y chocolate", price: 130000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["maní", "salada"]),
            Product(id: "9", name: "Avena y Pasas", description: "Galleta de avena con pasas de uva y miel", price: 110000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["avena", "pasas"]),
            Product(id: "10", name: "Triple Chocolate", description: "Galleta con chocolate semiamargo, blanco y con leche", price: 220000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: ["triple chocolate", "premium"]),
        ]
    }
}
