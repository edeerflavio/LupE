import '../../domain/models/palavra_forca.dart';

/// Semente local de Geografia (Fase 1 do PRD).
///
/// Dados embutidos no app (offline-first, RNF03): capitais e estados do
/// Brasil e alguns países. Numa fase futura estes viriam de countries.dev +
/// IBGE + `fserb/pt-br`, importados uma vez para o Supabase e sincronizados.
///
/// A dificuldade aqui é uma aproximação manual do escore ICF (raridade)
/// citado no PRD: palavras curtas/comuns = fácil; longas/raras = difícil.
const List<PalavraForca> seedGeografia = [
  // --- Capitais do Brasil ---
  PalavraForca(id: 'g001', materia: 'geografia', palavra: 'CURITIBA', dica: 'Capital do Paraná, conhecida pelo frio e pelos parques', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g002', materia: 'geografia', palavra: 'MARINGÁ', dica: 'Cidade do norte do Paraná, famosa pela catedral', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g003', materia: 'geografia', palavra: 'SALVADOR', dica: 'Capital da Bahia, primeira capital do Brasil', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g004', materia: 'geografia', palavra: 'RECIFE', dica: 'Capital de Pernambuco, cheia de pontes e rios', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g005', materia: 'geografia', palavra: 'MANAUS', dica: 'Capital do Amazonas, no meio da floresta', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g006', materia: 'geografia', palavra: 'BELÉM', dica: 'Capital do Pará, na foz do rio Amazonas', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g007', materia: 'geografia', palavra: 'FORTALEZA', dica: 'Capital do Ceará, com praias famosas', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g008', materia: 'geografia', palavra: 'BRASÍLIA', dica: 'Capital do Brasil, planejada e em formato de avião', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g009', materia: 'geografia', palavra: 'GOIÂNIA', dica: 'Capital de Goiás, no Centro-Oeste', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g010', materia: 'geografia', palavra: 'NATAL', dica: 'Capital do Rio Grande do Norte, cidade do sol', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g011', materia: 'geografia', palavra: 'ARACAJU', dica: 'Capital de Sergipe, o menor estado do Brasil', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g012', materia: 'geografia', palavra: 'FLORIANÓPOLIS', dica: 'Capital de Santa Catarina, a Ilha da Magia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g013', materia: 'geografia', palavra: 'VITÓRIA', dica: 'Capital do Espírito Santo, também é uma ilha', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g014', materia: 'geografia', palavra: 'PALMAS', dica: 'Capital do Tocantins, a mais nova capital do país', dificuldade: Dificuldade.facil),

  // --- Estados do Brasil ---
  PalavraForca(id: 'g020', materia: 'geografia', palavra: 'PARANÁ', dica: 'Estado do Sul onde ficam Curitiba e as Cataratas', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g021', materia: 'geografia', palavra: 'BAHIA', dica: 'Estado do Nordeste famoso pelo axé e pelo acarajé', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g022', materia: 'geografia', palavra: 'AMAZONAS', dica: 'Maior estado do Brasil, coberto de floresta', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g023', materia: 'geografia', palavra: 'PERNAMBUCO', dica: 'Estado do frevo e do maracatu', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g024', materia: 'geografia', palavra: 'MARANHÃO', dica: 'Estado dos Lençóis, com dunas e lagoas', dificuldade: Dificuldade.medio),

  // --- Países ---
  PalavraForca(id: 'g030', materia: 'geografia', palavra: 'BRASIL', dica: 'Nosso país, o maior da América do Sul', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g031', materia: 'geografia', palavra: 'ARGENTINA', dica: 'País vizinho ao sul, terra do tango', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g032', materia: 'geografia', palavra: 'PORTUGAL', dica: 'País da Europa onde nasceu a língua portuguesa', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g033', materia: 'geografia', palavra: 'JAPÃO', dica: 'País asiático das ilhas, do sushi e dos mangás', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g034', materia: 'geografia', palavra: 'EGITO', dica: 'País africano das pirâmides e do rio Nilo', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g035', materia: 'geografia', palavra: 'CANADÁ', dica: 'País gigante da América do Norte, da folha de bordo', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g036', materia: 'geografia', palavra: 'AUSTRÁLIA', dica: 'País-continente dos cangurus e coalas', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g037', materia: 'geografia', palavra: 'FRANÇA', dica: 'País europeu da Torre Eiffel', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g038', materia: 'geografia', palavra: 'ITÁLIA', dica: 'País europeu com formato de bota, da pizza', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g039', materia: 'geografia', palavra: 'URUGUAI', dica: 'Pequeno país vizinho ao sul do Brasil', dificuldade: Dificuldade.medio),

  // --- Capitais do mundo ---
  PalavraForca(id: 'g050', materia: 'geografia', palavra: 'PARIS', dica: 'Capital da França, cidade da Torre Eiffel', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g051', materia: 'geografia', palavra: 'TÓQUIO', dica: 'Capital do Japão', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g052', materia: 'geografia', palavra: 'LISBOA', dica: 'Capital de Portugal, à beira do rio Tejo', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g053', materia: 'geografia', palavra: 'ROMA', dica: 'Capital da Itália, do Coliseu', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g054', materia: 'geografia', palavra: 'MADRI', dica: 'Capital da Espanha', dificuldade: Dificuldade.facil),

  // --- Acidentes geográficos / relevo ---
  PalavraForca(id: 'g060', materia: 'geografia', palavra: 'MONTANHA', dica: 'Elevação bem alta do relevo', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g061', materia: 'geografia', palavra: 'OCEANO', dica: 'Grande extensão de água salgada entre continentes', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g062', materia: 'geografia', palavra: 'DESERTO', dica: 'Lugar muito seco, cheio de areia', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g063', materia: 'geografia', palavra: 'CONTINENTE', dica: 'Grande porção de terra; a Terra tem seis', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g064', materia: 'geografia', palavra: 'EQUADOR', dica: 'Linha imaginária que divide a Terra ao meio', dificuldade: Dificuldade.medio),

  // --- Mais capitais do Brasil ---
  PalavraForca(id: 'g070', materia: 'geografia', palavra: 'SÃO PAULO', dica: 'Maior cidade do Brasil, capital do estado de mesmo nome', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g071', materia: 'geografia', palavra: 'RIO DE JANEIRO', dica: 'Cidade do Cristo Redentor e do Pão de Açúcar', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g072', materia: 'geografia', palavra: 'PORTO ALEGRE', dica: 'Capital do Rio Grande do Sul', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g073', materia: 'geografia', palavra: 'BELO HORIZONTE', dica: 'Capital de Minas Gerais, cercada de montanhas', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g074', materia: 'geografia', palavra: 'CUIABÁ', dica: 'Capital de Mato Grosso, no centro do país', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g075', materia: 'geografia', palavra: 'TERESINA', dica: 'Capital do Piauí', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g076', materia: 'geografia', palavra: 'MACEIÓ', dica: 'Capital de Alagoas, de praias com piscinas naturais', dificuldade: Dificuldade.medio),

  // --- Mais estados do Brasil ---
  PalavraForca(id: 'g080', materia: 'geografia', palavra: 'CEARÁ', dica: 'Estado do Nordeste, de Fortaleza e do humor', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g081', materia: 'geografia', palavra: 'PIAUÍ', dica: 'Estado do Nordeste com pouco litoral', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g082', materia: 'geografia', palavra: 'RONDÔNIA', dica: 'Estado da Região Norte, na Amazônia', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g083', materia: 'geografia', palavra: 'GOIÁS', dica: 'Estado do Centro-Oeste que cerca o Distrito Federal', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g084', materia: 'geografia', palavra: 'PARAÍBA', dica: 'Estado do ponto mais a leste do Brasil', dificuldade: Dificuldade.medio),

  // --- Mais países e continentes ---
  PalavraForca(id: 'g090', materia: 'geografia', palavra: 'MÉXICO', dica: 'País dos tacos e das pirâmides astecas', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g091', materia: 'geografia', palavra: 'CHINA', dica: 'País da Grande Muralha', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g092', materia: 'geografia', palavra: 'ÁFRICA', dica: 'Continente dos safáris e do deserto do Saara', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g093', materia: 'geografia', palavra: 'EUROPA', dica: 'Continente da Torre Eiffel e do Coliseu', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g094', materia: 'geografia', palavra: 'ÁSIA', dica: 'Maior continente do mundo', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g095', materia: 'geografia', palavra: 'OCEANIA', dica: 'Continente da Austrália e das ilhas do Pacífico', dificuldade: Dificuldade.dificil),

  // --- Ainda mais capitais do Brasil ---
  PalavraForca(id: 'g100', materia: 'geografia', palavra: 'JOÃO PESSOA', dica: 'Capital da Paraíba, no extremo leste do Brasil', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g101', materia: 'geografia', palavra: 'CAMPO GRANDE', dica: 'Capital de Mato Grosso do Sul', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g102', materia: 'geografia', palavra: 'SÃO LUÍS', dica: 'Capital do Maranhão, também é uma ilha', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g103', materia: 'geografia', palavra: 'PORTO VELHO', dica: 'Capital de Rondônia, às margens do rio Madeira', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g104', materia: 'geografia', palavra: 'BOA VISTA', dica: 'Capital de Roraima, a mais ao norte do país', dificuldade: Dificuldade.medio),

  // --- Mais países ---
  PalavraForca(id: 'g105', materia: 'geografia', palavra: 'ESPANHA', dica: 'País europeu da paella e do flamenco', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g106', materia: 'geografia', palavra: 'ALEMANHA', dica: 'País europeu famoso pelos carros e pelos castelos', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g107', materia: 'geografia', palavra: 'CHILE', dica: 'País comprido e estreito na costa oeste da América do Sul', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g108', materia: 'geografia', palavra: 'PERU', dica: 'País andino onde fica Machu Picchu', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g109', materia: 'geografia', palavra: 'GRÉCIA', dica: 'País europeu berço dos Jogos Olímpicos', dificuldade: Dificuldade.medio),

  // --- Mais capitais do mundo ---
  PalavraForca(id: 'g110', materia: 'geografia', palavra: 'LONDRES', dica: 'Capital da Inglaterra, do Big Ben', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g111', materia: 'geografia', palavra: 'BERLIM', dica: 'Capital da Alemanha', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g112', materia: 'geografia', palavra: 'BUENOS AIRES', dica: 'Capital da Argentina, à beira do Rio da Prata', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g113', materia: 'geografia', palavra: 'SANTIAGO', dica: 'Capital do Chile, cercada pela Cordilheira dos Andes', dificuldade: Dificuldade.medio),

  // --- Mais acidentes geográficos / relevo ---
  PalavraForca(id: 'g114', materia: 'geografia', palavra: 'VULCÃO', dica: 'Montanha que pode expelir lava quente', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g115', materia: 'geografia', palavra: 'CACHOEIRA', dica: 'Queda de água de um rio de um lugar alto', dificuldade: Dificuldade.medio),
  PalavraForca(id: 'g116', materia: 'geografia', palavra: 'ILHA', dica: 'Porção de terra cercada de água por todos os lados', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g117', materia: 'geografia', palavra: 'FLORESTA', dica: 'Área com muitas árvores e animais, como a Amazônia', dificuldade: Dificuldade.facil),
  PalavraForca(id: 'g118', materia: 'geografia', palavra: 'PENÍNSULA', dica: 'Terra cercada de água quase toda, ligada ao continente por um lado', dificuldade: Dificuldade.dificil),
  PalavraForca(id: 'g119', materia: 'geografia', palavra: 'PLANÍCIE', dica: 'Terreno plano e baixo, sem muitos morros', dificuldade: Dificuldade.dificil),
];
