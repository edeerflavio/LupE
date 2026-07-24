import '../../domain/models/palavra_forca.dart';

/// Palavras da Forca para o modo adulto: capitais do mundo, geografia e
/// vocabulário mais difíceis. Mesma mecânica, desafio maior.
const List<PalavraForca> seedAdulto = [
  // --- Capitais do mundo (difíceis) ---
  PalavraForca(id: 'a001', materia: 'adulto', palavra: 'CANBERRA', dica: 'Capital da Austrália (não é Sydney!)', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a002', materia: 'adulto', palavra: 'OTTAWA', dica: 'Capital do Canadá (não é Toronto!)', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a003', materia: 'adulto', palavra: 'ANCARA', dica: 'Capital da Turquia (não é Istambul!)', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a004', materia: 'adulto', palavra: 'BERNA', dica: 'Capital da Suíça (não é Zurique!)', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a005', materia: 'adulto', palavra: 'WELLINGTON', dica: 'Capital da Nova Zelândia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a006', materia: 'adulto', palavra: 'RABAT', dica: 'Capital do Marrocos', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a007', materia: 'adulto', palavra: 'HANÓI', dica: 'Capital do Vietnã', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a008', materia: 'adulto', palavra: 'NOVA DÉLHI', dica: 'Capital da Índia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a009', materia: 'adulto', palavra: 'ESTOCOLMO', dica: 'Capital da Suécia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a010', materia: 'adulto', palavra: 'COPENHAGUE', dica: 'Capital da Dinamarca', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a011', materia: 'adulto', palavra: 'HELSINQUE', dica: 'Capital da Finlândia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a012', materia: 'adulto', palavra: 'VARSÓVIA', dica: 'Capital da Polônia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a013', materia: 'adulto', palavra: 'BUDAPESTE', dica: 'Capital da Hungria, cortada pelo Danúbio', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a014', materia: 'adulto', palavra: 'PRAGA', dica: 'Capital da Tchéquia, dos cem campanários', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a015', materia: 'adulto', palavra: 'VIENA', dica: 'Capital da Áustria, cidade da música clássica', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a016', materia: 'adulto', palavra: 'ATENAS', dica: 'Capital da Grécia, berço da democracia', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a017', materia: 'adulto', palavra: 'CAIRO', dica: 'Capital do Egito', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a018', materia: 'adulto', palavra: 'NAIRÓBI', dica: 'Capital do Quênia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a019', materia: 'adulto', palavra: 'MOSCOU', dica: 'Capital da Rússia, da Praça Vermelha', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a020', materia: 'adulto', palavra: 'PEQUIM', dica: 'Capital da China', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a021', materia: 'adulto', palavra: 'SEUL', dica: 'Capital da Coreia do Sul', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a022', materia: 'adulto', palavra: 'BANGCOC', dica: 'Capital da Tailândia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a023', materia: 'adulto', palavra: 'WASHINGTON', dica: 'Capital dos Estados Unidos (não é Nova York!)', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a024', materia: 'adulto', palavra: 'MONTEVIDÉU', dica: 'Capital do Uruguai', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a025', materia: 'adulto', palavra: 'ASSUNÇÃO', dica: 'Capital do Paraguai', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a026', materia: 'adulto', palavra: 'CARACAS', dica: 'Capital da Venezuela', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a027', materia: 'adulto', palavra: 'BOGOTÁ', dica: 'Capital da Colômbia', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a028', materia: 'adulto', palavra: 'QUITO', dica: 'Capital do Equador, a 2.850 m de altitude', dificuldade: Dificuldade.medio),

  // --- Geografia avançada ---
  PalavraForca(id: 'a040', materia: 'adulto', palavra: 'ARQUIPÉLAGO', dica: 'Conjunto de ilhas próximas umas das outras', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a041', materia: 'adulto', palavra: 'ESTREITO', dica: 'Passagem de mar apertada entre duas terras', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a042', materia: 'adulto', palavra: 'LATITUDE', dica: 'Distância em graus até a linha do Equador', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a043', materia: 'adulto', palavra: 'LONGITUDE', dica: 'Distância em graus até o meridiano de Greenwich', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a044', materia: 'adulto', palavra: 'HEMISFÉRIO', dica: 'Cada metade do planeta Terra', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a045', materia: 'adulto', palavra: 'TUNDRA', dica: 'Bioma gelado do extremo norte, sem árvores', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a046', materia: 'adulto', palavra: 'SAVANA', dica: 'Vegetação africana de capim alto e árvores esparsas', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a047', materia: 'adulto', palavra: 'GELEIRA', dica: 'Enorme massa de gelo que se move devagar', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'a048', materia: 'adulto', palavra: 'AFLUENTE', dica: 'Rio menor que deságua num rio maior', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a049', materia: 'adulto', palavra: 'ISTMO', dica: 'Faixa estreita de terra que liga duas áreas maiores', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a050', materia: 'adulto', palavra: 'FIORDE', dica: 'Vale profundo invadido pelo mar, comum na Noruega', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a051', materia: 'adulto', palavra: 'MERIDIANO', dica: 'Linha imaginária que vai de um polo ao outro', dificuldade: Dificuldade.dificil),

  // --- Vocabulário desafiador ---
  PalavraForca(id: 'a060', materia: 'adulto', palavra: 'EFEMÉRIDE', dica: 'Data que marca um acontecimento importante', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a061', materia: 'adulto', palavra: 'IDIOSSINCRASIA', dica: 'Jeito próprio e particular de cada pessoa', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a062', materia: 'adulto', palavra: 'PARADOXO', dica: 'Ideia que parece contradizer a si mesma', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a063', materia: 'adulto', palavra: 'EFÊMERO', dica: 'O que dura muito pouco tempo', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a064', materia: 'adulto', palavra: 'RESILIÊNCIA', dica: 'Capacidade de se recuperar das dificuldades', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a065', materia: 'adulto', palavra: 'QUIMERA', dica: 'Sonho impossível; monstro mitológico híbrido', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a066', materia: 'adulto', palavra: 'ALTRUÍSMO', dica: 'Preocupar-se com os outros antes de si mesmo', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'a067', materia: 'adulto', palavra: 'SERENDIPIDADE', dica: 'Descoberta feliz feita por acaso', dificuldade: Dificuldade.dificil),
];
