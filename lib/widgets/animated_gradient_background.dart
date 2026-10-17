import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Fondo con degradado arcoiris que se mueve todo el tiempo.
// Se pone "encima" de cada pantalla: AnimatedGradientBackground(child: Scaffold(...))
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

// SingleTickerProviderStateMixin es necesario para el AnimationController
// (le da el "vsync", o sea el reloj que avisa en cada frame)
class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // El controller va de 0 a 1 en 14 segundos y con repeat() vuelve a empezar
    // solito, por eso el fondo nunca se detiene
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    // importante: liberar el controller cuando se cierra la pantalla
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder solo vuelve a dibujar el degradado en cada frame.
    // El child (la pantalla) se pasa aparte para que no se reconstruya.
    return AnimatedBuilder(
      animation: _controller,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) {
        final t = _controller.value;
        // el angulo da una vuelta completa, asi la direccion del degradado gira
        final angulo = t * 2 * pi;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(cos(angulo), sin(angulo)),
              end: Alignment(-cos(angulo), -sin(angulo)),
              // colores pastel (mezclados con blanco) para que se lea bien
              colors: AppTheme.coloresDesplazados(t, aclarar: 0.62),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
