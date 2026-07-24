/// Palavras e dicas da Cruzadinha, em dois níveis.
///
/// As respostas são comparadas sem acentos (grade usa só A-Z), mas a dica
/// sempre descreve a palavra completa.
class PalavraCruzada {
  final String palavra; // com acentos (a grade normaliza)
  final String dica;
  const PalavraCruzada(this.palavra, this.dica);
}

/// Nível criança: palavras curtas e comuns do dia a dia.
const List<PalavraCruzada> cruzadaCrianca = [
  PalavraCruzada('GATO', 'Bichinho que faz miau'),
  PalavraCruzada('SOL', 'Brilha no céu de dia'),
  PalavraCruzada('LUA', 'Aparece no céu de noite'),
  PalavraCruzada('CASA', 'Lugar onde a gente mora'),
  PalavraCruzada('BOLA', 'Redonda, de jogar futebol'),
  PalavraCruzada('PATO', 'Ave que nada e faz quá-quá'),
  PalavraCruzada('PEIXE', 'Animal que vive na água'),
  PalavraCruzada('FLOR', 'Colorida e cheirosa, no jardim'),
  PalavraCruzada('LIVRO', 'Cheio de páginas e histórias'),
  PalavraCruzada('ESCOLA', 'Lugar onde aprendemos'),
  PalavraCruzada('AMIGO', 'Quem brinca sempre com você'),
  PalavraCruzada('BANANA', 'Fruta amarela que o macaco adora'),
  PalavraCruzada('ABELHA', 'Inseto que faz mel'),
  PalavraCruzada('SAPO', 'Pula na lagoa e coaxa'),
  PalavraCruzada('VACA', 'Animal da fazenda que dá leite'),
  PalavraCruzada('MAR', 'Água salgada que não tem fim'),
  PalavraCruzada('PIPA', 'Brinquedo que voa preso na linha'),
  PalavraCruzada('DENTE', 'Fica na boca e a gente escova'),
  PalavraCruzada('CHUVA', 'Água que cai do céu'),
  PalavraCruzada('NUVEM', 'Branquinha, flutua no céu'),
  PalavraCruzada('BOLO', 'Doce de aniversário com velinhas'),
  PalavraCruzada('SAPATO', 'A gente calça no pé'),
];

/// Nível adulto: geografia, ciências, cultura geral.
const List<PalavraCruzada> cruzadaAdulto = [
  PalavraCruzada('EQUADOR', 'Linha imaginária que divide a Terra ao meio'),
  PalavraCruzada('AMAZONAS', 'Maior rio do mundo em volume de água'),
  PalavraCruzada('SATURNO', 'Planeta famoso pelos anéis'),
  PalavraCruzada('HIERÓGLIFO', 'Símbolo da escrita do Egito Antigo'),
  PalavraCruzada('DEMOCRACIA', 'Governo em que o povo escolhe por voto'),
  PalavraCruzada('MERIDIANO', 'Linha imaginária que vai de um polo ao outro'),
  PalavraCruzada('TUNDRA', 'Bioma gelado e sem árvores do extremo norte'),
  PalavraCruzada('CANBERRA', 'Capital da Austrália'),
  PalavraCruzada('ATACAMA', 'Deserto mais seco do mundo, no Chile'),
  PalavraCruzada('BEETHOVEN', 'Compositor da Nona Sinfonia'),
  PalavraCruzada('PICASSO', 'Pintor espanhol de "Guernica"'),
  PalavraCruzada('CERVANTES', 'Escritor de "Dom Quixote"'),
  PalavraCruzada('ALCATEIA', 'Grupo de lobos'),
  PalavraCruzada('CARDUME', 'Grupo de peixes'),
  PalavraCruzada('VULCÃO', 'Montanha que expele lava'),
  PalavraCruzada('OXIGÊNIO', 'Gás essencial que respiramos'),
  PalavraCruzada('GRAVIDADE', 'Força que nos mantém no chão'),
  PalavraCruzada('PENÍNSULA', 'Terra cercada de água por quase todos os lados'),
  PalavraCruzada('FOTOSSÍNTESE', 'Processo das plantas para produzir alimento'),
  PalavraCruzada('ANTÁRTIDA', 'Continente gelado do polo sul'),
];
