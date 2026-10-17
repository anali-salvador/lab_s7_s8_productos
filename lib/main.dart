import 'package:flutter/material.dart';

import 'screens/listar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/registrar_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/marco_celular.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Productos',
      debugShowCheckedModeBanner: false,
      // el tema global que hice en app_theme.dart, lo usan todas las pantallas
      theme: AppTheme.tema,
      // builder envuelve a todas las pantallas. Lo uso para poner el marco
      // de celular cuando se abre en el navegador o en la compu
      builder: (context, child) => MarcoCelular(child: child!),
      // Rutas nombradas: cada nombre apunta a una pantalla.
      // Para navegar uso Navigator.pushNamed(context, '/listar') por ejemplo
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/menu': (context) => const MenuScreen(),
        '/listar': (context) => const ListarScreen(),
        '/registrar': (context) => const RegistrarScreen(),
        '/perfil': (context) => const PerfilScreen(),
      },
    );
  }
}
