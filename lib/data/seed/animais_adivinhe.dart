import '../../domain/models/adivinhe_item.dart';

/// Animal com foto real para o modo "Adivinhe".
///
/// Fotos do Wikimedia Commons (licenças livres CC / domínio público), baixadas
/// uma vez para `assets/animals/<slug>.jpg` e usadas offline. Os créditos de
/// autoria/licença estão em `CREDITOS-IMAGENS.md` (exigência das licenças CC).
class _Animal {
  final String nome; // resposta, com acento
  final String slug; // arquivo da foto
  final String dica;
  final Dificuldade dif;
  const _Animal(this.nome, this.slug, this.dica, this.dif);
}

const List<_Animal> _animais = [
  _Animal('LEÃO', 'leao', 'O "rei" da savana, tem juba', Dificuldade.facil),
  _Animal('TIGRE', 'tigre', 'Felino laranja com listras pretas', Dificuldade.facil),
  _Animal('ZEBRA', 'zebra', 'Parece um cavalo com listras preto e branco', Dificuldade.facil),
  _Animal('GATO', 'gato', 'Faz miau e adora dormir', Dificuldade.facil),
  _Animal('URSO', 'urso', 'Grande e peludo, hiberna no inverno', Dificuldade.facil),
  _Animal('PANDA', 'panda', 'Urso preto e branco que come bambu', Dificuldade.facil),
  _Animal('CAVALO', 'cavalo', 'Galopa pelo campo e a gente monta', Dificuldade.facil),
  _Animal('GIRAFA', 'girafa', 'Tem o pescoço bem comprido', Dificuldade.medio),
  _Animal('MACACO', 'macaco', 'Adora bananas e sobe nas árvores', Dificuldade.medio),
  _Animal('COELHO', 'coelho', 'Tem orelhas grandes e pula', Dificuldade.medio),
  _Animal('RAPOSA', 'raposa', 'Esperta, de rabo peludo e cor de fogo', Dificuldade.medio),
  _Animal('CORUJA', 'coruja', 'Ave que enxerga de noite e faz "uu"', Dificuldade.medio),
  _Animal('PINGUIM', 'pinguim', 'Ave que não voa e vive no gelo', Dificuldade.medio),
  _Animal('CACHORRO', 'cachorro', 'O melhor amigo do homem, faz au-au', Dificuldade.medio),
  _Animal('ELEFANTE', 'elefante', 'O maior animal da terra, tem tromba', Dificuldade.dificil),
  _Animal('GOLFINHO', 'golfinho', 'Mamífero esperto que vive no mar', Dificuldade.dificil),
  _Animal('TARTARUGA', 'tartaruga', 'Anda devagar e carrega a casa nas costas', Dificuldade.dificil),
  _Animal('BORBOLETA', 'borboleta', 'Era lagarta e ganhou asas coloridas', Dificuldade.dificil),
  // --- Novos ---
  _Animal('COBRA', 'cobra', 'Réptil comprido que rasteja, sem pernas', Dificuldade.facil),
  _Animal('SAPO', 'sapo', 'Anfíbio que pula e vive perto da água', Dificuldade.facil),
  _Animal('ABELHA', 'abelha', 'Inseto que faz mel e voa entre as flores', Dificuldade.facil),
  _Animal('LOBO', 'lobo', 'Parente selvagem do cachorro, que uiva', Dificuldade.facil),
  _Animal('FOCA', 'foca', 'Mamífero marinho que vive em praias geladas', Dificuldade.facil),
  _Animal('CAMELO', 'camelo', 'Animal do deserto com corcovas nas costas', Dificuldade.medio),
  _Animal('POLVO', 'polvo', 'Animal do mar com oito braços', Dificuldade.medio),
  _Animal('ESQUILO', 'esquilo', 'Roedor de rabo peludo que junta nozes', Dificuldade.medio),
  _Animal('PAPAGAIO', 'papagaio', 'Ave colorida que imita a nossa fala', Dificuldade.medio),
  _Animal('TUBARÃO', 'tubarao', 'Peixe grande e temido do mar', Dificuldade.dificil),
];

