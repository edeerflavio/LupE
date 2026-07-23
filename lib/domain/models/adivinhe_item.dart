import 'palavra_forca.dart' show Dificuldade;

export 'palavra_forca.dart' show Dificuldade;

/// Como o item é mostrado ao jogador no modo "Adivinhe".
enum TipoVisual {
  bandeira, // imagem PNG da bandeira (offline)
  mapa, // país destacado no mapa-múndi
  foto, // foto real (animais etc.) em asset
  emoji, // objeto/animal por emoji
  marca, // logo de marca (precisa de imagem — via Painel dos Pais)
  personagem, // personagem (precisa de imagem — via Painel dos Pais)
}

/// Um item do jogo "Adivinhe": mostra um visual e o jogador monta a resposta
/// com letras embaralhadas.
class AdivinheItem {
  final String id;
  final String materia;
  final TipoVisual tipo;

  /// Resposta para exibição, com acentos: "ARGENTINA", "ESTADOS UNIDOS".
  final String resposta;

  /// Emoji do visual (bandeira ou objeto). Nulo para mapa/marca/personagem.
  final String? emoji;

  /// Código ISO-2 minúsculo do país, para destacar no mapa (ex.: 'br').
  final String? codigoPais;

  /// Caminho do asset de imagem (marca/personagem). Preenchido no futuro.
  final String? assetImagem;

  final String dica;
  final Dificuldade dificuldade;

  const AdivinheItem({
    required this.id,
    required this.materia,
    required this.tipo,
    required this.resposta,
    required this.dica,
    required this.dificuldade,
    this.emoji,
    this.codigoPais,
    this.assetImagem,
  });
}
