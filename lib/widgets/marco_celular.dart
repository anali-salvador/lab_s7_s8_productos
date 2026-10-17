import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Marco de celular para cuando abro la app en el navegador o en la compu.
// Asi se ve como si fuera un telefono aunque la ventana sea grande.
// En un celular de verdad (ancho menor a 600) no se pone el marco.
class MarcoCelular extends StatelessWidget {
  final Widget child;

  const MarcoCelular({super.key, required this.child});

  // medidas de la pantalla del "celular" (como un iPhone 14)
  static const double ancho = 390;
  static const double alto = 844;
  static const double grosorBorde = 12;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // celular real: la app ocupa toda la pantalla normal
    if (media.size.width < 600) return child;

    return DecoratedBox(
      // fondo oscuro de afuera, con tonos que combinan con la paleta
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B1030), Color(0xFF2E1656), Color(0xFF4A1942)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          // FittedBox achica el telefono si la ventana es muy bajita,
          // asi nunca se corta (scaleDown = solo achica, no agranda)
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              width: ancho + grosorBorde * 2,
              height: alto + grosorBorde * 2,
              padding: const EdgeInsets.all(grosorBorde),
              decoration: BoxDecoration(
                color: const Color(0xFF14101E),
                borderRadius: BorderRadius.circular(58),
                border: Border.all(color: const Color(0xFF3B3452), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.violeta.withValues(alpha: 0.35),
                    blurRadius: 60,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(46),
                // le digo a la app que la pantalla mide 390 x 844 y que arriba
                // hay espacio ocupado (la isla), asi el AppBar no queda debajo
                child: MediaQuery(
                  data: media.copyWith(
                    size: const Size(ancho, alto),
                    padding: const EdgeInsets.only(top: 44, bottom: 18),
                    viewPadding: const EdgeInsets.only(top: 44, bottom: 18),
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(child: child),
                      // la islita negra de arriba
                      Positioned(
                        top: 11,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Center(
                            child: Container(
                              width: 112,
                              height: 30,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 14),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // camarita
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1F2A44),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // rayita de abajo (como en los iPhone)
                      Positioned(
                        bottom: 7,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Center(
                            child: Container(
                              width: 130,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppTheme.textoOscuro.withValues(
                                  alpha: 0.55,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
