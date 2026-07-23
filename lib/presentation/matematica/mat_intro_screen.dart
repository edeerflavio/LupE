import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/mat_estado.dart';
import 'mat_screen.dart';

/// Escolha do modo de Matemática antes de começar.
class MatIntroScreen extends StatelessWidget {
  const MatIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Matemática'),
      ),
      body: CloudBackground(
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 24),
          child: Limitado(
            maxWidth: 560,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text('➗', style: TextStyle(fontSize: 72),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                'Como você quer jogar?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 28),
              _BotaoModo(
                titulo: 'Treino livre',
                subtitulo: 'Sem pressa, a dificuldade se ajusta a você',
                emoji: '🧠',
                cor: AppTheme.verde,
                onTap: () => _abrir(context, ModoMat.livre),
              ),
              const SizedBox(height: 16),
              _BotaoModo(
                titulo: 'Contra o tempo',
                subtitulo: 'Quantas você acerta em 60 segundos?',
                emoji: '⏱️',
                cor: AppTheme.azul,
                onTap: () => _abrir(context, ModoMat.tempo),
              ),
            ],
          ),
          ),
        ),
      ),
      ),
    );
  }

  void _abrir(BuildContext context, ModoMat modo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MatScreen(modo: modo)),
    );
  }
}

class _BotaoModo extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String emoji;
  final Color cor;
  final VoidCallback onTap;

  const _BotaoModo({
    required this.titulo,
    required this.subtitulo,
    required this.emoji,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(24),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                    Text(subtitulo,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
