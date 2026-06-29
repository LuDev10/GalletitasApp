import SwiftUI

struct MenuView: View {
    @Environment(CartViewModel.self) private var cartViewModel
    @State private var viewModel = MenuViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.error {
                    VStack(spacing: AppTheme.padding) {
                        Text("Error al cargar el menú")
                        Text(error.localizedDescription)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                } else {
                    List(viewModel.products) { product in
                        ProductCard(product: product) { product, quantity in
                            cartViewModel.addItem(product: product, quantity: quantity)
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.cream)
            .navigationTitle("Menú")
        }
    }
}

#Preview {
    MenuView()
        .environment(CartViewModel())
}
