import SwiftUI

enum CheckoutStep {
    case form
    case payment(Order)
    case done(Order)
}

struct CheckoutView: View {
    @Environment(CartViewModel.self) private var cartViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedAddress: DeliveryAddress?
    @State private var notes = ""
    @State private var isProcessing = false
    @State private var step: CheckoutStep = .form
    @State private var error: Error?

    private let firestoreService = FirestoreService()

    private var isTakeAway: Bool {
        selectedAddress == nil
    }

    var body: some View {
        NavigationStack {
            switch step {
            case .form:
                checkoutForm
            case .payment(let order):
                MockPaymentView(order: order, firestoreService: firestoreService, onPaid: {
                    step = .done(order)
                }, isProcessing: $isProcessing)
            case .done(let order):
                orderDetailView(order)
            }
        }
    }

    // MARK: - Step 1: Checkout Form

    private var checkoutForm: some View {
        Form {
            Section("Productos") {
                ForEach(cartViewModel.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) x \(item.priceFormatted)")
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text(cartViewModel.subtotalFormatted)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.secondaryAccent)
                }
            }

            Section("Entrega") {
                Button(action: { selectedAddress = nil }) {
                    HStack {
                        Image(systemName: "bag")
                            .foregroundColor(isTakeAway ? AppTheme.secondaryAccent : .gray)
                        Text("Take away — retiro en local")
                            .foregroundColor(isTakeAway ? .primary : .secondary)
                        Spacer()
                        if isTakeAway { Image(systemName: "checkmark").foregroundColor(AppTheme.secondaryAccent) }
                    }
                }
                .buttonStyle(.plain)

                if let addresses = authViewModel.currentUser?.addresses, !addresses.isEmpty {
                    ForEach(addresses.indices, id: \.self) { index in
                        let address = addresses[index]
                        Button(action: { selectedAddress = address }) {
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(selectedAddress?.street == address.street ? AppTheme.secondaryAccent : .gray)
                                VStack(alignment: .leading) {
                                    Text(address.alias).font(.callout)
                                    Text("\(address.street), \(address.city)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedAddress?.street == address.street {
                                    Image(systemName: "checkmark").foregroundColor(AppTheme.secondaryAccent)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section("Notas") {
                TextField("Algún comentario...", text: $notes)
            }

            Section {
                Button(action: processOrder) {
                    if isProcessing {
                        HStack { Spacer(); ProgressView().tint(.white); Spacer() }
                    } else {
                        Text("Confirmar pedido — \(cartViewModel.subtotalFormatted)")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isProcessing)
                .listRowBackground(AppTheme.secondaryAccent)
                .foregroundColor(.white)
            }

            if let error {
                Section { Text(error.localizedDescription).foregroundColor(AppTheme.error) }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
                    .disabled(isProcessing)
            }
        }
    }

    // MARK: - Step 3: Order Detail

    private func orderDetailView(_ order: Order) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection(order)
                itemsSection(order)
                if let address = order.address {
                    addressSection(address)
                } else {
                    takeAwaySection
                }
                timelineSection(order)
                totalSection(order)
            }
            .padding()
        }
        .background(AppTheme.cream)
        .navigationTitle("Pedido confirmado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Cerrar") { dismiss() }
            }
        }
    }

