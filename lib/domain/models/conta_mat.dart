enum OperacaoMat { soma, subtracao, multiplicacao, divisao }

extension OperacaoMatX on OperacaoMat {
  String get simbolo => switch (this) {
        OperacaoMat.soma => '+',
        OperacaoMat.subtracao => '−',
        OperacaoMat.multiplicacao => '×',
        OperacaoMat.divisao => '÷',
      };
}

/// Uma conta gerada proceduralmente (RF04.1). Sempre tem resposta inteira
/// não negativa, por construção do gerador.
class ContaMat {
  final int a;
  final int b;
  final OperacaoMat op;

  const ContaMat(this.a, this.op, this.b);

  int get resposta => switch (op) {
        OperacaoMat.soma => a + b,
        OperacaoMat.subtracao => a - b,
        OperacaoMat.multiplicacao => a * b,
        OperacaoMat.divisao => a ~/ b,
      };

  String get enunciado => '$a ${op.simbolo} $b';
}
