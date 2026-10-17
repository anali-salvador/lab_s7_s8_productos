import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/gradient_button.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with SingleTickerProviderStateMixin {
  // controller para que el borde arcoiris de la foto gire
  late final AnimationController _controller;

  static const String _fotoUrl =
      'https://randomuser.me/api/portraits/men/32.jpg';

  // datos del usuario en un Map
  final Map<String, String> _usuario = {
    'nombre': 'Diego Torres',
    'email': 'diego.torres@mitienda.pe',
    'telefono': '+51 987 654 321',
    'rol': 'Administrador',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    // filas de la card de datos: icono, color, etiqueta y valor
    final datos = [
      {'icono': FontAwesomeIcons.solidUser, 'color': AppTheme.violeta, 'label': 'Nombre', 'valor': _usuario['nombre']},
      {'icono': FontAwesomeIcons.solidEnvelope, 'color': AppTheme.rosa, 'label': 'Email', 'valor': _usuario['email']},
      {'icono': FontAwesomeIcons.phone, 'color': AppTheme.turquesa, 'label': 'Teléfono', 'valor': _usuario['telefono']},
      {'icono': FontAwesomeIcons.shieldHalved, 'color': AppTheme.naranja, 'label': 'Rol', 'valor': _usuario['rol']},
    ];

    return AnimatedGradientBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _foto(),
                  const SizedBox(height: 16),
                  Text(
                    _usuario['nombre']!,
                    textAlign: TextAlign.center,
                    style: textos.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _usuario['email']!,
                    textAlign: TextAlign.center,
                    style: textos.bodyMedium?.copyWith(
                      color: AppTheme.textoOscuro.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          for (int i = 0; i < datos.length; i++) ...[
                            if (i > 0)
                              const Divider(indent: 76, endIndent: 20),
                            _filaDato(datos[i]),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    texto: 'EDITAR PERFIL',
                    icono: FontAwesomeIcons.solidPenToSquare,
                    onPressed: () => _mensaje('Pronto podrás editar tu perfil'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filaDato(Map<String, Object?> dato) {
    final Color color = dato['color'] as Color;
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: FaIcon(dato['icono'] as FaIconData, size: 18, color: color),
      ),
      title: Text(
        dato['label'] as String,
        style: const TextStyle(fontSize: 13, color: AppTheme.textoSuave),
      ),
      subtitle: Text(
        dato['valor'] as String,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textoOscuro,
        ),
      ),
    );
  }

  // foto con borde arcoiris que gira y el botoncito de editar
  Widget _foto() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // SweepGradient da la vuelta alrededor del circulo
                gradient: SweepGradient(
                  colors: const [...AppTheme.arcoiris, AppTheme.violeta],
                  transform: GradientRotation(_controller.value * 2 * pi),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.violeta.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SizedBox(
                width: 130,
                height: 130,
                child: Image.network(
                  _fotoUrl,
                  fit: BoxFit.cover,
                  // en web esta pagina no manda cabeceras CORS,
                  // con esto usa una etiqueta <img> si hace falta
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  // mientras carga muestra un circulito de progreso
                  loadingBuilder: (context, child, progreso) {
                    if (progreso == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  // si no hay internet o falla, muestro un icono
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.violeta.withValues(alpha: 0.12),
                      child: const FaIcon(
                        FontAwesomeIcons.solidUser,
                        size: 56,
                        color: AppTheme.violeta,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _mensaje('Cambiar foto de perfil'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  gradient: const LinearGradient(
                    colors: [AppTheme.rosa, AppTheme.naranja],
                  ),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.solidPenToSquare,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