/// Animal representado por emoji (não precisa de foto embutida).
class _AnimalEmoji {
  final String nome;
  final String emoji;
  final String dica;
  final Dificuldade dif;
  const _AnimalEmoji(this.nome, this.emoji, this.dica, this.dif);
}

const List<_AnimalEmoji> _animaisEmoji = [
  _AnimalEmoji('VACA', '🐄', 'Dá leite e faz muu', Dificuldade.facil),
  _AnimalEmoji('PORCO', '🐷', 'Animal rosado da fazenda que adora lama', Dificuldade.facil),
  _AnimalEmoji('GALINHA', '🐔', 'Bota ovos e faz cocoricó', Dificuldade.facil),
  _AnimalEmoji('PATO', '🦆', 'Ave que nada na lagoa e faz quá-quá', Dificuldade.facil),
  _AnimalEmoji('OVELHA', '🐑', 'Animal da fazenda que dá lã', Dificuldade.facil),
  _AnimalEmoji('RATO', '🐭', 'Roedor pequeno que adora queijo', Dificuldade.facil),
  _AnimalEmoji('BALEIA', '🐋', 'Gigante do mar que solta jato de água', Dificuldade.facil),
  _AnimalEmoji('JACARÉ', '🐊', 'Réptil de dentes grandes que vive nos rios', Dificuldade.medio),
  _AnimalEmoji('CARANGUEJO', '🦀', 'Anda de lado e tem pinças', Dificuldade.medio),
  _AnimalEmoji('CANGURU', '🦘', 'Pula alto e carrega o filhote na bolsa', Dificuldade.medio),
  _AnimalEmoji('FLAMINGO', '🦩', 'Ave rosa de pernas bem finas', Dificuldade.medio),
  _AnimalEmoji('ÁGUIA', '🦅', 'Ave de rapina de visão poderosa', Dificuldade.medio),
  _AnimalEmoji('MORCEGO', '🦇', 'Mamífero que voa de noite', Dificuldade.medio),
  _AnimalEmoji('FORMIGA', '🐜', 'Inseto pequeno e forte que vive em colônias', Dificuldade.medio),
  _AnimalEmoji('JOANINHA', '🐞', 'Inseto vermelho de bolinhas pretas', Dificuldade.medio),
  _AnimalEmoji('CARACOL', '🐌', 'Bem devagar, carrega uma concha em espiral', Dificuldade.dificil),
  _AnimalEmoji('PAVÃO', '🦚', 'Ave que abre um leque de penas coloridas', Dificuldade.dificil),
  _AnimalEmoji('HIPOPÓTAMO', '🦛', 'Grandão que passa o dia dentro do rio', Dificuldade.dificil),
  _AnimalEmoji('RINOCERONTE', '🦏', 'Tem um chifre no nariz e pele grossa', Dificuldade.dificil),
  _AnimalEmoji('PREGUIÇA', '🦥', 'Vive pendurada nas árvores, bem devagarinho', Dificuldade.dificil),
];

/// Itens do modo Animais (foto real ou emoji).
final List<AdivinheItem> seedAnimais = [
  for (final a in _animais)
    AdivinheItem(
      id: 'anim_${a.slug}',
      materia: 'ciencias',
      tipo: TipoVisual.foto,
      resposta: a.nome,
      assetImagem: 'assets/animals/${a.slug}.jpg',
      dica: a.dica,
      dificuldade: a.dif,
    ),
  for (final a in _animaisEmoji)
    AdivinheItem(
      id: 'anim_e_${a.nome.toLowerCase()}',
      materia: 'ciencias',
      tipo: TipoVisual.emoji,
      resposta: a.nome,
      emoji: a.emoji,
      dica: a.dica,
      dificuldade: a.dif,
    ),
];
