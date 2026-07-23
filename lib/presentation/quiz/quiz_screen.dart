import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/perfil_controller.dart';
import '../../application/progresso_controller.dart';
import '../../application/quiz_controller.dart';
import '../../core/audio/sons.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/quiz_estado.dart';
import '../conquistas/celebrar.dart';
import '../widgets/confete.dart';

/// A partida de Quiz (RF02): múltipla escolha, timer opcional, ajuda de
/// eliminação, feedback imediato e explicação obrigatória após responder.
class QuizScreen extends ConsumerWidget {
  final QuizConfig config;
  const QuizScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = quizControllerProvider(config);
    final estado = ref.watch(prov);
    final controller = ref.read(prov.notifier);

    // Feedback imediato + registro (som, repetição dirigida, conquistas).
    ref.listen(prov, (anterior, atual) {
      final respondeuAgora =
          (anterior == null || !anterior.respondida) && atual.respondida;
      if (respondeuAgora) {
        HapticFeedback.lightImpact();
        if (atual.acertou) {
          ref.read(sonsProvider).acerto();
        } else {
          ref.read(sonsProvider).erro();
        }
        final perfilId = ref.read(perfilAtualProvider)?.id;
        if (perfilId != null) {
          ref
              .read(progressoProvider(perfilId).notifier)
              .registrarPergunta(atual.atual.id, atual.acertou);
        }
      }
      if ((anterior == null || !anterior.terminou) && atual.terminou) {
        registrarFimDePartida(
          context,
          ref,
          jogo: 'quiz',
          materia: config.materia,
          acertos: atual.acertos,
          erros: atual.erros,
          venceu: true,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Quiz · ${Materias.rotulo(config.materia)}'),
        actions: [
          if (!estado.vazio)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('⭐ ${estado.pontuacao}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
          child: estado.vazio
              ? const _SemPerguntas()
              : Stack(
                  children: [
                    _Partida(estado: estado, controller: controller),
                    if (estado.terminou)
                      _OverlayFim(
                        estado: estado,
                        onReiniciar: controller.reiniciar,
                      ),
                    if (estado.terminou) const Confete(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Partida extends StatelessWidget {
  final QuizEstado estado;
  final QuizController controller;
  const _Partida({required this.estado, required this.controller});

  @override
  Widget build(BuildContext context) {
    final pergunta = estado.atual;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 24),
      child: Limitado(
        maxWidth: 640,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KickerLabel(
                  'Pergunta ${estado.numeroAtual} de ${estado.total}'),
              Text('✅ ${estado.acertos}   ❌ ${estado.erros}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          if (estado.comTempo) ...[
            _BarraTempo(segundos: estado.segundos, respondida: estado.respondida),
            const SizedBox(height: 14),
          ],
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Text(
              pergunta.enunciado,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, height: 1.25),
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < pergunta.alternativas.length; i++) ...[
            _BotaoAlternativa(
              letra: String.fromCharCode(65 + i),
              texto: pergunta.alternativas[i],
              indice: i,
              estado: estado,
              onTap: () => controller.responder(i),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          if (!estado.respondida)
            _BotaoAjuda(
              habilitada: !estado.ajudaUsada,
              onTap: controller.usarAjuda,
            ),
          if (estado.respondida) ...[
            _Explicacao(estado: estado),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.proxima,
              icon: Icon(estado.numeroAtual >= estado.total
                  ? Icons.flag
                  : Icons.arrow_forward),
              label: Text(estado.numeroAtual >= estado.total
                  ? 'Ver resultado'
                  : 'Próxima'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

class _BarraTempo extends StatelessWidget {
  final int segundos;
  final bool respondida;
  const _BarraTempo({required this.segundos, required this.respondida});

  @override
  Widget build(BuildContext context) {
    const total = 20;
    final frac = (segundos / total).clamp(0.0, 1.0);
    final cor = respondida
        ? Colors.grey
        : (frac > 0.3 ? AppTheme.verde : AppTheme.vermelho);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 18),
            const SizedBox(width: 6),
            Text('$segundos s',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: frac,
            minHeight: 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(cor),
          ),
        ),
      ],
    );
  }
}

class _BotaoAlternativa extends StatelessWidget {
  final String letra;
  final String texto;
  final int indice;
  final QuizEstado estado;
  final VoidCallback onTap;

  const _BotaoAlternativa({
    required this.letra,
    required this.texto,
    required this.indice,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final respondida = estado.respondida;
    final eliminada = estado.eliminadas.contains(indice);
    final ehCerta = indice == estado.atual.indiceCorreta;
    final foiEscolhida = indice == estado.escolha;

    Color cor = AppTheme.roxo;
    Color corTexto = Colors.white;
    bool ativo = true;

    if (eliminada && !respondida) {
      cor = Colors.grey.shade300;
      corTexto = Colors.grey.shade500;
      ativo = false;
    } else if (respondida) {
      ativo = false;
      if (ehCerta) {
        cor = AppTheme.verde;
      } else if (foiEscolhida) {
        cor = AppTheme.vermelho;
      } else {
        cor = Colors.grey.shade400;
      }
    }

    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(20),
      elevation: ativo ? 3 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: ativo ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Text(letra,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: corTexto)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: corTexto,
                    decoration: eliminada && !estado.respondida
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              if (estado.respondida && ehCerta)
                const Icon(Icons.check_circle, color: Colors.white),
              if (estado.respondida && foiEscolhida && !ehCerta)
                const Icon(Icons.cancel, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoAjuda extends StatelessWidget {
  final bool habilitada;
  final VoidCallback onTap;
  const _BotaoAjuda({required this.habilitada, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: habilitada ? onTap : null,
      icon: const Icon(Icons.content_cut),
      label: Text(habilitada
          ? 'Eliminar duas alternativas'
          : 'Ajuda já usada'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.indigo,
        side: BorderSide(
            color: habilitada ? AppTheme.indigo : Colors.grey, width: 2),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }
}

/// Explicação sempre exibida após responder — inclusive no acerto (RF02.5).
class _Explicacao extends StatelessWidget {
  final QuizEstado estado;
  const _Explicacao({required this.estado});

  @override
  Widget build(BuildContext context) {
    final acertou = estado.acertou;
    final esgotou = estado.tempoEsgotado && estado.escolha == null;
    final cor = acertou ? AppTheme.verde : AppTheme.vermelho;
    final titulo = acertou
        ? 'Isso mesmo! 🎉'
        : (esgotou ? 'Tempo esgotado! ⏱️' : 'Quase! 💪');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: cor)),
          if (!acertou) ...[
            const SizedBox(height: 4),
            Text('Resposta certa: ${estado.atual.textoCorreta}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 10),
          Text(estado.atual.explicacao,
              style: const TextStyle(
                  fontSize: 16, height: 1.3, color: AppTheme.texto)),
        ],
      ),
    );
  }
}

class _OverlayFim extends StatelessWidget {
  final QuizEstado estado;
  final VoidCallback onReiniciar;
  const _OverlayFim({required this.estado, required this.onReiniciar});

  @override
  Widget build(BuildContext context) {
    final total = estado.total;
    final acertos = estado.acertos;
    final proporcao = total == 0 ? 0.0 : acertos / total;
    final emoji = proporcao >= 0.8
        ? '🏆'
        : proporcao >= 0.5
            ? '🎉'
            : '💪';
    final frase = proporcao >= 0.8
        ? 'Você mandou muito bem!'
        : proporcao >= 0.5
            ? 'Bom trabalho!'
            : 'Continue praticando!';

    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              Text(frase,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Pontuação: ${estado.pontuacao}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.azul)),
              Text('$acertos de $total acertos',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onReiniciar,
                icon: const Icon(Icons.refresh),
                label: const Text('Jogar de novo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verde,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SemPerguntas extends StatelessWidget {
  const _SemPerguntas();

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
              'Nenhuma pergunta aqui ainda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escolha outra matéria ou aprove perguntas no Painel dos Pais.',
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
