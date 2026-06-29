# Instrucciones para agentes de IA

## Proyecto
GalletitasApp — e-commerce iOS nativo (Swift + SwiftUI)

## Stack
- SwiftUI + MVVM por feature, `@Observable` macro
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

- **MVVM:** cada feature tiene su ViewModel como `@Observable` (iOS 26+)
- **Idioma:** código y nombres en inglés; solo UI/strings al usuario en español
- **Precios:** `Int` representando centavos (evitar `Float`/`Double` para dinero)
- **Modelos:** `struct` + `Codable` + `Identifiable`
- **Servicios:** `class` (NO `actor` — Firebase callbacks incompatibles con actor serialization)
- **Estados:** `enum LoadingState<T> { case loading, loaded(T), error(Error) }`
- **Comentarios:** NO agregar comentarios en código salvo que sean estrictamente necesarios
- **Firebase secrets:** `GoogleService-Info.plist` excluido del repo (.gitignore)
- **Integración Firebase:** `UIApplicationDelegateAdaptor` en AppDelegate, no `FirebaseApp.configure()` en init()

## Orden de implementación (MVPs)

0. Fundaciones (estructura, Firebase setup, navegación base) ← **completado**
1. Auth + Catálogo (registro, login, menú de productos) ← **completado**
2. Carrito + Pedido (carrito persistente, checkout, historial) ← **completado**
3. Pago real (Mercado Pago Cloud Functions + WebView) ← **pendiente**
4. Notificaciones push (FCM + timeline de estados) ← **pendiente**
5. Pulido (búsqueda, favoritos, reseñas, animaciones) ← **pendiente**

## Implementación actual (MVP 0-2 completados)

### Auth
- `AuthService` (class): signIn, createUser, signOut, checkAuthState con Firebase Auth real
- `AuthViewModel`: maneja estados de autenticación
- Login (email/password), Register con validación
- `AuthLandingView` como punto de entrada no autenticado
- Sign in with Apple y Google: definidos en plan pero bloqueados ($99/yr Apple Developer, Google Cloud OAuth)

### Catálogo
- 10 productos de ejemplo cargados localmente en `MenuViewModel`
- `ProductCard` con placeholder de imagen, nombre, descripción, precio, stepper (+/-), botón "Agregar" con feedback verde
- `ProductDetailView` con detalle del producto
- `CartViewModel` compartido via `.environment()` desde MainTabView

### Carrito
- `CartViewModel`: addItem, updateQuantity, removeItem, clearCart, saveCart (UserDefaults via CartPersistenceService)
- `CartView` con Edit mode (trash per row), +/- quantity, total
- Checkout multi-paso dentro de `CheckoutView` (fullScreenCover):
  - **Paso 1:** Formulario (items, selección de dirección take-away vs delivery, notas)
  - **Paso 2:** Pago simulado (selección de método: tarjeta/efectivo/transferencia, card preview mock **•••• 4242**, spinner 1.5s, actualiza Firestore)
  - **Paso 3:** Detalle del pedido inline (header, productos, timeline, total, botón "Cerrar")

### Órdenes
- `OrderStatus` enum con label/icon: pendingPayment, paid, preparing, ready, delivered, cancelled
- `FirestoreService.createOrder()`: crea en `orders/{uid}/user_orders/{orderId}`
- `FirestoreService.updateOrderStatus()`: actualiza status + agrega entrada a statusHistory
- `OrderListView`: carga órdenes desde Firestore, muestra lista con estado
- `OrderDetailView` standalone (desde Orders tab): header, timeline, total
- Se crea orden con `.pendingPayment`, se actualiza a `.preparing` tras mock payment

### Profile
- `ProfileView`: datos del usuario
- `SettingsView`: theme picker (claro/oscuro/sistema), language picker (es/en) con restart alert
- `AddressListView`, `AddressFormView`: gestión de direcciones de entrega
- `LanguageManager`: @AppStorage + AppleLanguages

### Diseño
- `AppTheme`: `#EDE8D0` cream background, brown accents, adaptive colors via `UIColor { $0.userInterfaceStyle == .dark ? dark : light }`
- Componentes: PrimaryButton, ProductCard, LoadingView, CookieIcon

## Reglas de Firestore (firestore.rules)

```
match /users/{uid} { allow read, write: if request.auth.uid == uid; }
match /products/{product} { allow read: if true; allow write: if request.auth.token.admin == true; }
match /orders/{uid}/{document=**} { allow read, write: if request.auth.uid == uid; }
```

> **IMPORTANTE:** Usar `{document=**}` (wildcard recursivo) en `/orders/{uid}/{document=**}` para cubrir subcolección `user_orders`.

## Estado del proyecto

- Build: ✅ compila sin errores
- Repo: https://github.com/LuDev10/GalletitasApp (privado)
- Firebase: conectado, reglas actualizadas en consola
- Pendiente: descomentar placeholder de imagen en ProductCard cuando se agregue Storage
- Pendiente: Sign in with Apple requiere Developer Program
- Pendiente: Google Sign-In requiere Google Cloud OAuth

## Comandos

- Build desde terminal: `xcodebuild -project "GalletitasApp.xcodeproj" -scheme "GalletitasApp" -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build`
- Build: `Cmd+B` (Xcode)
- Test: `Cmd+U` (Xcode)
- Preferir Swift Package Manager sobre CocoaPods
