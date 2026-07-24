import 'models/progresso.dart';

/// Uma conquista (medalha) que o perfil pode desbloquear (RF01.4).
class Conquista {
  final String id;
  final String titulo;
  final String descricao;
  final String emoji;

  /// Regra: recebe o progresso e diz se está conquistada.
  final bool Function(ProgressoPerfil p) alcancada;

  const Conquista({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.emoji,
    required this.alcancada,
  });
}

int _porMateria(ProgressoPerfil p, String m) => p.acertosPorMateria[m] ?? 0;
bool _jogou(ProgressoPerfil p, String j) => (p.partidasPorJogo[j] ?? 0) > 0;

/// Catálogo de conquistas. A ordem é a de exibição na tela.
final List<Conquista> catalogoConquistas = [
  Conquista(
    id: 'primeira_partida',
    titulo: 'Primeira aventura',
    descricao: 'Jogou pela primeira vez',
    emoji: '🎉',
    alcancada: (p) => p.partidas >= 1,
  ),
  Conquista(
    id: 'dez_acertos',
    titulo: 'Pegando o jeito',
    descricao: '10 acertos no total',
    emoji: '⭐',
    alcancada: (p) => p.acertos >= 10,
  ),
  Conquista(
    id: 'cinquenta_acertos',
    titulo: 'Craque',
    descricao: '50 acertos no total',
    emoji: '🌟',
    alcancada: (p) => p.acertos >= 50,
  ),
  Conquista(
    id: 'cem_acertos',
    titulo: 'Mestre',
    descricao: '100 acertos no total',
    emoji: '💯',
    alcancada: (p) => p.acertos >= 100,
  ),
  Conquista(
    id: 'sequencia_5',
    titulo: 'Em chamas',
    descricao: '5 acertos seguidos',
    emoji: '🔥',
    alcancada: (p) => p.melhorSequencia >= 5,
  ),
  Conquista(
    id: 'sequencia_10',
    titulo: 'Imparável',
    descricao: '10 acertos seguidos',
    emoji: '⚡',
    alcancada: (p) => p.melhorSequencia >= 10,
  ),
  Conquista(
    id: 'maratonista',
    titulo: 'Maratonista',
    descricao: 'Jogou 20 partidas',
    emoji: '🏃',
    alcancada: (p) => p.partidas >= 20,
  ),
  Conquista(
    id: 'explorador',
    titulo: 'Explorador',
    descricao: 'Jogou todos os jogos',
    emoji: '🧭',
    alcancada: (p) =>
        _jogou(p, 'forca') &&
        _jogou(p, 'adivinhe') &&
        _jogou(p, 'matematica') &&
        _jogou(p, 'quiz'),
  ),
  Conquista(
    id: 'super_explorador',
    titulo: 'Super explorador',
    descricao: 'Jogou Velha, Cruzadinha, Tetris e Quebra-cabeça',
    emoji: '🚀',
    alcancada: (p) =>
        _jogou(p, 'velha') &&
        _jogou(p, 'cruzada') &&
        _jogou(p, 'tetris') &&
        _jogou(p, 'puzzle'),
  ),
  // Medalhas por matéria (20 acertos na matéria)
  Conquista(
    id: 'medalha_geografia',
    titulo: 'Geógrafo',
    descricao: '20 acertos em Geografia',
    emoji: '🌎',
    alcancada: (p) => _porMateria(p, 'geografia') >= 20,
  ),
  Conquista(
    id: 'medalha_ciencias',
    titulo: 'Cientista',
    descricao: '20 acertos em Ciências',
    emoji: '🔬',
    alcancada: (p) => _porMateria(p, 'ciencias') >= 20,
  ),
  Conquista(
    id: 'medalha_matematica',
    titulo: 'Matemático',
    descricao: '20 acertos em Matemática',
    emoji: '➗',
    alcancada: (p) => _porMateria(p, 'matematica') >= 20,
  ),
  Conquista(
    id: 'medalha_historia',
    titulo: 'Historiador',
    descricao: '20 acertos em História',
    emoji: '🏛️',
    alcancada: (p) => _porMateria(p, 'historia') >= 20,
  ),
  Conquista(
    id: 'medalha_portugues',
    titulo: 'Escritor',
    descricao: '20 acertos em Português',
    emoji: '📖',
    alcancada: (p) => _porMateria(p, 'portugues') >= 20,
  ),
];

/// Retorna as conquistas cujo critério foi atingido em [p].
Set<String> conquistasAlcancadas(ProgressoPerfil p) => {
      for (final c in catalogoConquistas)
        if (c.alcancada(p)) c.id,
    };

Conquista? conquistaPorId(String id) {
  for (final c in catalogoConquistas) {
    if (c.id == id) return c;
  }
  return null;
}
