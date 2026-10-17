import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/productos.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/entrada_animada.dart';

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
      'icono': FontAwesomeIcons.solidSquarePlus,
      'colores': AppTheme.degradadoRosa,
      'ruta': '/registrar',
    },
    {
      'titulo': 'Listar Productos',
      'subtitulo': 'Busca y revisa tu inventario',
      'icono': FontAwesomeIcons.listUl,
      'colores': AppTheme.degradadoTurquesa,
      'ruta': '/listar',
    },
    {
      'titulo': 'Perfil',
      'subtitulo': 'Tus datos de usuario',
      'icono': FontAwesomeIcons.solidUser,
      'colores': AppTheme.degradadoNaranja,
      'ruta': '/perfil',
    },
    {
      'titulo': 'Logout',
      'subtitulo': 'Cerrar sesión',
      'icono': FontAwesomeIcons.rightFromBracket,
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
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              children: [
                // banner de bienvenida con degradado
                EntradaAnimada(indice: 0, child: _bienvenida(textos)),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 8),
                  child: Text(
                    '¿Qué quieres hacer hoy?',
                    style: textos.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // recorro la lista de opciones y por cada una hago un Card con ListTile
                for (int i = 0; i < _opciones.length; i++)
                  EntradaAnimada(
                    indice: i + 1,
                    child: _tarjetaOpcion(_opciones[i]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bienvenida(TextTheme textos) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radio + 4),
        gradient: const LinearGradient(
          colors: [AppTheme.violeta, AppTheme.rosa],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.rosa.withValues(alpha: 0.3),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola de nuevo!',
                  style: textos.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tienes ${productos.length} productos registrados',
                  style: textos.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // circulo blanco transparente con la tiendita
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.store,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaOpcion(Map<String, dynamic> opcion) {
    final List<Color> colores = opcion['colores'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        // leading = lo que va a la izquierda
        leading: CirculoDegradado(icono: opcion['icono'], colores: colores),
        title: Text(opcion['titulo']),
        subtitle: Text(opcion['subtitulo']),
        // trailing = lo que va a la derecha (la flechita en un circulo clarito)
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colores.first.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 13,
              color: colores.first,
            ),
          ),
        ),
        onTap: () => _abrir(opcion['ruta']),
      ),
    );
  }
}
