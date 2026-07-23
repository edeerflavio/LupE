import 'dart:convert';

/// Progresso acumulado de um perfil (RF01.4/RF01.5). Persistido localmente.
/// Alimenta as conquistas, os relatórios e a repetição dirigida.
class ProgressoPerfil {
  final String perfilId;
  final int acertos;
  final int erros;
  final int partidas;
  final int melhorSequencia; // maior sequência de acertos numa partida
  final Map<String, int> acertosPorMateria; // materia -> acertos
  final Map<String, int> partidasPorJogo; // 'forca'|'adivinhe'|'matematica'|'quiz'
  final Set<String> conquistas; // ids desbloqueados
  final Map<String, int> errosPorPergunta; // perguntaId -> nº de erros

  const ProgressoPerfil({
    required this.perfilId,
    this.acertos = 0,
    this.erros = 0,
    this.partidas = 0,
    this.melhorSequencia = 0,
    this.acertosPorMateria = const {},
    this.partidasPorJogo = const {},
    this.conquistas = const {},
    this.errosPorPergunta = const {},
  });

  ProgressoPerfil copyWith({
    int? acertos,
    int? erros,
    int? partidas,
    int? melhorSequencia,
    Map<String, int>? acertosPorMateria,
    Map<String, int>? partidasPorJogo,
    Set<String>? conquistas,
    Map<String, int>? errosPorPergunta,
  }) {
    return ProgressoPerfil(
      perfilId: perfilId,
      acertos: acertos ?? this.acertos,
      erros: erros ?? this.erros,
      partidas: partidas ?? this.partidas,
      melhorSequencia: melhorSequencia ?? this.melhorSequencia,
      acertosPorMateria: acertosPorMateria ?? this.acertosPorMateria,
      partidasPorJogo: partidasPorJogo ?? this.partidasPorJogo,
      conquistas: conquistas ?? this.conquistas,
      errosPorPergunta: errosPorPergunta ?? this.errosPorPergunta,
    );
  }

  Map<String, dynamic> toMap() => {
        'perfil_id': perfilId,
        'acertos': acertos,
        'erros': erros,
        'partidas': partidas,
        'melhor_sequencia': melhorSequencia,
        'acertos_por_materia': acertosPorMateria,
        'partidas_por_jogo': partidasPorJogo,
        'conquistas': conquistas.toList(),
        'erros_por_pergunta': errosPorPergunta,
      };

  factory ProgressoPerfil.fromMap(Map<String, dynamic> m) => ProgressoPerfil(
        perfilId: m['perfil_id'] as String,
        acertos: (m['acertos'] as int?) ?? 0,
        erros: (m['erros'] as int?) ?? 0,
        partidas: (m['partidas'] as int?) ?? 0,
        melhorSequencia: (m['melhor_sequencia'] as int?) ?? 0,
        acertosPorMateria:
            (m['acertos_por_materia'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
        partidasPorJogo:
            (m['partidas_por_jogo'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
        conquistas: ((m['conquistas'] as List?) ?? const []).map((e) => e as String).toSet(),
        errosPorPergunta:
            (m['erros_por_pergunta'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
      );

  String toJson() => jsonEncode(toMap());
  factory ProgressoPerfil.fromJson(String s) =>
      ProgressoPerfil.fromMap(jsonDecode(s) as Map<String, dynamic>);
}
