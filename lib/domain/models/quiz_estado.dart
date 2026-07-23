/// Uma pergunta já preparada para a partida: com a ordem das alternativas
/// embaralhada e o índice da correta recalculado para a nova ordem (nunca se
/// confia no [indiceCorreta] original depois de embaralhar).
class PerguntaEmbaralhada {
  final String id; // id da pergunta original (repetição dirigida)
  final String enunciado;
  final List<String> alternativas;
  final int indiceCorreta;
  final String explicacao;

  const PerguntaEmbaralhada({
    required this.id,
    required this.enunciado,
    required this.alternativas,
    required this.indiceCorreta,
    required this.explicacao,
  });

  String get textoCorreta => alternativas[indiceCorreta];
}

/// Estado imutável de uma partida de Quiz (RF02).
class QuizEstado {
  final String materia;
  final bool comTempo;

  /// Perguntas da partida, já embaralhadas (ordem e alternativas).
  final List<PerguntaEmbaralhada> perguntas;

  /// Índice da pergunta atual dentro de [perguntas].
  final int indice;

  /// Alternativa escolhida na pergunta atual (null = ainda não respondeu).
  final int? escolha;

  /// Verdadeiro quando o tempo acabou nesta pergunta (conta como erro e
  /// revela a resposta, mesmo sem [escolha]).
  final bool tempoEsgotado;

  final int acertos;
  final int erros;
  final int pontuacao;

  /// Segundos restantes na pergunta atual (modo "com tempo").
  final int segundos;

  /// A ajuda "eliminar duas alternativas" já foi usada nesta partida?
  final bool ajudaUsada;

  /// Índices das alternativas removidas pela ajuda na pergunta atual.
  final Set<int> eliminadas;

  final bool terminou;

  const QuizEstado({
    required this.materia,
    required this.comTempo,
    required this.perguntas,
    this.indice = 0,
    this.escolha,
    this.tempoEsgotado = false,
    this.acertos = 0,
    this.erros = 0,
    this.pontuacao = 0,
    this.segundos = 0,
    this.ajudaUsada = false,
    this.eliminadas = const {},
    this.terminou = false,
  });

  bool get vazio => perguntas.isEmpty;

  int get total => perguntas.length;

  /// Número da pergunta atual, começando em 1 (para exibição).
  int get numeroAtual => indice + 1;

  PerguntaEmbaralhada get atual => perguntas[indice];

  /// Já respondeu (por escolha ou por tempo esgotado)?
  bool get respondida => escolha != null || tempoEsgotado;

  bool get acertou => escolha != null && escolha == atual.indiceCorreta;

  QuizEstado copyWith({
    int? indice,
    int? Function()? escolha,
    bool? tempoEsgotado,
    int? acertos,
    int? erros,
    int? pontuacao,
    int? segundos,
    bool? ajudaUsada,
    Set<int>? eliminadas,
    bool? terminou,
  }) {
    return QuizEstado(
      materia: materia,
      comTempo: comTempo,
      perguntas: perguntas,
      indice: indice ?? this.indice,
      escolha: escolha != null ? escolha() : this.escolha,
      tempoEsgotado: tempoEsgotado ?? this.tempoEsgotado,
      acertos: acertos ?? this.acertos,
      erros: erros ?? this.erros,
      pontuacao: pontuacao ?? this.pontuacao,
      segundos: segundos ?? this.segundos,
      ajudaUsada: ajudaUsada ?? this.ajudaUsada,
      eliminadas: eliminadas ?? this.eliminadas,
      terminou: terminou ?? this.terminou,
    );
  }
}
