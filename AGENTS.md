# Instrucciones para agentes de IA

## Proyecto
GalletitasApp — e-commerce iOS nativo (Swift + SwiftUI)

## Stack
- SwiftUI + MVVM por feature
- Firebase Auth (email/password + Apple + Google)
- Cloud Firestore (NoSQL)
- Firebase Storage (imágenes)
- Cloud Functions (Node.js/TypeScript)
- Mercado Pago Checkout Pro (WebView)
- FCM (notificaciones push)

## Estructura de directorios

```
GalletitasApp/
  App/                   ← Entry point, MainTabView
  Core/
    DesignSystem/        ← AppTheme, Components (PrimaryButton, ProductCard, etc.)
    Extensions/          ← View+Extensions, etc.
  Features/
    Auth/                ← AuthViewModel, LoginView, RegisterView
    Menu/                ← MenuViewModel, MenuView, ProductDetailView
    Cart/                ← CartViewModel, CartView, CheckoutView
    Orders/              ← OrdersViewModel, OrderListView, OrderDetailView
    Profile/             ← ProfileViewModel, ProfileView
  Models/                ← Product, CartItem, Order, UserProfile, Category
  Services/              ← AuthService, FirestoreService, CartPersistenceService
```

## Convenciones de código

- **MVVM:** cada feature tiene su ViewModel como `@ObservableObject`/`@StateObject`
- **Idioma:** código y nombres en inglés; solo UI/strings al usuario en español
- **Precios:** `Int` representando centavos (evitar `Float`/`Double` para dinero)
- **Modelos:** `struct` + `Codable` + `Identifiable`
- **Servicios:** `actor` o `class` con `@MainActor` según corresponda
- **Estados:** `enum LoadingState<T> { case loading, loaded(T), error(Error) }`
- **Comentarios:** NO agregar comentarios en código salvo que sean estrictamente necesarios
- **Firebase secrets:** nunca exponer en el cliente; todo sensible va en Cloud Functions

## Orden de implementación (MVPs)

0. Fundaciones (estructura, Firebase setup, navegación base) ← **actual**
1. Auth + Catálogo (registro, login, menú de productos)
2. Carrito + Pedido (carrito persistente, checkout, historial)
3. Pago real (Mercado Pago Cloud Functions + WebView)
4. Notificaciones push (FCM + timeline de estados)
5. Pulido (búsqueda, favoritos, reseñas, animaciones)

## Reglas de Firestore

- `/users/{uid}` → solo lectura/escritura del propio usuario
- `/products` → lectura pública, escritura solo admin
- `/carts/{uid}` → solo lectura/escritura del propio usuario
- `/orders/{uid}` → solo lectura/escritura del propio usuario
- Cálculo de totales siempre del lado del servidor (Cloud Functions)

## Comandos

- Build: `Cmd+B` (Xcode)
- Test: `Cmd+U` (Xcode)
- Preferir Swift Package Manager sobre CocoaPods
