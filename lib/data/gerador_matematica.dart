import 'dart:math';

import '../domain/models/conta_mat.dart';

/// Gera contas por nível de dificuldade (1 a 6) e as alternativas de resposta.
/// Não precisa de banco: as questões são infinitas e corretas por construção.
class GeradorMatematica {
  final Random _r;
  GeradorMatematica({Random? random}) : _r = random ?? Random();

  static const int nivelMax = 6;

  int _entre(int min, int max) => min + _r.nextInt(max - min + 1);

  /// Gera uma conta adequada ao [nivel] (1..6).
  ContaMat gerar(int nivel) {
    final n = nivel.clamp(1, nivelMax);
    switch (n) {
      case 1: // soma/subtração até 10
        return _somaOuSub(10);
      case 2: // soma/subtração até 20
        return _somaOuSub(20);
      case 3: // soma/subtração até 50 ou tabuada 1..5
        return _r.nextBool() ? _somaOuSub(50) : _mult(1, 5, 1, 5);
      case 4: // tabuada 2..9
        return _mult(2, 9, 2, 9);
      case 5: // multiplicação maior ou divisão exata
        return _r.nextBool() ? _mult(2, 12, 2, 9) : _divisao(2, 9, 1, 10);
      default: // 6: divisão e multiplicação maiores
        return _r.nextBool() ? _divisao(2, 12, 2, 12) : _mult(3, 12, 3, 12);
    }
  }

  ContaMat _somaOuSub(int teto) {
    if (_r.nextBool()) {
      final a = _entre(1, teto);
      final b = _entre(1, teto);
      return ContaMat(a, OperacaoMat.soma, b);
    } else {
      final a = _entre(2, teto);
      final b = _entre(1, a); // garante resultado >= 0
      return ContaMat(a, OperacaoMat.subtracao, b);
    }
  }

  ContaMat _mult(int aMin, int aMax, int bMin, int bMax) {
    return ContaMat(_entre(aMin, aMax), OperacaoMat.multiplicacao,
        _entre(bMin, bMax));
  }

  ContaMat _divisao(int divMin, int divMax, int qMin, int qMax) {
    final b = _entre(divMin, divMax);
    final q = _entre(qMin, qMax);
    return ContaMat(b * q, OperacaoMat.divisao, b); // divisão exata
  }

  /// Quatro alternativas: a correta + 3 distratores plausíveis, embaralhadas.
  List<int> opcoes(ContaMat conta) {
    final certa = conta.resposta;
    final set = <int>{certa};
    final deltas = [1, -1, 2, -2, 3, -3, 5, 10];
    deltas.shuffle(_r);
    for (final d in deltas) {
      if (set.length >= 4) break;
      final cand = certa + d;
      if (cand >= 0) set.add(cand);
    }
    // Preenche se ainda faltar (respostas pequenas).
    var extra = certa + 4;
    while (set.length < 4) {
      set.add(extra++);
    }
    final lista = set.toList()..shuffle(_r);
    return lista;
  }
}
