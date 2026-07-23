import 'conta_mat.dart';

enum ModoMat { livre, tempo }

enum VariacaoNivel { nenhuma, subiu, desceu }

/// Estado imutável de uma sessão de Matemática.
class MatEstado {
  final ModoMat modo;
  final ContaMat conta;
  final List<int> opcoes;
  final int nivel;
  final int pontuacao;
  final int acertos;
  final int erros;
  final int acertosSeguidos;
  final int errosSeguidos;

  /// Valor escolhido na conta atual (null = ainda não respondeu).
  final int? escolha;

  /// Como o nível mudou na última resposta (para feedback visual).
  final VariacaoNivel variacao;

  /// Segundos restantes no modo contra o tempo.
  final int segundos;
  final bool terminou;

  const MatEstado({
    required this.modo,
    required this.conta,
    required this.opcoes,
    required this.nivel,
    this.pontuacao = 0,
    this.acertos = 0,
    this.erros = 0,
    this.acertosSeguidos = 0,
    this.errosSeguidos = 0,
    this.escolha,
    this.variacao = VariacaoNivel.nenhuma,
    this.segundos = 0,
    this.terminou = false,
  });

  bool get respondida => escolha != null;
  bool get acertou => escolha != null && escolha == conta.resposta;

  MatEstado copyWith({
    ContaMat? conta,
    List<int>? opcoes,
    int? nivel,
    int? pontuacao,
    int? acertos,
    int? erros,
    int? acertosSeguidos,
    int? errosSeguidos,
    int? Function()? escolha,
    VariacaoNivel? variacao,
    int? segundos,
    bool? terminou,
  }) {
    return MatEstado(
      modo: modo,
      conta: conta ?? this.conta,
      opcoes: opcoes ?? this.opcoes,
      nivel: nivel ?? this.nivel,
      pontuacao: pontuacao ?? this.pontuacao,
      acertos: acertos ?? this.acertos,
      erros: erros ?? this.erros,
      acertosSeguidos: acertosSeguidos ?? this.acertosSeguidos,
      errosSeguidos: errosSeguidos ?? this.errosSeguidos,
      escolha: escolha != null ? escolha() : this.escolha,
      variacao: variacao ?? this.variacao,
      segundos: segundos ?? this.segundos,
      terminou: terminou ?? this.terminou,
    );
  }
}
