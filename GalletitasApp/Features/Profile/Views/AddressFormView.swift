import SwiftUI

struct AddressFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var alias = ""
    @State private var street = ""
    @State private var city = ""

    let onSave: (DeliveryAddress) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Dirección") {
                    TextField("Nombre o alias (ej: Casa)", text: $alias)
                    TextField("Calle y altura", text: $street)
                    TextField("Ciudad", text: $city)
                }

                Section {
                    Button("Guardar") {
                        let address = DeliveryAddress(
                            alias: alias.isEmpty ? "Dirección" : alias,
                            street: street,
                            city: city,
                            latitude: nil,
                            longitude: nil
                        )
                        onSave(address)
                    }
                    .disabled(alias.isEmpty || street.isEmpty || city.isEmpty)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Nueva dirección")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AddressFormView(onSave: { _ in })
}
