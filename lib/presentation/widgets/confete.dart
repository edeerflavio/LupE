import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Emite confete do topo uma vez, ao ser montado. Coloque numa Stack sobre a
/// tela de vitória para dar a comemoração (Fase 5).
class Confete extends StatefulWidget {
  const Confete({super.key});

  @override
  State<Confete> createState() => _ConfeteState();
}

class _ConfeteState extends State<Confete> {
  late final ConfettiController _c;

  @override
  void initState() {
    super.initState();
    _c = ConfettiController(duration: const Duration(seconds: 2))..play();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _c,
        blastDirection: pi / 2, // para baixo
        maxBlastForce: 22,
        minBlastForce: 10,
        emissionFrequency: 0.05,
        numberOfParticles: 22,
        gravity: 0.25,
        colors: const [
          AppTheme.indigo,
          AppTheme.amarelo,
          AppTheme.verde,
          AppTheme.vermelho,
          AppTheme.azul,
        ],
      ),
    );
  }
}
