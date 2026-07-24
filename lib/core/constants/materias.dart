/// Rótulos e ícones das matérias, para exibição consistente no Quiz e no
/// Painel dos Pais.
class Materias {
  static const List<String> chaves = [
    'geografia',
    'capitais',
    'ciencias',
    'historia',
    'portugues',
    'conhecimentos',
    'adulto',
  ];

  static const Map<String, String> _rotulos = {
    'geografia': 'Geografia',
    'capitais': 'Capitais',
    'ciencias': 'Ciências',
    'historia': 'História',
    'portugues': 'Português',
    'conhecimentos': 'Conhecimentos gerais',
    'matematica': 'Matemática',
    'marcas': 'Marcas',
    'adulto': 'Modo Adulto',
  };

  static const Map<String, String> _emojis = {
    'geografia': '🌎',
    'capitais': '🏙️',
    'ciencias': '🔬',
    'historia': '🏛️',
    'portugues': '📖',
    'conhecimentos': '💡',
    'matematica': '➗',
    'marcas': '🔶',
    'adulto': '🎓',
  };

  static String rotulo(String chave) => _rotulos[chave] ?? chave;
  static String emoji(String chave) => _emojis[chave] ?? '❓';
}
