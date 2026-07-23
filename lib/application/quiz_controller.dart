import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/pergunta.dart';
import '../domain/models/quiz_estado.dart';
import 'pergunta_controller.dart';
import 'perfil_controller.dart';
import 'progresso_controller.dart';

/// Configuração de uma partida de Quiz: matéria escolhida e se joga com tempo.
/// Serve de chave da Family (por isso implementa == / hashCode).
class QuizConfig {
  final String materia;
  final bool comTempo;

  const QuizConfig({required this.materia, required this.comTempo});

  @override
  bool operator ==(Object other) =>
      other is QuizConfig &&
      other.materia == materia &&
      other.comTempo == comTempo;

  @override
  int get hashCode => Object.hash(materia, comTempo);
}

/// Controlador de uma partida de Quiz (RF02), parametrizado pela configuração.
final quizControllerProvider =
    NotifierProvider.family<QuizController, QuizEstado, QuizConfig>(
  QuizController.new,
);

class QuizController extends FamilyNotifier<QuizEstado, QuizConfig> {
  static const int _duracao = 20; // segundos por pergunta (RF02.2)
  static const int _pontosBase = 10;

  final Random _rand = Random();
  Timer? _timer;

  @override
  QuizEstado build(QuizConfig config) {
    ref.onDispose(() => _timer?.cancel());
    final perguntas = _montar(config.materia);
    if (config.comTempo && perguntas.isNotEmpty) _agendarTimer();
    return QuizEstado(
      materia: config.materia,
      comTempo: config.comTempo,
      perguntas: perguntas,
      segundos: config.comTempo ? _duracao : 0,
    );
  }

  // ---- Preparo das perguntas ----

  List<PerguntaEmbaralhada> _montar(String materia) {
    final fonte = [...ref.read(perguntasAprovadasProvider(materia))]
      ..shuffle(_rand);

    // Repetição dirigida: perguntas que o perfil errou entram mais vezes,
    // e vêm antes (RF01.5 / campo itens_errados do PRD).
    final erros = _errosDoPerfil();
    final priorizadas = <Pergunta>[];
    for (final p in fonte) {
      final peso = erros[p.id] ?? 0;
      // 1 cópia normal + até 2 extras conforme o histórico de erros.
      final extras = peso.clamp(0, 2);
      for (var i = 0; i < extras; i++) {
        priorizadas.add(p);
      }
    }
    priorizadas.shuffle(_rand);
    final baralho = [...priorizadas, ...fonte];

    return [for (final p in baralho) _embaralharAlternativas(p)];
  }

  /// Mapa perguntaId -> nº de erros do perfil atual (vazio se sem perfil).
  Map<String, int> _errosDoPerfil() {
    final perfilId = ref.read(perfilAtualProvider)?.id;
    if (perfilId == null) return const {};
    final prog = ref.read(progressoProvider(perfilId)).valueOrNull;
    return prog?.errosPorPergunta ?? const {};
  }

  /// Embaralha as alternativas de [p] e recalcula o índice da correta.
  PerguntaEmbaralhada _embaralharAlternativas(Pergunta p) {
    final indices = List<int>.generate(p.alternativas.length, (i) => i)
      ..shuffle(_rand);
    final alternativas = [for (final i in indices) p.alternativas[i]];
    // Onde a antiga correta foi parar na nova ordem.
    final novoIndiceCorreta = indices.indexOf(p.indiceCorreta);
    return PerguntaEmbaralhada(
      id: p.id,
      enunciado: p.enunciado,
      alternativas: alternativas,
      indiceCorreta: novoIndiceCorreta,
      explicacao: p.explicacao,
    );
  }

  // ---- Timer (modo com tempo) ----

  void _agendarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.respondida || state.terminou) {
        _timer?.cancel();
        return;
      }
      final s = state.segundos - 1;
      if (s <= 0) {
        _timer?.cancel();
        // Tempo esgotado conta como erro e revela a resposta (RF02.2).
        state = state.copyWith(
          segundos: 0,
          tempoEsgotado: true,
          erros: state.erros + 1,
        );
      } else {
        state = state.copyWith(segundos: s);
      }
    });
  }

  // ---- Ações do jogador ----

  /// Responde a pergunta atual com a alternativa [indice].
  void responder(int indice) {
    if (state.respondida || state.terminou) return;
    _timer?.cancel();
    final acertou = indice == state.atual.indiceCorreta;
    var pontos = 0;
    if (acertou) {
      pontos = _pontosBase + (state.comTempo ? state.segundos : 0);
    }
    state = state.copyWith(
      escolha: () => indice,
      acertos: state.acertos + (acertou ? 1 : 0),
      erros: state.erros + (acertou ? 0 : 1),
      pontuacao: state.pontuacao + pontos,
    );
  }

  /// Ajuda "eliminar duas": remove 2 alternativas erradas da pergunta atual.
  /// Limitada a 1 uso por partida (RF02.4).
  void usarAjuda() {
    if (state.ajudaUsada || state.respondida || state.terminou) return;
    final atual = state.atual;
    final errados = [
      for (var i = 0; i < atual.alternativas.length; i++)
        if (i != atual.indiceCorreta) i
    ]..shuffle(_rand);
    final remover = errados.take(2).toSet();
    state = state.copyWith(ajudaUsada: true, eliminadas: remover);
  }

  /// Avança para a próxima pergunta (só após responder — RF02.5).
  void proxima() {
    if (state.terminou || !state.respondida) return;
    final prox = state.indice + 1;
    if (prox >= state.perguntas.length) {
      _timer?.cancel();
      state = state.copyWith(terminou: true);
      return;
    }
    state = state.copyWith(
      indice: prox,
      escolha: () => null,
      tempoEsgotado: false,
      eliminadas: <int>{},
      segundos: state.comTempo ? _duracao : 0,
    );
    if (state.comTempo) _agendarTimer();
  }

  /// Recomeça a partida do zero, com novo embaralhamento.
  void reiniciar() {
    _timer?.cancel();
    final perguntas = _montar(state.materia);
    state = QuizEstado(
      materia: state.materia,
      comTempo: state.comTempo,
      perguntas: perguntas,
      segundos: state.comTempo ? _duracao : 0,
    );
    if (state.comTempo && perguntas.isNotEmpty) _agendarTimer();
  }
}
