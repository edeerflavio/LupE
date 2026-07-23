import 'dart:convert';

enum StatusPergunta { pendente, aprovada, rejeitada }

enum OrigemPergunta { manual, iaGerada, importada }

/// Pergunta de múltipla escolha do Quiz (RF02) e do Painel dos Pais (RF05).
///
/// O ciclo de vida é: criada/gerada como [StatusPergunta.pendente] e só entra
/// no jogo quando um responsável a marca como [StatusPergunta.aprovada]
/// (RF05.4). Perguntas de IA nunca vão direto para o jogo.
class Pergunta {
  final String id;
  final String materia;
  final String subtema;
  final String dificuldade; // facil | medio | dificil
  final String enunciado;
  final List<String> alternativas; // normalmente 4
  final int indiceCorreta;
  final String explicacao; // RF02.5 — sempre exibida após responder
  final OrigemPergunta origem;
  final StatusPergunta status;
  final DateTime criadaEm;

  const Pergunta({
    required this.id,
    required this.materia,
    required this.enunciado,
    required this.alternativas,
    required this.indiceCorreta,
    required this.explicacao,
    required this.criadaEm,
    this.subtema = '',
    this.dificuldade = 'medio',
    this.origem = OrigemPergunta.manual,
    this.status = StatusPergunta.pendente,
  });

  String get textoCorreta => alternativas[indiceCorreta];

  Pergunta copyWith({
    String? materia,
    String? subtema,
    String? dificuldade,
    String? enunciado,
    List<String>? alternativas,
    int? indiceCorreta,
    String? explicacao,
    OrigemPergunta? origem,
    StatusPergunta? status,
  }) {
    return Pergunta(
      id: id,
      materia: materia ?? this.materia,
      subtema: subtema ?? this.subtema,
      dificuldade: dificuldade ?? this.dificuldade,
      enunciado: enunciado ?? this.enunciado,
      alternativas: alternativas ?? this.alternativas,
      indiceCorreta: indiceCorreta ?? this.indiceCorreta,
      explicacao: explicacao ?? this.explicacao,
      origem: origem ?? this.origem,
      status: status ?? this.status,
      criadaEm: criadaEm,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'materia': materia,
        'subtema': subtema,
        'dificuldade': dificuldade,
        'enunciado': enunciado,
        'alternativas': alternativas,
        'indice_correta': indiceCorreta,
        'explicacao': explicacao,
        'origem': origem.name,
        'status': status.name,
        'criada_em': criadaEm.toIso8601String(),
      };

  factory Pergunta.fromMap(Map<String, dynamic> m) => Pergunta(
        id: m['id'] as String,
        materia: m['materia'] as String,
        subtema: (m['subtema'] as String?) ?? '',
        dificuldade: (m['dificuldade'] as String?) ?? 'medio',
        enunciado: m['enunciado'] as String,
        alternativas: (m['alternativas'] as List).cast<String>(),
        indiceCorreta: m['indice_correta'] as int,
        explicacao: m['explicacao'] as String,
        origem: OrigemPergunta.values
            .firstWhere((o) => o.name == m['origem'], orElse: () => OrigemPergunta.manual),
        status: StatusPergunta.values
            .firstWhere((s) => s.name == m['status'], orElse: () => StatusPergunta.pendente),
        criadaEm: DateTime.parse(m['criada_em'] as String),
      );

  static String encode(List<Pergunta> lista) =>
      jsonEncode(lista.map((p) => p.toMap()).toList());

  static List<Pergunta> decode(String raw) => (jsonDecode(raw) as List)
      .map((e) => Pergunta.fromMap(e as Map<String, dynamic>))
      .toList();
}
