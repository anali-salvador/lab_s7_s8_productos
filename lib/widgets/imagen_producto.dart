import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

// Miniatura de la foto de un producto, con esquinas redondeadas y borde de color.
// La clave 'imagen' del Map puede ser:
//  - un String con la ruta del asset (los productos que ya vienen en la app)
//  - bytes (Uint8List) de la foto que se elige con image_picker
//  - null si no tiene foto, ahi muestro un icono de caja
class ImagenProducto extends StatelessWidget {
  final Map<String, dynamic> producto;
  final double tamano;

  const ImagenProducto({super.key, required this.producto, this.tamano = 60});

  @override
  Widget build(BuildContext context) {
    final Color color = producto['color'];
    final colores = AppTheme.degradadoDe(color);
    final imagen = producto['imagen'];

    // lo que se muestra si no hay foto o si la foto no carga
    Widget respaldo() {
      return DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(colors: colores)),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.box,
            color: Colors.white,
            size: tamano * 0.38,
          ),
        ),
      );
    }

    Widget contenido;
    if (imagen is String) {
      contenido = Image.asset(
        imagen,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => respaldo(),
      );
    } else if (imagen is Uint8List) {
      contenido = Image.memory(
        imagen,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => respaldo(),
      );
    } else {
      contenido = respaldo();
    }

    // el borde de color es un Container con degradado y un poquito de padding
    return Container(
      width: tamano,
      height: tamano,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.5),
        child: ColoredBox(color: Colors.white, child: contenido),
      ),
    );
  }
}
