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

  // --- Américas (expansão) ---
  _Pais('REPÚBLICA DOMINICANA', 'do', 'Ilha caribenha do merengue e das praias', Dificuldade.dificil),
  _Pais('HAITI', 'ht', 'Divide uma ilha caribenha com a República Dominicana', Dificuldade.dificil),
  _Pais('HONDURAS', 'hn', 'País da América Central, entre Guatemala e Nicarágua', Dificuldade.dificil),

  // --- Europa (expansão) ---
  _Pais('TCHÉQUIA', 'cz', 'País de Praga, dos castelos e das marionetes', Dificuldade.dificil),
  _Pais('HUNGRIA', 'hu', 'País do leste europeu, de Budapeste e do páprica', Dificuldade.dificil),
  _Pais('CROÁCIA', 'hr', 'País de praias no mar Adriático, craque no futebol', Dificuldade.dificil),
  _Pais('SÉRVIA', 'rs', 'País dos Bálcãs, de Belgrado', Dificuldade.dificil),
  _Pais('BULGÁRIA', 'bg', 'País do leste europeu, do iogurte e das rosas', Dificuldade.dificil),
  _Pais('ESLOVÁQUIA', 'sk', 'País europeu vizinho da Tchéquia', Dificuldade.dificil),
  _Pais('ESTÔNIA', 'ee', 'País báltico mais ao norte, super digital', Dificuldade.dificil),
  _Pais('LETÔNIA', 'lv', 'País báltico do meio, de Riga', Dificuldade.dificil),
  _Pais('LITUÂNIA', 'lt', 'País báltico mais ao sul, apaixonado por basquete', Dificuldade.dificil),
  _Pais('LUXEMBURGO', 'lu', 'Pequeno e rico país entre França, Bélgica e Alemanha', Dificuldade.dificil),
  _Pais('ALBÂNIA', 'al', 'País dos Bálcãs, da águia de duas cabeças', Dificuldade.dificil),

  // --- Ásia e Oriente Médio (expansão) ---
  _Pais('PAQUISTÃO', 'pk', 'Vizinho da Índia, das montanhas mais altas do mundo', Dificuldade.dificil),
  _Pais('BANGLADESH', 'bd', 'País asiático muito populoso, dos grandes rios', Dificuldade.dificil),
  _Pais('SRI LANKA', 'lk', 'Ilha do chá, ao sul da Índia', Dificuldade.dificil),
  _Pais('NEPAL', 'np', 'País do monte Everest, no Himalaia', Dificuldade.medio),
  _Pais('MONGÓLIA', 'mn', 'País das estepes e dos cavaleiros de Gengis Khan', Dificuldade.dificil),
  _Pais('CAZAQUISTÃO', 'kz', 'O maior país da Ásia Central', Dificuldade.dificil),
  _Pais('MALÁSIA', 'my', 'País asiático das torres gêmeas Petronas', Dificuldade.dificil),
  _Pais('SINGAPURA', 'sg', 'Cidade-país asiática moderníssima e organizada', Dificuldade.dificil),
  _Pais('EMIRADOS ÁRABES', 'ae', 'País de Dubai e dos prédios altíssimos', Dificuldade.medio),
  _Pais('CATAR', 'qa', 'Pequeno país do Golfo, sede da Copa de 2022', Dificuldade.medio),
  _Pais('IRAQUE', 'iq', 'País dos rios Tigre e Eufrates, a antiga Mesopotâmia', Dificuldade.dificil),
  _Pais('JORDÂNIA', 'jo', 'País da cidade de Petra, esculpida na rocha', Dificuldade.dificil),
  _Pais('LÍBANO', 'lb', 'País do cedro na bandeira, de Beirute', Dificuldade.dificil),
  _Pais('CAMBOJA', 'kh', 'País dos templos de Angkor', Dificuldade.dificil),
  _Pais('MIANMAR', 'mm', 'País asiático dos mil templos dourados', Dificuldade.dificil),

  // --- África (expansão) ---
  _Pais('GANA', 'gh', 'País africano famoso pelo cacau', Dificuldade.dificil),
  _Pais('SENEGAL', 'sn', 'País mais a oeste da África continental', Dificuldade.dificil),
  _Pais('COSTA DO MARFIM', 'ci', 'País africano do cacau e dos elefantes', Dificuldade.dificil),
  _Pais('CAMARÕES', 'cm', 'País africano dos Leões Indomáveis', Dificuldade.dificil),
  _Pais('TUNÍSIA', 'tn', 'País do norte da África, da antiga Cartago', Dificuldade.dificil),
  _Pais('ARGÉLIA', 'dz', 'Maior país da África, quase todo no Saara', Dificuldade.dificil),
  _Pais('TANZÂNIA', 'tz', 'País do Kilimanjaro e do Serengeti', Dificuldade.dificil),
  _Pais('UGANDA', 'ug', 'País africano das nascentes do rio Nilo', Dificuldade.dificil),
  _Pais('ZÂMBIA', 'zm', 'País das cataratas Vitória', Dificuldade.dificil),
  _Pais('ZIMBÁBUE', 'zw', 'País africano das antigas ruínas de pedra', Dificuldade.dificil),
  _Pais('MOÇAMBIQUE', 'mz', 'País africano que fala português, no oceano Índico', Dificuldade.medio),
  _Pais('MADAGASCAR', 'mg', 'Grande ilha africana dos lêmures', Dificuldade.medio),
  _Pais('NAMÍBIA', 'na', 'País africano do deserto de dunas vermelhas', Dificuldade.dificil),
  _Pais('BOTSUANA', 'bw', 'País africano dos safáris no delta do Okavango', Dificuldade.dificil),

  // --- Oceania (expansão) ---
  _Pais('FIJI', 'fj', 'Ilhas paradisíacas no meio do Pacífico', Dificuldade.dificil),
  _Pais('PAPUA NOVA GUINÉ', 'pg', 'Metade de uma grande ilha ao norte da Austrália', Dificuldade.dificil),
];

/// Países pequenos demais para serem vistos no mapa-múndi — só aparecem no
/// modo Bandeiras.
const Set<String> _foraDoMapa = {'sg', 'lu'};

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
    if (!_foraDoMapa.contains(p.iso))
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