    private func headerSection(_ order: Order) -> some View {
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

    private func itemsSection(_ order: Order) -> some View {
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
                    Text(item.subtotalFormatted)
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

    private func timelineSection(_ order: Order) -> some View {
        let allSteps: [OrderStatus] = [.preparing, .ready, .delivered]
        let steps = allSteps.map { status -> (OrderStatus, Date, Bool) in
            let entry = order.statusHistory.first { $0.status == status }
            return (status, entry?.timestamp ?? order.createdAt, entry != nil)
        }

        return VStack(alignment: .leading, spacing: 12) {
            Text("Estado").font(.callout.weight(.semibold))

            ForEach(0..<steps.count, id: \.self) { i in
                let (status, timestamp, isActive) = steps[i]
                HStack(spacing: 12) {
                    Circle()
                        .fill(isActive ? AppTheme.secondaryAccent : Color(.systemGray4))
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading) {
                        Text(status.label)
                            .font(.subheadline.weight(isActive ? .semibold : .regular))
                        Text(timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if isActive {
                        Image(systemName: "checkmark")
                            .font(.caption)
                    }
                }
            }
        }
    }

    private func totalSection(_ order: Order) -> some View {
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

    // MARK: - Actions

    private func processOrder() {
        guard let user = authViewModel.currentUser else { return }
        isProcessing = true
        error = nil

        Task {
            do {
                let orderId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "").prefix(16).description
                let items = cartViewModel.items
                let subtotal = cartViewModel.subtotal
                let now = Date()

                let order = Order(
                    id: orderId,
                    uid: user.id,
                    items: items,
                    subtotal: subtotal,
                    deliveryFee: 0,
                    total: subtotal,
                    status: .pendingPayment,
                    address: selectedAddress,
                    paymentId: nil,
                    createdAt: now,
                    statusHistory: [
                        StatusEntry(status: .pendingPayment, timestamp: now)
                    ]
                )

                try await firestoreService.createOrder(order)
                cartViewModel.clearCart()
                step = .payment(order)
            } catch {
                self.error = error
            }
            isProcessing = false
        }
    }
}

// MARK: - Step 2: Mock Payment

private struct MockPaymentView: View {
    let order: Order
    let firestoreService: FirestoreServiceProtocol
    let onPaid: () -> Void
    @Binding var isProcessing: Bool

    @State private var selectedMethod: PaymentMethod = .card
    @State private var showSuccess = false
    @State private var payError: Error?

    enum PaymentMethod: String, CaseIterable {
        case card = "Tarjeta de crédito/débito"
        case cash = "Efectivo"
        case transfer = "Transferencia"

        var icon: String {
            switch self {
            case .card: return "creditcard"
            case .cash: return "banknote"
            case .transfer: return "building.columns"
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header

                orderSummary

                VStack(alignment: .leading, spacing: 12) {
                    Text("Método de pago")
                        .font(.headline)

                    ForEach(PaymentMethod.allCases, id: \.self) { method in
                        Button(action: { selectedMethod = method }) {
                            HStack {
                                Image(systemName: method.icon)
                                    .foregroundColor(selectedMethod == method ? AppTheme.secondaryAccent : .gray)
                                    .frame(width: 28)
                                Text(method.rawValue)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedMethod == method {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.secondaryAccent)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(selectedMethod == method ? AppTheme.secondaryAccent : Color(.systemGray4), lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                cardPreview

                Button(action: pay) {
                    HStack {
                        if isProcessing {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "lock.fill")
                            Text("Pagar \(order.totalFormatted)")
                        }
                    }
                    .font(.callout.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isProcessing ? Color.gray : AppTheme.secondaryAccent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                }
                .disabled(isProcessing)

                if let payError {
                    Text(payError.localizedDescription)
                        .font(.caption)
                        .foregroundColor(AppTheme.error)
                }
            }
            .padding()
        }
        .background(AppTheme.cream)
        .navigationTitle("Pago")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { onPaid() }
                    .disabled(isProcessing)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 36))
                .foregroundColor(AppTheme.secondaryAccent)

            Text("Simulación de pago")
                .font(.title3.weight(.bold))

            Text("Este es un pago de prueba — no se usa dinero real")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var orderSummary: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Pedido #\(order.id.prefix(8).uppercased())")
                    .font(.callout.weight(.semibold))
                Text("\(order.items.count) producto(s)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(order.totalFormatted)
                .font(.title2.weight(.bold))
                .foregroundColor(AppTheme.secondaryAccent)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("•••• •••• •••• 4242")
                    .font(.title3.monospaced())
                Spacer()
                Image(systemName: "creditcard")
                    .font(.title2)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("TITULAR")
                        .font(.caption2)
                    Text("GALLETITAS APP")
                        .font(.callout)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("VENCE")
                        .font(.caption2)
                    Text("12/28")
                        .font(.callout)
                }
                VStack(alignment: .leading) {
                    Text("CVV")
                        .font(.caption2)
                    Text("123")
                        .font(.callout)
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(
            LinearGradient(colors: [.brown, AppTheme.secondaryAccent], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func pay() {
        isProcessing = true
        payError = nil

        Task {
            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)

                try await firestoreService.updateOrderStatus(
                    orderId: order.id,
                    orderUid: order.uid,
                    status: .preparing
                )

                isProcessing = false
                onPaid()
            } catch {
                payError = error
                isProcessing = false
            }
        }
    }
}

#Preview {
    CheckoutView()
        .environment(CartViewModel())
        .environment(AuthViewModel())
}
