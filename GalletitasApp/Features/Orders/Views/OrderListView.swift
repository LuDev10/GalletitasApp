import SwiftUI

struct OrderListView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var viewModel = OrdersViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "Sin pedidos",
                        systemImage: "shippingbox",
                        description: Text("Tus pedidos aparecerán acá")
                    )
                } else {
                    List(viewModel.orders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            HStack {
                                Image(systemName: order.status.icon)
                                    .foregroundColor(order.status == .cancelled ? .red : AppTheme.secondaryAccent)
                                    .font(.title3)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Pedido #\(order.id.prefix(8).uppercased())")
                                        .font(.callout.weight(.semibold))
                                    HStack(spacing: 4) {
                                        Text(order.status.label)
                                            .font(.caption)
                                        Text("·")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(order.createdAt, style: .date)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(order.totalFormatted)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(AppTheme.secondaryAccent)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.cream)
            .navigationTitle("Pedidos")
            .task {
                if let uid = authViewModel.currentUser?.id {
                    await viewModel.loadOrders(for: uid)
                }
            }
            .onChange(of: authViewModel.currentUser?.id) { _, newId in
                Task {
                    if let uid = newId { await viewModel.loadOrders(for: uid) }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OrderListView()
            .environment(AuthViewModel())
    }
}
