import '../../domain/models/adivinhe_item.dart';

/// País com os dados usados pelos modos Bandeira e Mapa.
///
/// Bandeiras em PNG de domínio público (flagcdn.com / flagpedia.net), baixadas
/// uma vez para `assets/flags/<iso>.png` e usadas offline (RNF03). Todos os
/// códigos ISO abaixo existem no mapa-múndi do pacote `countries_world_map`,
/// então cada país funciona nos dois modos.
class _Pais {
  final String nome; // resposta, com acento
  final String iso; // ISO-2 minúsculo (bandeira e mapa)
  final String dica;
  final Dificuldade dif;
  const _Pais(this.nome, this.iso, this.dica, this.dif);
}

const List<_Pais> _paises = [
  // --- América do Sul ---
  _Pais('BRASIL', 'br', 'Nosso país, o maior da América do Sul', Dificuldade.facil),
  _Pais('ARGENTINA', 'ar', 'Vizinho ao sul, terra do tango e do futebol', Dificuldade.facil),
  _Pais('CHILE', 'cl', 'País comprido e estreito, ao lado da Cordilheira', Dificuldade.facil),
  _Pais('URUGUAI', 'uy', 'Pequeno vizinho ao sul do Brasil', Dificuldade.medio),
  _Pais('PARAGUAI', 'py', 'País vizinho, sem saída para o mar', Dificuldade.medio),
  _Pais('PERU', 'pe', 'País de Machu Picchu e dos incas', Dificuldade.facil),
  _Pais('COLÔMBIA', 'co', 'País do café, no norte da América do Sul', Dificuldade.medio),
  _Pais('VENEZUELA', 've', 'País do norte, do rio Orinoco', Dificuldade.medio),
  _Pais('BOLÍVIA', 'bo', 'País com duas capitais e o lago Titicaca', Dificuldade.dificil),
  _Pais('EQUADOR', 'ec', 'País cortado pela linha do Equador', Dificuldade.medio),

  // --- América do Norte e Central ---
  _Pais('MÉXICO', 'mx', 'País dos tacos e das pirâmides astecas', Dificuldade.facil),
  _Pais('ESTADOS UNIDOS', 'us', 'País da estátua da liberdade e de Hollywood', Dificuldade.medio),
  _Pais('CANADÁ', 'ca', 'País gigante ao norte, da folha de bordo', Dificuldade.facil),
  _Pais('CUBA', 'cu', 'Ilha do Caribe, das charutos e do som', Dificuldade.facil),

  // --- Europa ---
  _Pais('PORTUGAL', 'pt', 'País europeu onde nasceu a nossa língua', Dificuldade.medio),
  _Pais('ESPANHA', 'es', 'País da paella e do flamenco', Dificuldade.medio),
  _Pais('FRANÇA', 'fr', 'País da Torre Eiffel', Dificuldade.facil),
  _Pais('ITÁLIA', 'it', 'País com formato de bota, da pizza', Dificuldade.facil),
  _Pais('ALEMANHA', 'de', 'País europeu dos carros e das salsichas', Dificuldade.medio),
  _Pais('REINO UNIDO', 'gb', 'País da rainha, do Big Ben e do chá', Dificuldade.medio),
  _Pais('IRLANDA', 'ie', 'Ilha verde dos duendes e do trevo', Dificuldade.dificil),
  _Pais('HOLANDA', 'nl', 'País dos moinhos, tulipas e bicicletas', Dificuldade.medio),
  _Pais('BÉLGICA', 'be', 'País do chocolate e das batatas fritas', Dificuldade.dificil),
  _Pais('SUÍÇA', 'ch', 'País dos Alpes, do queijo e do relógio', Dificuldade.medio),
  _Pais('ÁUSTRIA', 'at', 'País europeu da música e das montanhas', Dificuldade.dificil),
  _Pais('SUÉCIA', 'se', 'País do norte gelado, das florestas', Dificuldade.medio),
  _Pais('NORUEGA', 'no', 'País dos fiordes e da aurora boreal', Dificuldade.dificil),
  _Pais('GRÉCIA', 'gr', 'País dos deuses antigos e das ilhas azuis', Dificuldade.medio),
  _Pais('RÚSSIA', 'ru', 'O maior país do mundo em território', Dificuldade.facil),
  _Pais('POLÔNIA', 'pl', 'País do leste europeu, vizinho da Alemanha', Dificuldade.dificil),

  // --- Ásia ---
  _Pais('JAPÃO', 'jp', 'País asiático do sushi e dos mangás', Dificuldade.facil),
  _Pais('CHINA', 'cn', 'País mais populoso, da Grande Muralha', Dificuldade.facil),
  _Pais('ÍNDIA', 'in', 'País do curry, do Taj Mahal e dos elefantes', Dificuldade.medio),
  _Pais('COREIA DO SUL', 'kr', 'País do K-pop e da tecnologia', Dificuldade.medio),
  _Pais('TAILÂNDIA', 'th', 'País asiático dos templos e das praias', Dificuldade.dificil),

  // --- África ---
  _Pais('EGITO', 'eg', 'País das pirâmides e do rio Nilo', Dificuldade.facil),
  _Pais('ÁFRICA DO SUL', 'za', 'País com três capitais, na ponta da África', Dificuldade.medio),
  _Pais('NIGÉRIA', 'ng', 'País mais populoso da África', Dificuldade.dificil),
  _Pais('QUÊNIA', 'ke', 'País dos safáris e dos leões', Dificuldade.dificil),
  _Pais('MARROCOS', 'ma', 'País do norte da África, dos desertos', Dificuldade.dificil),
  _Pais('ANGOLA', 'ao', 'País africano que fala português', Dificuldade.dificil),
  _Pais('ETIÓPIA', 'et', 'País africano onde nasceu o café', Dificuldade.dificil),

  // --- Oceania ---
  _Pais('AUSTRÁLIA', 'au', 'País-continente dos cangurus', Dificuldade.medio),
  _Pais('NOVA ZELÂNDIA', 'nz', 'País das ilhas, das ovelhas e dos kiwis', Dificuldade.dificil),

  // --- Mais Ásia / Oriente Médio ---
  _Pais('TURQUIA', 'tr', 'País entre a Europa e a Ásia, de Istambul', Dificuldade.dificil),
  _Pais('INDONÉSIA', 'id', 'País asiático formado por milhares de ilhas', Dificuldade.dificil),
  _Pais('FILIPINAS', 'ph', 'País de muitas ilhas no sudeste da Ásia', Dificuldade.dificil),
  _Pais('VIETNÃ', 'vn', 'País do sudeste asiático, do chapéu de palha', Dificuldade.dificil),
  _Pais('ARÁBIA SAUDITA', 'sa', 'País do deserto, do petróleo e de Meca', Dificuldade.dificil),
  _Pais('ISRAEL', 'il', 'País do Oriente Médio, de Jerusalém', Dificuldade.medio),
  _Pais('IRÃ', 'ir', 'País do Oriente Médio, antiga Pérsia', Dificuldade.medio),

  // --- Mais Europa ---
  _Pais('FINLÂNDIA', 'fi', 'País do norte gelado, do Papai Noel', Dificuldade.dificil),
  _Pais('DINAMARCA', 'dk', 'País europeu dos contos de fadas e do Lego', Dificuldade.dificil),
  _Pais('ISLÂNDIA', 'is', 'Ilha do gelo, dos vulcões e das geleiras', Dificuldade.dificil),
  _Pais('UCRÂNIA', 'ua', 'Grande país do leste europeu, dos campos de trigo', Dificuldade.dificil),
  _Pais('ROMÊNIA', 'ro', 'País europeu do conde Drácula', Dificuldade.dificil),

  // --- Mais Américas ---
  _Pais('GUATEMALA', 'gt', 'País da América Central, dos vulcões e dos maias', Dificuldade.dificil),
  _Pais('COSTA RICA', 'cr', 'País da América Central, das florestas e da natureza', Dificuldade.medio),
  _Pais('JAMAICA', 'jm', 'Ilha do Caribe, do reggae', Dificuldade.medio),
  _Pais('PANAMÁ', 'pa', 'País do canal que liga dois oceanos', Dificuldade.medio),
];

String _flag(String iso) => 'assets/flags/$iso.png';

/// Itens do modo Bandeira (mostra a imagem real da bandeira).
final List<AdivinheItem> seedBandeiras = [
  for (final p in _paises)
    AdivinheItem(
      id: 'band_${p.iso}',
      materia: 'geografia',
      tipo: TipoVisual.bandeira,
      resposta: p.nome,
      codigoPais: p.iso,
      assetImagem: _flag(p.iso),
      dica: p.dica,
      dificuldade: p.dif,
    ),
];

/// Itens do modo Mapa (destaca o país no mapa-múndi).
final List<AdivinheItem> seedMapa = [
  for (final p in _paises)
    AdivinheItem(
      id: 'mapa_${p.iso}',
      materia: 'geografia',
      tipo: TipoVisual.mapa,
      resposta: p.nome,
      codigoPais: p.iso,
      assetImagem: _flag(p.iso),
      dica: p.dica,
      dificuldade: p.dif,
    ),
];
