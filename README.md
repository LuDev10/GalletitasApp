# GalletitasApp 🍪

App nativa iOS de e-commerce para tienda de galletas.

**Stack:** Swift + SwiftUI + MVVM + Firebase

## Requisitos

- Xcode 15+
- iOS 17+
- Swift Package Manager

## Setup

1. Clonar el repositorio
2. Abrir `GalletitasApp.xcodeproj`
3. Build & Run (`Cmd+R`)

> **Firebase:** Para conectar Firebase, agregar `GoogleService-Info.plist` al proyecto (solicitar al equipo).

## MVPs

| MVP | Estado |
|-----|--------|
| 0 — Fundaciones | 🟢 En progreso |
| 1 — Auth + Catálogo | ⏳ |
| 2 — Carrito + Pedido | ⏳ |
| 3 — Pago (Mercado Pago) | ⏳ |
| 4 — Notificaciones | ⏳ |
| 5 — Pulido | ⏳ |

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

- MVVM: ViewModels como `@ObservableObject`
- Código en inglés, UI en español
- Precios en `Int` (centavos)
- `struct` + `Codable` + `Identifiable` para modelos
