import 'package:flutter/material.dart';

// Animacion de entrada para las cards: aparecen con un fade y suben un poquito.
// El indice sirve para que cada card entre un poco despues que la anterior
// (efecto "cascada").
class EntradaAnimada extends StatelessWidget {
  final int indice;
  final Widget child;

  const EntradaAnimada({super.key, required this.indice, required this.child});

  @override
  Widget build(BuildContext context) {
    // TweenAnimationBuilder anima un valor de 0 a 1 una sola vez al aparecer
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      // las primeras cards tienen menos espera, despues ya no aumenta tanto
      duration: Duration(milliseconds: 450 + 90 * indice.clamp(0, 6)),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, valor, child) {
        return Opacity(
          opacity: valor,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - valor)),
            child: child,
          ),
        );
      },
    );
  }
}
