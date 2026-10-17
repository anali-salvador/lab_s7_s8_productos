import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/productos.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class ListarScreen extends StatefulWidget {
  const ListarScreen({super.key});

  @override
  State<ListarScreen> createState() => _ListarScreenState();
}

class _ListarScreenState extends State<ListarScreen> {
  final _buscarCtrl = TextEditingController();
  String _busqueda = '';

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  // Filtrado: me quedo solo con los productos cuyo nombre contiene
  // lo que se escribio. Paso todo a minusculas para que no importe
  // si escriben "LAP" o "lap". Si la busqueda esta vacia salen todos.
  List<Map<String, dynamic>> get _filtrados {
    final texto = _busqueda.trim().toLowerCase();
    return productos
        .where((p) => (p['nombre'] as String).toLowerCase().contains(texto))
        .toList();
  }

  Future<void> _irARegistrar() async {
    // espero a que vuelva de registrar y con setState se redibuja la lista
    await Navigator.pushNamed(context, '/registrar');
    if (mounted) setState(() {});
  }

  void _eliminar(Map<String, dynamic> producto) {
    // borro el mapa directamente (no por indice, porque la lista puede estar filtrada)
    setState(() => productos.remove(producto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Se eliminó "${producto['nombre']}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _filtrados;
    final textos = Theme.of(context).textTheme;

    return AnimatedGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Listar Productos'),
          actions: [
            // boton + que lleva a registrar
            IconButton(
              tooltip: 'Agregar producto',
              onPressed: _irARegistrar,
              icon: const CirculoDegradado(
                icono: FontAwesomeIcons.plus,
                colores: AppTheme.degradadoRosa,
                tamano: 38,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // barra de busqueda, onChanged filtra mientras se escribe
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _buscarCtrl,
                    onChanged: (valor) => setState(() => _busqueda = valor),
                    decoration: InputDecoration(
                      hintText: 'Buscar producto...',
                      prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
                      suffixIcon: _busqueda.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Limpiar',
                              icon: const FaIcon(FontAwesomeIcons.xmark, size: 18),
                              onPressed: () {
                                _buscarCtrl.clear();
                                setState(() => _busqueda = '');
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${lista.length} producto(s)',
                      style: textos.labelLarge?.copyWith(
                        color: AppTheme.textoOscuro.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: lista.isEmpty
                      ? _sinResultados(textos)
                      // ListView.builder crea los items solo cuando se van a ver,
                      // por eso es mejor para listas que pueden crecer
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: lista.length,
                          itemBuilder: (context, index) {
                            final producto = lista[index];
                            return _tarjetaProducto(producto);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card con ListTile para cada producto (los datos salen del Map)
  Widget _tarjetaProducto(Map<String, dynamic> producto) {
    final Color color = producto['color'];

    return Card(
      child: ListTile(
        leading: CirculoDegradado(
          icono: producto['icono'],
          colores: AppTheme.degradadoDe(color),
        ),
        title: Text(
          producto['nombre'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precio: ${formatearPrecio(producto['precio'])}',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            Text('Stock: ${producto['stock']} unidades'),
          ],
        ),
        // menu de 3 puntos con la opcion Eliminar
        trailing: PopupMenuButton<String>(
          tooltip: 'Opciones',
          icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 18),
          onSelected: (opcion) {
            if (opcion == 'eliminar') _eliminar(producto);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'eliminar',
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.solidTrashCan, size: 18, color: AppTheme.rojoError),
                  SizedBox(width: 10),
                  Text('Eliminar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sinResultados(TextTheme textos) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CirculoDegradado(
              icono: FontAwesomeIcons.solidFaceFrown,
              colores: AppTheme.degradadoNaranja,
              tamano: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron productos',
              textAlign: TextAlign.center,
              style: textos.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
