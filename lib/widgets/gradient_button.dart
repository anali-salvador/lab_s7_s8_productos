import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Boton reutilizable con degradado arcoiris animado.
// Lo uso en LOGIN, GUARDAR y EDITAR PERFIL.
class GradientButton extends StatefulWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icono; // el icono es opcional

  const GradientButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _presionado = false; // para el efecto de "hundirse" al presionar

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cambiarPresionado(bool valor) {
    setState(() => _presionado = valor);
  }

  @override
  Widget build(BuildContext context) {
    final radio = BorderRadius.circular(22);

    // AnimatedScale hace el boton un poquito mas chico mientras se presiona
    return AnimatedScale(
      scale: _presionado ? 0.95 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final colores = AppTheme.coloresDesplazados(_controller.value);
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: radio,
              gradient: LinearGradient(colors: colores),
              // sombra del mismo color que el degradado
              boxShadow: [
                BoxShadow(
                  color: colores.first.withValues(alpha: _presionado ? 0.25 : 0.45),
                  blurRadius: _presionado ? 6 : 16,
                  offset: Offset(0, _presionado ? 2 : 7),
                ),
              ],
            ),
            child: child,
          );
        },
        // Material + InkWell para tener el efecto de onda al tocar
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radio,
            splashColor: Colors.white24,
            onTap: widget.onPressed,
            onTapDown: (_) => _cambiarPresionado(true),
            onTapUp: (_) => _cambiarPresionado(false),
            onTapCancel: () => _cambiarPresionado(false),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icono != null) ...[
                    Icon(widget.icono, color: Colors.white),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      widget.texto,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
