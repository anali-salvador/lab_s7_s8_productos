# Partes del código que no vimos en clase

Aquí anoto las cosas que usé en el laboratorio pero que no se explicaron en clase, para acordarme qué hace cada una.

---

## 1. AnimationController y repeat()

**Archivo:** `lib/widgets/animated_gradient_background.dart`

```dart
_controller = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 14),
)..repeat();
```

El controller es como un contador que va de 0 a 1 en el tiempo que le pongo (14 segundos). Con `repeat()` vuelve a empezar solo, por eso el fondo nunca se detiene. Hay que agregar `SingleTickerProviderStateMixin` para el `vsync` y hacer `dispose()` al final.

---

## 2. AnimatedBuilder

**Archivo:** `lib/widgets/animated_gradient_background.dart`

```dart
return AnimatedBuilder(
  animation: _controller,
  child: RepaintBoundary(child: widget.child),
  builder: (context, child) {
    final t = _controller.value;
```

Vuelve a ejecutar el `builder` cada vez que cambia el controller, así el degradado se mueve. La pantalla se pasa en `child` para que no se reconstruya entera en cada frame, solo el fondo.

---

## 3. google_fonts

**Archivo:** `lib/theme/app_theme.dart`

```dart
final textos = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
  bodyColor: textoOscuro,
  displayColor: textoOscuro,
);
```

Es un paquete que descarga fuentes de Google Fonts. Con `poppinsTextTheme` todos los textos de la app usan Poppins sin ponerlo en cada `Text`. Tuve que usar la versión 8 porque la 9 me daba error con el `TextTheme`.

---

## 4. Colores que se desplazan (coloresDesplazados)

**Archivo:** `lib/theme/app_theme.dart`

```dart
final pos = ((i / n + t) % 1.0) * n;
final a = pos.floor() % n;
final b = (a + 1) % n;
final color = Color.lerp(arcoiris[a], arcoiris[b], pos - pos.floor())!;
return Color.lerp(color, Colors.white, aclarar)!;
```

Esta función mueve los colores del arcoíris según el valor `t` de la animación. `Color.lerp` mezcla dos colores, y al mezclar con blanco quedan más pastel para el fondo.

---

## 5. El widget CirculoDegradado

**Archivo:** `lib/theme/app_theme.dart`

```dart
decoration: BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    colors: colores,
```

Es un widget que hice yo para el círculo de color con un ícono blanco. Lo uso en el logo, en el menú, en los productos y en otros lados, así no repito el mismo `Container` muchas veces.

---

## 6. Borde arcoíris que gira en el perfil

**Archivo:** `lib/screens/perfil_screen.dart`

```dart
gradient: SweepGradient(
  colors: const [...AppTheme.arcoiris, AppTheme.violeta],
  transform: GradientRotation(_controller.value * 2 * pi),
),
```

`SweepGradient` pone los colores alrededor de un círculo, como una ruleta. Con `GradientRotation` lo giro según el controller, y como la foto está encima con un poco de padding, solo se ve el borde girando.

---

## 7. loadingBuilder y errorBuilder de Image.network

**Archivo:** `lib/screens/perfil_screen.dart`

```dart
loadingBuilder: (context, child, progreso) {
  if (progreso == null) return child;
  return const Center(child: CircularProgressIndicator());
},
errorBuilder: (context, error, stackTrace) {
```

`loadingBuilder` muestra un circulito de carga mientras baja la foto. `errorBuilder` muestra un ícono de persona si no hay internet o falla la imagen, así la app no se ve rota.

---

## 8. webHtmlElementStrategy (foto en el navegador)

**Archivo:** `lib/screens/perfil_screen.dart`

```dart
Image.network(
  _fotoUrl,
  fit: BoxFit.cover,
  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
```

En Chrome la foto no cargaba porque la página de randomuser no da permiso (CORS). Con esta opción Flutter usa una etiqueta `<img>` normal cuando falla, y así sí se ve.

---

## 9. Permiso de Internet en Android

**Archivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <application
```

Sin este permiso la app instalada en el celular no puede usar internet, entonces no cargaría la foto del perfil ni la fuente Poppins. En modo debug a veces funciona igual, pero es mejor ponerlo.

---

## 10. Efecto al presionar el botón (AnimatedScale e InkWell)

**Archivo:** `lib/widgets/gradient_button.dart`

```dart
return AnimatedScale(
  scale: _presionado ? 0.95 : 1,
  duration: const Duration(milliseconds: 120),
```

Cuando presiono el botón se hace un poquito más chico y luego vuelve, como si se hundiera. El `InkWell` de adentro avisa con `onTapDown` y `onTapUp` y además hace la onda al tocar.

---

## 11. Color del ícono según el foco (WidgetStateColor)

**Archivo:** `lib/theme/app_theme.dart`

```dart
prefixIconColor: WidgetStateColor.resolveWith((states) {
  if (states.contains(WidgetState.error)) return rojoError;
  if (states.contains(WidgetState.focused)) return rosa;
  return violeta;
}),
```

Sirve para que el ícono del input cambie de color según su estado: rojo si hay error, rosa cuando estoy escribiendo y violeta normal.

---

## 12. Solo números en precio y stock (inputFormatters)

**Archivo:** `lib/screens/registrar_screen.dart`

```dart
inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
],
```

No deja escribir letras en el campo de precio, solo números, punto o coma. En stock uso `digitsOnly` para que sea entero.

---

## 13. mounted después de volver de otra pantalla

**Archivo:** `lib/screens/listar_screen.dart`

```dart
await Navigator.pushNamed(context, '/registrar');
if (mounted) setState(() {});
```

Espero a que vuelva de registrar y recién actualizo la lista. El `mounted` revisa que la pantalla todavía exista antes de llamar a `setState`, porque si no puede salir un error.
