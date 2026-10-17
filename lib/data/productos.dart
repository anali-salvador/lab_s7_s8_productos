import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Lista global de productos.
// Cada producto es un Map (clave: valor) y todos estan dentro de una List.
// Como es global, la pantalla de listar y la de registrar usan la misma lista,
// entonces si registro uno nuevo aparece en el listado.
List<Map<String, dynamic>> productos = [
  {
    'nombre': 'Laptop',
    'descripcion': 'Laptop de 15 pulgadas, 16 GB de RAM',
    'precio': 3500.00,
    'stock': 10,
    'icono': Icons.laptop_mac_rounded,
    'color': AppTheme.violeta,
  },
  {
    'nombre': 'Mouse',
    'descripcion': 'Mouse inalambrico ergonomico',
    'precio': 50.00,
    'stock': 25,
    'icono': Icons.mouse_rounded,
    'color': AppTheme.rosa,
  },
  {
    'nombre': 'Teclado',
    'descripcion': 'Teclado mecanico con luces RGB',
    'precio': 120.00,
    'stock': 15,
    'icono': Icons.keyboard_rounded,
    'color': AppTheme.naranja,
  },
  {
    'nombre': 'Monitor',
    'descripcion': 'Monitor Full HD de 24 pulgadas',
    'precio': 800.00,
    'stock': 8,
    'icono': Icons.desktop_windows_rounded,
    'color': AppTheme.turquesa,
  },
];

// Convierte el precio a texto tipo "S/ 3,500.00"
String formatearPrecio(num precio) {
  final partes = precio.toStringAsFixed(2).split('.');
  final entero = partes[0];
  final buffer = StringBuffer();
  // le pongo una coma cada 3 digitos contando desde la derecha
  for (int i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) buffer.write(',');
    buffer.write(entero[i]);
  }
  return 'S/ $buffer.${partes[1]}';
}
