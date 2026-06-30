# GalletitasApp 🍪

App nativa iOS de e-commerce para tienda de galletas artesanales.

**Stack:** Swift + SwiftUI + MVVM + Firebase (Auth, Firestore, Storage)

## Screenshots

<p float="left">
  <img src="Screenshots/01-auth-landing.png" width="200" />
  <img src="Screenshots/02-login.png" width="200" />
  <img src="Screenshots/03-menu.png" width="200" />
  <img src="Screenshots/04-cart.png" width="200" />
</p>
<p float="left">
  <img src="Screenshots/05-checkout.png" width="200" />
  <img src="Screenshots/06-payment.png" width="200" />
  <img src="Screenshots/07-order-detail.png" width="200" />
  <img src="Screenshots/08-orders.png" width="200" />
</p>
<p float="left">
  <img src="Screenshots/09-profile.png" width="200" />
</p>

> Las screenshots actuales son placeholders. Reemplazar con capturas reales desde Xcode Simulator (⌘S).

## MVPs

| MVP | Estado |
|-----|--------|
| 0 — Fundaciones (estructura, Firebase, navegación) | ✅ |
| 1 — Auth + Catálogo (registro, login, menú de productos) | ✅ |
| 2 — Carrito + Pedido (checkout multi-paso, pago simulado, historial) | ✅ |
| 3 — Pago real (Mercado Pago Cloud Functions + WebView) | ⏳ |
| 4 — Notificaciones push (FCM) | ⏳ |
| 5 — Pulido (búsqueda, favoritos, reseñas) | ⏳ |

## Features

- **Autenticación:** registro y login con email/contraseña (Apple y Google planificados)
- **Catálogo:** productos con imágenes, descripción y selector de cantidad
- **Carrito persistente:** agrega, edita cantidades, elimina items (guardado en UserDefaults)
- **Checkout multi-paso:** formulario de entrega → pago simulado → detalle del pedido
- **Órdenes:** historial con timeline de estados (preparando → listo → entregado)
- **Perfil:** datos personales, direcciones de entrega, preferencias (tema claro/oscuro, idioma es/en)

## Setup

1. Clonar el repositorio
2. Agregar `GoogleService-Info.plist` (solicitar al equipo)
3. Abrir `GalletitasApp.xcodeproj`
4. Build & Run (`Cmd+R`)

> **Firebase:** El archivo `GoogleService-Info.plist` está excluido del repo por seguridad.

## Reglas de Firestore

Ver `firestore.rules`. Las reglas deben actualizarse en Firebase Console.

## Arquitectura

```
GalletitasApp/
├── App/              ← Entry point, MainTabView
├── Core/             ← Design System, componentes, extensiones
├── Features/         ← MVVM por feature (Auth, Menu, Cart, Orders, Profile)
├── Models/           ← Data models (Product, CartItem, Order, etc.)
└── Services/         ← Firebase abstraction, persistencia
```

## Convenciones

- MVVM: ViewModels como `@Observable` (iOS 26+)
- Código en inglés, UI/strings en español
- Precios en `Int` (centavos)
- `struct` + `Codable` + `Identifiable` para modelos
