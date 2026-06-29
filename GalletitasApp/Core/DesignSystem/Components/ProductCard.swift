import SwiftUI

struct ProductCard: View {
    let product: Product
    @State private var quantity = 1
    @State private var added = false
    let onAddToCart: (Product, Int) -> Void

    var body: some View {
        HStack(spacing: 12) {
            imagePlaceholder
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.callout.weight(.semibold))
                    .lineLimit(1)

                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Text(product.priceFormatted)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(AppTheme.secondaryAccent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                        Image(systemName: "minus.circle")
                            .font(.title3)
                    }
                    .disabled(quantity <= 1)
                    .buttonStyle(.plain)

                    Text("\(quantity)")
                        .font(.callout.weight(.semibold))
                        .frame(minWidth: 20)

                    Button(action: { quantity += 1 }) {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }

                Button(action: addToCart) {
                    Group {
                        if added {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark")
                                Text("Agregado")
                            }
                        } else {
                            Text("Agregar")
                        }
                    }
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(added ? Color.green : AppTheme.secondaryAccent)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(added)
            }
        }
        .padding(.vertical, 6)
    }

    private func addToCart() {
        onAddToCart(product, quantity)
        added = true
        quantity = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            added = false
        }
    }

    @ViewBuilder
    private var imagePlaceholder: some View {
        if product.name == "Choco Chip" {
            cookieIcon
        } else if product.name == "Triple Chocolate" {
            cookieIcon
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .overlay {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
        }
    }

    private var cookieIcon: some View {
        CookieIcon(size: 90)
    }
}

#Preview {
    ProductCard(
        product: Product(id: "1", name: "Choco Chip", description: "Galleta con chips de chocolate", price: 120000, imageUrl: nil, categoryId: "1", isAvailable: true, tags: []),
        onAddToCart: { _, _ in }
    )
    .padding(.horizontal)
}
