import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/conquistas.dart';

/// Mostra um popup comemorativo para as conquistas recém-desbloqueadas.
/// Não faz nada se a lista estiver vazia.
Future<void> mostrarConquistas(
  BuildContext context,
  List<Conquista> novas,
) async {
  if (novas.isEmpty) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _PopupConquistas(conquistas: novas),
  );
}

class _PopupConquistas extends StatefulWidget {
  final List<Conquista> conquistas;
  const _PopupConquistas({required this.conquistas});

  @override
  State<_PopupConquistas> createState() => _PopupConquistasState();
}

class _PopupConquistasState extends State<_PopupConquistas>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confetti;
  late final AnimationController _escala;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2))
      ..play();
    _escala = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _escala.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _escala, curve: Curves.elasticOut),
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🏅', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 4),
                    Text(
                      widget.conquistas.length == 1
                          ? 'Nova conquista!'
                          : 'Novas conquistas!',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 16),
                    for (final c in widget.conquistas)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(c.emoji,
                                style: const TextStyle(fontSize: 34)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.titulo,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800)),
                                  Text(c.descricao,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textoSuave)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Oba!'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confetti,
          blastDirection: pi / 2,
          maxBlastForce: 20,
          minBlastForce: 8,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.2,
          colors: const [
            AppTheme.indigo,
            AppTheme.amarelo,
            AppTheme.verde,
            AppTheme.vermelho,
            AppTheme.azul,
          ],
        ),
      ],
    );
  }
}
