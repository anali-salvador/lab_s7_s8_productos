import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// En este archivo esta TODO el tema de la app.
// La idea es definir colores, letras y formas una sola vez y que todas
// las pantallas lo usen con Theme.of(context), asi no repito estilos.
class AppTheme {
  // ---- Paleta de colores propia (nada del azul por defecto) ----
  static const Color violeta = Color(0xFF7C4DFF);
  static const Color rosa = Color(0xFFFF4F9A);
  static const Color naranja = Color(0xFFFF8A3D);
  static const Color turquesa = Color(0xFF17C3A8);
  static const Color amarillo = Color(0xFFFFB800);

  static const Color textoOscuro = Color(0xFF2E2A47);
  static const Color textoSuave = Color(0xFF7A7690);
  static const Color rojoError = Color(0xFFE5395B);

  // Los colores del arcoiris en orden, los uso en el fondo y en los botones
  static const List<Color> arcoiris = [violeta, rosa, naranja, amarillo, turquesa];

  // Degradados de 2 colores para los iconos de cada seccion
  static const List<Color> degradadoVioleta = [violeta, Color(0xFFB57BFF)];
  static const List<Color> degradadoRosa = [rosa, Color(0xFFFF8FB8)];
  static const List<Color> degradadoNaranja = [naranja, amarillo];
  static const List<Color> degradadoTurquesa = [turquesa, Color(0xFF5EE0C9)];
  static const List<Color> degradadoAmarillo = [amarillo, naranja];

  // radio de las esquinas que uso casi en todo
  static const double radio = 24;

  // Devuelve un degradado a partir de un solo color (para los productos)
  static List<Color> degradadoDe(Color color) {
    return [color, Color.lerp(color, rosa, 0.45)!];
  }

  // Esta funcion "corre" los colores del arcoiris segun t (de 0 a 1).
  // Asi cuando t va cambiando con la animacion, los colores se mueven.
  // aclarar sirve para mezclar con blanco y que quede tipo pastel.
  static List<Color> coloresDesplazados(double t, {double aclarar = 0}) {
    final n = arcoiris.length;
    return List.generate(n, (i) {
      final pos = ((i / n + t) % 1.0) * n;
      final a = pos.floor() % n;
      final b = (a + 1) % n;
      final color = Color.lerp(arcoiris[a], arcoiris[b], pos - pos.floor())!;
      return Color.lerp(color, Colors.white, aclarar)!;
    });
  }

  // ---- ThemeData: aqui se arma el tema global ----
  static ThemeData get tema {
    // ColorScheme con mis colores. fromSeed genera los tonos que faltan
    final colorScheme = ColorScheme.fromSeed(
      seedColor: violeta,
      primary: violeta,
      secondary: rosa,
      tertiary: turquesa,
      error: rojoError,
      surface: Colors.white,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    // Tipografia Poppins de google_fonts para todos los textos
    final textos = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: textoOscuro,
      displayColor: textoOscuro,
    );

    // bordes redondeados de los inputs (los reutilizo abajo)
    OutlineInputBorder borde(Color color, double ancho) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: color, width: ancho),
      );
    }

    return base.copyWith(
      // transparente porque cada pantalla tiene el fondo arcoiris animado
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textos,

      // AppBar blanco semitransparente con esquinas de abajo redondeadas
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.72),
        foregroundColor: textoOscuro,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: violeta),
        actionsIconTheme: const IconThemeData(color: violeta),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textoOscuro,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
      ),

      // Cards blancas semitransparentes con sombra suave de color
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.86),
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: violeta.withValues(alpha: 0.18),
        margin: const EdgeInsets.symmetric(vertical: 7),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radio),
        ),
      ),

      // Inputs: relleno blanco, bordes de color y cuando tiene foco se pone rosa
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) return rojoError;
          if (states.contains(WidgetState.focused)) return rosa;
          return violeta;
        }),
        suffixIconColor: violeta,
        labelStyle: GoogleFonts.poppins(color: textoSuave),
        hintStyle: GoogleFonts.poppins(color: textoSuave.withValues(alpha: 0.7)),
        floatingLabelStyle: GoogleFonts.poppins(
          color: rosa,
          fontWeight: FontWeight.w600,
        ),
        prefixStyle: GoogleFonts.poppins(
          color: violeta,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.poppins(color: rojoError, fontSize: 12),
        border: borde(violeta.withValues(alpha: 0.3), 1.5),
        enabledBorder: borde(violeta.withValues(alpha: 0.3), 1.5),
        focusedBorder: borde(rosa, 2.5),
        errorBorder: borde(rojoError.withValues(alpha: 0.7), 1.5),
        focusedErrorBorder: borde(rojoError, 2.5),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: rosa,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      // ListTile con esquinas redondeadas para que el efecto al tocar no se salga
      listTileTheme: ListTileThemeData(
        iconColor: violeta,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radio),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textoOscuro,
        ),
        subtitleTextStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: textoSuave,
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: GoogleFonts.poppins(color: textoOscuro),
      ),

      // SnackBar flotante y redondeado
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textoOscuro,
        elevation: 6,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      dividerTheme: DividerThemeData(
        color: violeta.withValues(alpha: 0.1),
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(color: rosa),

      // flecha de "atras" del AppBar con icono de Font Awesome
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) =>
            const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
      ),

      // Transicion suave entre pantallas (igual en todas las plataformas)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// Circulo con degradado y un icono blanco adentro.
// Lo uso en el logo, en el menu, en los productos, etc.
class CirculoDegradado extends StatelessWidget {
  final FaIconData icono;
  final List<Color> colores;
  final double tamano;

  const CirculoDegradado({
    super.key,
    required this.icono,
    required this.colores,
    this.tamano = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colores.first.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: FaIcon(icono, color: Colors.white, size: tamano * 0.42),
      ),
    );
  }
}
