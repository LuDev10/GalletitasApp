# GalletitasApp 🍪

App nativa iOS de e-commerce para tienda de galletas artesanales.

**Stack:** Swift + SwiftUI + MVVM + Firebase (Auth, Firestore, Storage)

## Screenshots

<p float="left">
  <img width="200" src="https://github.com/user-attachments/assets/50f28f3e-9473-423b-ab08-24594e5cc612" />
  <img width="200" src="https://github.com/user-attachments/assets/95fff690-550b-4544-997f-036277a2c3d0" />
  <img width="200" src="https://github.com/user-attachments/assets/acc38510-5412-473f-acf0-f02d0bcd6a8c" />
  <img width="200" src="https://github.com/user-attachments/assets/4448e519-67ab-4bc8-8875-e8e915e93a69" />
</p>
<p float="left">
  <img width="200" src="https://github.com/user-attachments/assets/584c14f6-27c2-4206-a08b-20bce40237a0" />
  <img width="200" src="https://github.com/user-attachments/assets/434a458b-3bb6-443c-9c54-9140861cb944" />
  <img width="200" src="https://github.com/user-attachments/assets/a5d5b902-542e-4d42-80cb-2ca90e7c726a" />
  <img width="200" src="https://github.com/user-attachments/assets/52116b42-a2e5-40d7-b4c6-0ee4cbf54b03" />
  <img width="200" src="https://github.com/user-attachments/assets/7c1e8f7b-22e4-488f-82c9-83d34ff91e6e" />


  <img width="200" src="https://github.com/user-attachments/assets/e95eec7b-88bc-4c79-84e6-a922f5c21bf9" />
  <img width="200" src="https://github.com/user-attachments/assets/aa5255f1-67d1-47ff-8652-25df8c600df0" />
</p>
<p float="left">
  <img width="200" src="https://github.com/user-attachments/assets/389eaf50-acde-4f4e-be61-30ae5aba128b" />
  <img width="200" src="https://github.com/user-attachments/assets/df573609-c5fb-4cbf-b4fe-af6a9be54143" />
</p>


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
