import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.padding) {
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(Color(.systemGray5))
                    .aspectRatio(1, contentMode: .fit)

                Text(product.name)
                    .font(AppTheme.titleFont)

                Text(product.priceFormatted)
                    .font(.title3)
                    .foregroundColor(AppTheme.secondaryAccent)

                Text(product.description)
                    .foregroundColor(AppTheme.textSecondary)

                Spacer()

                PrimaryButton(title: "Agregar al carrito", action: {})
            }
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(
            product: Product(
                id: "1",
                name: "Galletita con chips",
                description: "Deliciosa galleta artesanal",
                price: 50000,
                imageUrl: nil,
                categoryId: "1",
                isAvailable: true,
                tags: []
            )
        )
    }
}
