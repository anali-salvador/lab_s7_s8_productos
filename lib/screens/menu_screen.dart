import 'package:flutter/material.dart';

import '../data/productos.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Las opciones del menu tambien son una lista de mapas,
  // asi no repito el mismo Card cuatro veces
  final List<Map<String, dynamic>> _opciones = [
    {
      'titulo': 'Registrar Productos',
      'subtitulo': 'Agrega un producto nuevo',
      'icono': Icons.add_box_rounded,
      'colores': AppTheme.degradadoRosa,
      'ruta': '/registrar',
    },
    {
      'titulo': 'Listar Productos',
      'subtitulo': 'Busca y revisa tu inventario',
      'icono': Icons.inventory_2_rounded,
      'colores': AppTheme.degradadoTurquesa,
      'ruta': '/listar',
    },
    {
      'titulo': 'Perfil',
      'subtitulo': 'Tus datos de usuario',
      'icono': Icons.person_rounded,
      'colores': AppTheme.degradadoNaranja,
      'ruta': '/perfil',
    },
    {
      'titulo': 'Logout',
      'subtitulo': 'Cerrar sesión',
      'icono': Icons.logout_rounded,
      'colores': AppTheme.degradadoVioleta,
      'ruta': '/login',
    },
  ];

  Future<void> _abrir(String ruta) async {
    if (ruta == '/login') {
      // Logout: vuelve al login y borra todo el historial,
      // (route) => false significa "no dejes ninguna pantalla atras"
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    await Navigator.pushNamed(context, ruta);
    // al volver actualizo por si cambio la cantidad de productos
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AnimatedGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menú Principal'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // tarjeta de bienvenida
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const CirculoDegradado(
                          icono: Icons.storefront_rounded,
                          colores: AppTheme.degradadoAmarillo,
                          tamano: 60,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Hola de nuevo!',
                                style: textos.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Tienes ${productos.length} productos registrados',
                                style: textos.bodyMedium?.copyWith(
                                  color: AppTheme.textoSuave,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // recorro la lista de opciones y por cada una hago un Card con ListTile
                for (final opcion in _opciones)
                  Card(
                    child: ListTile(
                      // leading = lo que va a la izquierda
                      leading: CirculoDegradado(
                        icono: opcion['icono'],
                        colores: opcion['colores'],
                      ),
                      title: Text(opcion['titulo']),
                      subtitle: Text(opcion['subtitulo']),
                      // trailing = lo que va a la derecha (la flechita)
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: (opcion['colores'] as List<Color>).first,
                      ),
                      onTap: () => _abrir(opcion['ruta']),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
