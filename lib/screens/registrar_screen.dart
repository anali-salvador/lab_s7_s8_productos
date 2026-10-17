import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../data/productos.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/entrada_animada.dart';
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

  // bytes de la foto elegida (null = todavia no eligio ninguna).
  // Uso bytes y no File porque File no funciona en el navegador
  Uint8List? _imagenBytes;

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

  // abre la galeria con image_picker
  Future<void> _seleccionarImagen() async {
    try {
      final XFile? archivo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600, // la achico para que no pese tanto
        imageQuality: 85,
      );
      if (archivo == null) return; // cerro la galeria sin elegir
      final bytes = await archivo.readAsBytes();
      if (!mounted) return;
      setState(() => _imagenBytes = bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la galería')),
      );
    }
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
      // si no eligio foto queda null y en la lista sale el icono de caja
      'imagen': _imagenBytes,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.solidCircleCheck,
              size: 18,
              color: AppTheme.turquesa,
            ),
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
              child: EntradaAnimada(
                indice: 0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Nuevo producto',
                            style: textos.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Completa los datos para agregarlo a tu lista',
                            style: textos.bodySmall?.copyWith(
                              color: AppTheme.textoSuave,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _zonaImagen(textos),
                          const SizedBox(height: 22),
                          TextFormField(
                            controller: _nombreCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: IconoCampo(FontAwesomeIcons.tag),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Escribe el nombre del producto'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descripcionCtrl,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: IconoCampo(
                                FontAwesomeIcons.alignLeft,
                              ),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Escribe una descripción'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _precioCtrl,
                            textInputAction: TextInputAction.next,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            // solo deja escribir numeros, punto o coma
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Precio',
                              prefixText: 'S/ ',
                              prefixIcon: IconoCampo(
                                FontAwesomeIcons.moneyBillWave,
                              ),
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
                          const SizedBox(height: 16),
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
                              prefixIcon: IconoCampo(
                                FontAwesomeIcons.boxesStacked,
                              ),
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
                          const SizedBox(height: 28),
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
      ),
    );
  }

  // zona para "seleccionar imagen": si ya eligio una foto la muestra,
  // si no, muestra la camarita
  Widget _zonaImagen(TextTheme textos) {
    final radio = BorderRadius.circular(AppTheme.radio);
    final tieneFoto = _imagenBytes != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radio,
        onTap: _seleccionarImagen,
        child: Ink(
          height: 170,
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
          child: tieneFoto
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radio - 2),
                      child: Image.memory(_imagenBytes!, fit: BoxFit.cover),
                    ),
                    // etiqueta para avisar que se puede cambiar
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.textoOscuro.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidImages,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cambiar',
                              style: textos.labelMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
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
                      style: textos.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Toca para elegir una foto de tu galería',
                      style: textos.bodySmall?.copyWith(
                        color: AppTheme.textoSuave,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
