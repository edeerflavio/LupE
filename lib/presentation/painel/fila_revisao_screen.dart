import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/pergunta_controller.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/pergunta.dart';
import 'pergunta_form_screen.dart';

/// RF05.4 — Fila de revisão. Perguntas pendentes só entram no jogo por ação
/// explícita do responsável: Aprovar, Rejeitar ou Editar antes de decidir.
class FilaRevisaoScreen extends ConsumerWidget {
  const FilaRevisaoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendentes = ref.watch(perguntasPendentesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Fila de revisão')),
      body: CloudBackground(
        child: SafeArea(
          child: pendentes.isEmpty
              ? _Vazio()
              : Limitado(
                  maxWidth: 640,
                  child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 32),
                  children: [
                    const KickerLabel('Pendentes'),
                    const SizedBox(height: 8),
                    Text(
                      '${pendentes.length} '
                      '${pendentes.length == 1 ? "pergunta aguarda" : "perguntas aguardam"} revisão',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 16),
                    for (final p in pendentes) ...[
                      _ItemRevisao(pergunta: p),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
                ),
        ),
      ),
    );
  }
}

/// Liga o cartão às ações do controller (Aprovar/Rejeitar/Editar).
class _ItemRevisao extends ConsumerWidget {
  final Pergunta pergunta;
  const _ItemRevisao({required this.pergunta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CartaoRevisao(
      pergunta: pergunta,
      onAprovar: () => ref
          .read(perguntasProvider.notifier)
          .definirStatus(pergunta.id, StatusPergunta.aprovada),
      onRejeitar: () => ref
          .read(perguntasProvider.notifier)
          .definirStatus(pergunta.id, StatusPergunta.rejeitada),
      onEditar: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PerguntaFormScreen(pergunta: pergunta),
        ),
      ),
    );
  }
}

class _CartaoRevisao extends StatelessWidget {
  final Pergunta pergunta;
  final VoidCallback onAprovar;
  final VoidCallback onRejeitar;
  final VoidCallback onEditar;

  const _CartaoRevisao({
    required this.pergunta,
    required this.onAprovar,
    required this.onRejeitar,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${Materias.emoji(pergunta.materia)} '
                '${Materias.rotulo(pergunta.materia)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: AppTheme.indigo),
              ),
              const Spacer(),
              if (pergunta.origem == OrigemPergunta.iaGerada)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.roxo.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🤖 IA',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: AppTheme.roxo),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pergunta.enunciado,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < pergunta.alternativas.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    i == pergunta.indiceCorreta
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: i == pergunta.indiceCorreta
                        ? AppTheme.verde
                        : AppTheme.textoSuave,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pergunta.alternativas[i],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: i == pergunta.indiceCorreta
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: i == pergunta.indiceCorreta
                            ? AppTheme.verde
                            : AppTheme.texto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (pergunta.explicacao.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡  '),
                  Expanded(
                    child: Text(
                      pergunta.explicacao,
                      style: const TextStyle(
                          fontSize: 14, color: AppTheme.textoSuave),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAprovar,
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('Aprovar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.verde,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRejeitar,
                  icon: const Icon(Icons.close, size: 20),
                  label: const Text('Rejeitar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vermelho,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditar,
              icon: const Icon(Icons.edit, size: 20),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.indigo,
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppTheme.indigo, width: 1.5),
                shape: const StadiumBorder(),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Vazio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('✅', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'Nada para revisar',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 6),
            Text(
              'Perguntas geradas por IA e as salvas como pendentes aparecem aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppTheme.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
