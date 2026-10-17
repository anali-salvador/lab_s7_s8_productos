import 'package:flutter_test/flutter_test.dart';
import 'package:lab_s7_s8_productos/data/productos.dart';

void main() {
  test('formatearPrecio pone S/, comas y dos decimales', () {
    expect(formatearPrecio(3500), 'S/ 3,500.00');
    expect(formatearPrecio(50), 'S/ 50.00');
    expect(formatearPrecio(1234567.5), 'S/ 1,234,567.50');
  });

  test('la lista inicial tiene los 4 productos', () {
    expect(productos.length, 4);
    expect(productos.first['nombre'], 'Laptop');
  });
}
