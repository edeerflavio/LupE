import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/gerador_matematica.dart';
import '../domain/models/mat_estado.dart';

final geradorMatProvider = Provider((_) => GeradorMatematica());

/// Controlador de uma sessão de Matemática, parametrizado pelo modo.
final matControllerProvider =
    NotifierProvider.family<MatController, MatEstado, ModoMat>(
  MatController.new,
);

class MatController extends FamilyNotifier<MatEstado, ModoMat> {
  // Regras da dificuldade adaptativa (RF04.2).
  static const int _paraSubir = 3; // acertos seguidos
  static const int _paraDescer = 2; // erros seguidos
  static const int _duracaoTempo = 60; // segundos do modo contra o tempo

  Timer? _timer;

  GeradorMatematica get _ger => ref.read(geradorMatProvider);

  @override
  MatEstado build(ModoMat modo) {
    ref.onDispose(() => _timer?.cancel());
    const nivel = 1;
    final conta = _ger.gerar(nivel);
    if (modo == ModoMat.tempo) _agendarTimer();
    return MatEstado(
      modo: modo,
      conta: conta,
      opcoes: _ger.opcoes(conta),
      nivel: nivel,
      segundos: modo == ModoMat.tempo ? _duracaoTempo : 0,
    );
  }

  void _agendarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = state.segundos - 1;
      if (s <= 0) {
        _timer?.cancel();
        state = state.copyWith(segundos: 0, terminou: true);
      } else {
        state = state.copyWith(segundos: s);
      }
    });
  }

  /// Responde a conta atual com [valor].
  void responder(int valor) {
    if (state.respondida || state.terminou) return;
    final acertou = valor == state.conta.resposta;

    var nivel = state.nivel;
    var seguidosOk = acertou ? state.acertosSeguidos + 1 : 0;
    var seguidosErr = acertou ? 0 : state.errosSeguidos + 1;
    var variacao = VariacaoNivel.nenhuma;

    if (seguidosOk >= _paraSubir && nivel < GeradorMatematica.nivelMax) {
      nivel++;
      seguidosOk = 0;
      variacao = VariacaoNivel.subiu;
    } else if (seguidosErr >= _paraDescer && nivel > 1) {
      nivel--;
      seguidosErr = 0;
      variacao = VariacaoNivel.desceu;
    }

    state = state.copyWith(
      escolha: () => valor,
      acertos: state.acertos + (acertou ? 1 : 0),
      erros: state.erros + (acertou ? 0 : 1),
      acertosSeguidos: seguidosOk,
      errosSeguidos: seguidosErr,
      pontuacao: state.pontuacao + (acertou ? 10 * state.nivel : 0),
      nivel: nivel,
      variacao: variacao,
    );
  }

  /// Gera a próxima conta no nível atual.
  void proximo() {
    if (state.terminou) return;
    final conta = _ger.gerar(state.nivel);
    state = state.copyWith(
      conta: conta,
      opcoes: _ger.opcoes(conta),
      escolha: () => null,
      variacao: VariacaoNivel.nenhuma,
    );
  }

  /// Reinicia a sessão do zero (usado ao terminar o modo contra o tempo).
  void reiniciar() {
    _timer?.cancel();
    final conta = _ger.gerar(1);
    if (state.modo == ModoMat.tempo) _agendarTimer();
    state = MatEstado(
      modo: state.modo,
      conta: conta,
      opcoes: _ger.opcoes(conta),
      nivel: 1,
      segundos: state.modo == ModoMat.tempo ? _duracaoTempo : 0,
    );
  }
}
