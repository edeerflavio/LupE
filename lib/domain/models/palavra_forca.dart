import '../../core/utils/diacritics.dart';

enum Dificuldade { facil, medio, dificil }

/// Palavra da Forca (RF03.1). A comparação usa [normalizada]; a exibição
/// usa [palavra] com acentos.
class PalavraForca {
  final String id;
  final String materia;
  final String palavra; // exibição, com acentos: "MARINGÁ"
  final String dica; // RF03.2 — dica temática obrigatória
  final Dificuldade dificuldade;

  const PalavraForca({
    required this.id,
    required this.materia,
    required this.palavra,
    required this.dica,
    required this.dificuldade,
  });

  /// Versão sem acentos e em maiúsculas, usada na lógica do jogo.
  String get normalizada => normalizar(palavra);

  /// Conjunto de letras distintas (A-Z) que a palavra contém.
  Set<String> get letrasNecessarias =>
      normalizada.split('').where(ehLetra).toSet();
}
