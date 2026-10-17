import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import '../data/productos.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/gradient_button.dart';

class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  State<RegistrarScreen> createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  // acepta 12.50 o 12,50
  double? _leerPrecio(String texto) {
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreCtrl.text.trim();
    // el color va rotando segun cuantos productos hay
    // (le resto 1 para que el primero nuevo salga amarillo y no repita el turquesa)
    final n = AppTheme.arcoiris.length;
    final color = AppTheme.arcoiris[(productos.length + n - 1) % n];

    // agrego un Map nuevo a la lista global (con las mismas claves que los otros)
    productos.add({
      'nombre': nombre,
      'descripcion': _descripcionCtrl.text.trim(),
      'precio': _leerPrecio(_precioCtrl.text)!,
      'stock': int.parse(_stockCtrl.text),
      'icono': FontAwesomeIcons.box,
      'color': color,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 18, color: AppTheme.turquesa),
            const SizedBox(width: 12),
            Expanded(child: Text('"$nombre" se guardó correctamente')),
          ],
        ),
      ),
    );
    // regreso a la pantalla anterior
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AnimatedGradientBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Registrar Producto')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _zonaImagen(textos),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nombreCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: FaIcon(FontAwesomeIcons.tag, size: 18),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Escribe el nombre del producto'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _descripcionCtrl,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            prefixIcon: FaIcon(FontAwesomeIcons.alignLeft, size: 18),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Escribe una descripción'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _precioCtrl,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          // solo deja escribir numeros, punto o coma
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            prefixText: 'S/ ',
                            prefixIcon: FaIcon(FontAwesomeIcons.moneyBillWave, size: 18),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Escribe el precio';
                            }
                            final precio = _leerPrecio(v);
                            if (precio == null || precio <= 0) {
                              return 'El precio debe ser mayor a 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _stockCtrl,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onFieldSubmitted: (_) => _guardar(),
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            prefixIcon: FaIcon(FontAwesomeIcons.boxesStacked, size: 18),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Escribe el stock';
                            }
                            if (int.tryParse(v) == null) {
                              return 'El stock debe ser un número entero';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 26),
                        GradientButton(
                          texto: 'GUARDAR',
                          icono: FontAwesomeIcons.solidFloppyDisk,
                          onPressed: _guardar,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // zona para "seleccionar imagen" (por ahora es solo decorativa)
  Widget _zonaImagen(TextTheme textos) {
    final radio = BorderRadius.circular(AppTheme.radio);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radio,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La galería estará disponible pronto')),
          );
        },
        child: Ink(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: radio,
            gradient: LinearGradient(
              colors: [
                AppTheme.naranja.withValues(alpha: 0.12),
                AppTheme.rosa.withValues(alpha: 0.12),
              ],
            ),
            border: Border.all(
              color: AppTheme.rosa.withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CirculoDegradado(
                icono: FontAwesomeIcons.solidCamera,
                colores: [AppTheme.naranja, AppTheme.rosa],
                tamano: 60,
              ),
              const SizedBox(height: 10),
              Text(
                'Seleccionar imagen',
                style: textos.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                'Toca para elegir una foto',
                style: textos.bodySmall?.copyWith(color: AppTheme.textoSuave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
