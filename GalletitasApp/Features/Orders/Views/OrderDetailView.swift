import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                itemsSection
                if let address = order.address {
                    addressSection(address)
                } else {
                    takeAwaySection
                }
                timelineSection
                totalSection
            }
            .padding()
        }
        .background(AppTheme.cream)
        .navigationTitle("Detalle del pedido")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Image(systemName: order.status.icon)
                .font(.system(size: 40))
                .foregroundColor(order.status == .cancelled ? .red : AppTheme.secondaryAccent)

            Text("Pedido #\(order.id.prefix(8).uppercased())")
                .font(.title3.weight(.bold))

            Text(order.status.label)
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryAccent)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(AppTheme.secondaryAccent.opacity(0.15))
                .clipShape(Capsule())

            Text(order.createdAt, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Productos").font(.callout.weight(.semibold))

            ForEach(order.items) { item in
                HStack {
                    Text(item.name)
                        .font(.callout)
                    Spacer()
                    Text("\(item.quantity) x \(item.priceFormatted)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(item.priceFormatted)
                        .font(.subheadline.weight(.medium))
                        .frame(minWidth: 60, alignment: .trailing)
                }
            }
        }
    }

    private func addressSection(_ address: DeliveryAddress) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("Dirección de entrega", systemImage: "location")
                .font(.callout.weight(.semibold))
            Text(address.alias)
                .font(.subheadline)
            Text("\(address.street), \(address.city)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var takeAwaySection: some View {
        Label("Take away — retiro en local", systemImage: "bag")
            .font(.callout.weight(.semibold))
    }

    private var timelineSection: some View {
        let steps = orderedTimeline
        return VStack(alignment: .leading, spacing: 12) {
            Text("Estado").font(.callout.weight(.semibold))

            ForEach(0..<steps.count, id: \.self) { i in
                let entry = steps[i]
                HStack(spacing: 12) {
                    Circle()
                        .fill(entry.isActive ? AppTheme.secondaryAccent : Color(.systemGray4))
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading) {
                        Text(entry.status.label)
                            .font(.subheadline.weight(entry.isActive ? .semibold : .regular))
                        Text(entry.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if entry.isActive {
                        Image(systemName: "checkmark")
                            .font(.caption)
                    }
                }
            }
        }
    }

    private var totalSection: some View {
        VStack(spacing: 4) {
            Divider()
            HStack {
                Text("Total")
                    .font(.title3.weight(.bold))
                Spacer()
                Text(order.totalFormatted)
                    .font(.title3.weight(.bold))
                    .foregroundColor(AppTheme.secondaryAccent)
            }
            .padding(.top, 4)
        }
    }

    private var orderedTimeline: [(status: OrderStatus, timestamp: Date, isActive: Bool)] {
        let allSteps: [OrderStatus] = [.preparing, .ready, .delivered]
        return allSteps.map { status in
            let entry = order.statusHistory.first { $0.status == status }
            return (status, entry?.timestamp ?? order.createdAt, entry != nil)
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(
            order: Order(
                id: "abc123def456",
                uid: "user1",
                items: [
                    CartItem(id: "1", productId: "p1", name: "Choco Chip", price: 120000, quantity: 2, notes: ""),
                    CartItem(id: "2", productId: "p2", name: "Nutella", price: 200000, quantity: 1, notes: ""),
                ],
                subtotal: 440000,
                deliveryFee: 0,
                total: 440000,
                status: .preparing,
                address: nil,
                paymentId: nil,
                createdAt: Date(),
                statusHistory: [StatusEntry(status: .preparing, timestamp: Date())]
            )
        )
    }
}
