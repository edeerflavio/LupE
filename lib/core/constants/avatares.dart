/// Catálogo de avatares (emoji) para os perfis das crianças.
/// Emoji evita depender de assets de imagem e funciona offline.
class Avatares {
  static const Map<String, String> emoji = {
    'raposa': '🦊',
    'gato': '🐱',
    'cachorro': '🐶',
    'panda': '🐼',
    'leao': '🦁',
    'coelho': '🐰',
    'sapo': '🐸',
    'pinguim': '🐧',
    'unicornio': '🦄',
    'dinossauro': '🦖',
    'coruja': '🦉',
    'macaco': '🐵',
  };

  static const List<String> chaves = [
    'raposa', 'gato', 'cachorro', 'panda', 'leao', 'coelho',
    'sapo', 'pinguim', 'unicornio', 'dinossauro', 'coruja', 'macaco',
  ];

  static String simbolo(String chave) => emoji[chave] ?? '⭐';
}
