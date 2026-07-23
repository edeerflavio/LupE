import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/pergunta_controller.dart';
import '../../application/quiz_controller.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import 'quiz_screen.dart';

/// Tela de entrada do Quiz (RF02.1): escolha da matéria e opção de tempo.
class QuizIntroScreen extends ConsumerStatefulWidget {
  const QuizIntroScreen({super.key});

  @override
  ConsumerState<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends ConsumerState<QuizIntroScreen> {
  bool _comTempo = false;

  @override
  Widget build(BuildContext context) {
    final materias = ref.watch(materiasComQuizProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Quiz')),
      body: CloudBackground(
        child: SafeArea(
          child: materias.isEmpty
              ? const _SemQuiz()
              : Limitado(
                maxWidth: 640,
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(20, kToolbarHeight + 20, 20, 24),
                  children: [
                    const Text('🧠',
                        style: TextStyle(fontSize: 64),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Center(child: KickerLabel('Perguntas e respostas')),
                    const SizedBox(height: 6),
                    const Text(
                      'Escolha uma matéria',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    _ToggleTempo(
                      comTempo: _comTempo,
                      onChanged: (v) => setState(() => _comTempo = v),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        for (final chave in materias)
                          _CardMateria(
                            chave: chave,
                            onTap: () => _abrir(chave),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  void _abrir(String materia) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          config: QuizConfig(materia: materia, comTempo: _comTempo),
        ),
      ),
    );
  }
}

class _ToggleTempo extends StatelessWidget {
  final bool comTempo;
  final ValueChanged<bool> onChanged;
  const _ToggleTempo({required this.comTempo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      onTap: () => onChanged(!comTempo),
      child: Row(
        children: [
          Text(comTempo ? '⏱️' : '🐢', style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comTempo ? 'Com tempo' : 'Sem tempo',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Text(
                  comTempo
                      ? '20 segundos por pergunta'
                      : 'Responda no seu ritmo',
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textoSuave),
                ),
              ],
            ),
          ),
          Switch(
            value: comTempo,
            activeThumbColor: AppTheme.indigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CardMateria extends StatelessWidget {
  final String chave;
  final VoidCallback onTap;
  const _CardMateria({required this.chave, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Materias.emoji(chave), style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Text(
            Materias.rotulo(chave),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SemQuiz extends StatelessWidget {
  const _SemQuiz();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, kToolbarHeight + 28, 28, 28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📭', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 12),
            const Text(
              'Ainda não há perguntas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Peça a um responsável para aprovar perguntas no Painel dos Pais.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textoSuave),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
