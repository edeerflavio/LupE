/// Rótulos e ícones das matérias, para exibição consistente no Quiz e no
/// Painel dos Pais.
class Materias {
  static const List<String> chaves = [
    'geografia',
    'ciencias',
    'historia',
    'portugues',
    'conhecimentos',
  ];

  static const Map<String, String> _rotulos = {
    'geografia': 'Geografia',
    'ciencias': 'Ciências',
    'historia': 'História',
    'portugues': 'Português',
    'conhecimentos': 'Conhecimentos gerais',
    'matematica': 'Matemática',
  };

  static const Map<String, String> _emojis = {
    'geografia': '🌎',
    'ciencias': '🔬',
    'historia': '🏛️',
    'portugues': '📖',
    'conhecimentos': '💡',
    'matematica': '➗',
  };

  static String rotulo(String chave) => _rotulos[chave] ?? chave;
  static String emoji(String chave) => _emojis[chave] ?? '❓';
}
