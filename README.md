# Laboratorio S7-S8 – Mis Productos

Aplicación en Flutter para el curso de Aplicaciones Multiplataforma.

## ¿Qué hace la app?

- **Login** con validación de email y contraseña.
- **Menú** con opciones para registrar, listar, ver el perfil y cerrar sesión.
- **Listar productos** con búsqueda en tiempo real y opción para eliminar.
- **Registrar productos** (nombre, descripción, precio y stock) que se agregan a la lista.
- **Perfil** del usuario con foto y sus datos.

Todas las pantallas tienen un fondo arcoíris animado y botones con degradado.
En el navegador la app se muestra dentro de un marco de celular. Usa íconos de
Font Awesome, fotos reales de los productos (créditos en `assets/CREDITOS.md`)
y permite elegir una foto de la galería al registrar un producto.

## Cómo ejecutarla

```bash
flutter pub get
flutter run -d chrome
```

## Temas aplicados

- ListView y ListView.builder
- ListTile
- Listas y Mapas (`List<Map<String, dynamic>>`)
- Rutas nombradas
- Tema global (ThemeData)
- Cards
