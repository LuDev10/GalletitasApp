import SwiftUI

struct CartView: View {
    @Environment(CartViewModel.self) private var viewModel
    @State private var editMode = false
    @State private var showCheckout = false

    var body: some View {
        NavigationStack {
            content
                .background(AppTheme.cream)
                .navigationTitle("Carrito")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !viewModel.items.isEmpty {
                            Button(editMode ? "Listo" : "Editar") {
                                withAnimation { editMode.toggle() }
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showCheckout) {
                    CheckoutView()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.items.isEmpty {
            ContentUnavailableView(
                "Carrito vacío",
                systemImage: "cart",
                description: Text("Agregá productos desde el menú")
            )
        } else {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.items) { item in
                        itemRow(item)
                    }

                    Section("Total") {
                        Text(viewModel.subtotalFormatted)
                            .fontWeight(.bold)
                    }
                }
                .scrollContentBackground(.hidden)

                Button(action: { showCheckout = true }) {
                    Text("Confirmar pedido — \(viewModel.subtotalFormatted)")
                        .font(.callout.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.secondaryAccent)
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
    }

    private func itemRow(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            if editMode {
                Button(action: { viewModel.removeItem(id: item.id) }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.callout.weight(.semibold))
                Text(item.priceFormatted)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                Button(action: { viewModel.updateQuantity(itemId: item.id, delta: -1) }) {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                }
                .disabled(item.quantity <= 1)
                .buttonStyle(.plain)

                Text("\(item.quantity)")
                    .font(.callout.weight(.semibold))
                    .frame(minWidth: 20)

                Button(action: { viewModel.updateQuantity(itemId: item.id, delta: 1) }) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }

            Text(item.subtotalFormatted)
                .font(.subheadline.weight(.bold))
                .foregroundColor(AppTheme.secondaryAccent)
                .frame(minWidth: 60, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CartView()
        .environment(CartViewModel())
}
