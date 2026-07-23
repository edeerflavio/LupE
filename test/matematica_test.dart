import 'dart:math';

import 'package:eduplay_kids/data/gerador_matematica.dart';
import 'package:eduplay_kids/domain/models/conta_mat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ger = GeradorMatematica(random: Random(42));

  test('contas geradas são sempre corretas e não negativas', () {
    for (var nivel = 1; nivel <= GeradorMatematica.nivelMax; nivel++) {
      for (var i = 0; i < 200; i++) {
        final c = ger.gerar(nivel);
        expect(c.resposta, greaterThanOrEqualTo(0),
            reason: 'resposta negativa em ${c.enunciado}');
        if (c.op == OperacaoMat.divisao) {
          expect(c.a % c.b, 0, reason: 'divisão não exata em ${c.enunciado}');
        }
      }
    }
  });

  test('opções têm 4 valores distintos e incluem a resposta', () {
    for (var i = 0; i < 300; i++) {
      final c = ger.gerar(1 + i % GeradorMatematica.nivelMax);
      final ops = ger.opcoes(c);
      expect(ops.length, 4);
      expect(ops.toSet().length, 4, reason: 'opções repetidas: $ops');
      expect(ops, contains(c.resposta));
      expect(ops.every((o) => o >= 0), true);
    }
  });

  test('subtração nunca dá resultado negativo', () {
    for (var i = 0; i < 500; i++) {
      final c = ger.gerar(1);
      if (c.op == OperacaoMat.subtracao) {
        expect(c.a >= c.b, true);
      }
    }
  });
}
