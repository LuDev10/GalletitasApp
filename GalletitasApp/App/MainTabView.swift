import SwiftUI

struct MainTabView: View {
    @State private var cartViewModel = CartViewModel()

    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Label("Menú", systemImage: "menucard")
                }

            CartView()
                .tabItem {
                    Label("Carrito", systemImage: "cart")
                }

            OrderListView()
                .tabItem {
                    Label("Pedidos", systemImage: "shippingbox")
                }

            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
        .environment(cartViewModel)
    }
}

#Preview {
    MainTabView()
}
