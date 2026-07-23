import '../../domain/models/adivinhe_item.dart';

/// Marca com logo (SVG) para o modo "Adivinhe".
///
/// Logos do **Simple Icons** (simpleicons.org), distribuídos sob CC0. Os nomes
/// e marcas são propriedade de seus donos — aqui são usados apenas para fim
/// educativo de identificação, em app de uso pessoal. Ver CREDITOS-IMAGENS.md.
class _Marca {
  final String nome; // resposta
  final String slug; // arquivo do logo
  final String dica;
  final Dificuldade dif;
  const _Marca(this.nome, this.slug, this.dica, this.dif);
}

const List<_Marca> _marcas = [
  _Marca('MCDONALDS', 'mcdonalds', 'Lanchonete do palhaço e do Big Mac', Dificuldade.facil),
  _Marca('COCA COLA', 'cocacola', 'O refrigerante vermelho mais famoso do mundo', Dificuldade.facil),
  _Marca('NIKE', 'nike', 'Marca de tênis do "Just Do It" e do símbolo curvo', Dificuldade.facil),
  _Marca('YOUTUBE', 'youtube', 'Site de vídeos com o botão vermelho de play', Dificuldade.facil),
  _Marca('NETFLIX', 'netflix', 'Serviço de filmes e séries, do "tudum"', Dificuldade.facil),
  _Marca('GOOGLE', 'google', 'O buscador mais usado da internet', Dificuldade.facil),
  _Marca('WHATSAPP', 'whatsapp', 'App verde de enviar mensagens', Dificuldade.facil),
  _Marca('ADIDAS', 'adidas', 'Marca esportiva das três listras', Dificuldade.medio),
  _Marca('SPOTIFY', 'spotify', 'App verde de ouvir música', Dificuldade.medio),
  _Marca('PLAYSTATION', 'playstation', 'Videogame da Sony', Dificuldade.medio),
  _Marca('ANDROID', 'android', 'O robozinho verde dos celulares', Dificuldade.medio),
  _Marca('FERRARI', 'ferrari', 'Carro esportivo italiano do cavalinho', Dificuldade.medio),
  _Marca('ROBLOX', 'roblox', 'Jogo online de blocos e mundos criados por gente', Dificuldade.medio),
  _Marca('BURGER KING', 'burgerking', 'Lanchonete do Whopper, rival do McDonald\'s', Dificuldade.medio),
  _Marca('KFC', 'kfc', 'Frango frito do coronel', Dificuldade.medio),
  _Marca('STARBUCKS', 'starbucks', 'Cafeteria da sereia verde', Dificuldade.dificil),
  _Marca('SAMSUNG', 'samsung', 'Marca coreana de celulares e TVs', Dificuldade.dificil),
  _Marca('LAMBORGHINI', 'lamborghini', 'Carro esportivo italiano do touro', Dificuldade.dificil),
];

/// Itens do modo Marcas (mostra o logo em SVG).
final List<AdivinheItem> seedMarcas = [
  for (final m in _marcas)
    AdivinheItem(
      id: 'marca_${m.slug}',
      materia: 'marcas',
      tipo: TipoVisual.marca,
      resposta: m.nome,
      assetImagem: 'assets/brands/${m.slug}.svg',
      dica: m.dica,
      dificuldade: m.dif,
    ),
];
