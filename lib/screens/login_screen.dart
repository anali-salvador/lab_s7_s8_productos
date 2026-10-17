import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/entrada_animada.dart';
import '../widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // la key del Form sirve para validar todos los campos juntos
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _ocultarPass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    // si todos los validator devuelven null, el form es valido
    if (_formKey.currentState!.validate()) {
      // pushReplacementNamed para que no se pueda volver al login con "atras"
      Navigator.pushReplacementNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AnimatedGradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                // en el navegador no quiero que la card sea gigante
                constraints: const BoxConstraints(maxWidth: 420),
                // la card entra con un fade suave
                child: EntradaAnimada(
                  indice: 0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CirculoDegradado(
                              icono: FontAwesomeIcons.bagShopping,
                              colores: [AppTheme.violeta, AppTheme.rosa],
                              tamano: 96,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Iniciar Sesión',
                              style: textos.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ingresa tus datos para administrar tus productos',
                              textAlign: TextAlign.center,
                              style: textos.bodyMedium?.copyWith(
                                color: AppTheme.textoSuave,
                              ),
                            ),
                            const SizedBox(height: 28),
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'correo@ejemplo.com',
                                prefixIcon: IconoCampo(
                                  FontAwesomeIcons.solidEnvelope,
                                ),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Ingresa tu email';
                                }
                                if (!valor.contains('@')) {
                                  return 'El email debe tener @';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _ocultarPass,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _iniciarSesion(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const IconoCampo(
                                  FontAwesomeIcons.lock,
                                ),
                                // el ojito cambia entre mostrar y ocultar la clave
                                suffixIcon: IconButton(
                                  tooltip: _ocultarPass ? 'Mostrar' : 'Ocultar',
                                  icon: FaIcon(
                                    _ocultarPass
                                        ? FontAwesomeIcons.solidEye
                                        : FontAwesomeIcons.solidEyeSlash,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () => _ocultarPass = !_ocultarPass,
                                    );
                                  },
                                ),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            GradientButton(
                              texto: 'LOGIN',
                              icono: FontAwesomeIcons.rightToBracket,
                              onPressed: _iniciarSesion,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Te enviaremos un correo para recuperarla',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('¿Olvidaste tu contraseña?'),
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
      ),
    );
  }
}
