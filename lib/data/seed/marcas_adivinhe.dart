import '../../domain/models/adivinhe_item.dart';

/// Marca com logo (SVG) para o modo "Adivinhe".
///
/// Logos do **Simple Icons** (simpleicons.org), distribuídos sob CC0. Os nomes
/// e marcas são propriedade de seus donos — aqui são usados apenas para fim
/// educativo de identificação, em app de uso pessoal. Ver CREDITOS-IMAGENS.md.
///
/// Regras do modo Marcas:
/// - Só entram logos **símbolo**, que NÃO escrevem o nome da marca (nada de
///   KFC, Coca-Cola, Samsung etc. — senão a resposta aparece no desenho).
/// - **Sem dica de texto**: o desafio é reconhecer o símbolo sozinho.
/// - Dificuldade mínima é `medio` (a bandeja sempre tem letras a mais).
class _Marca {
  final String nome; // resposta
  final String slug; // arquivo do logo
  final Dificuldade dif;
  const _Marca(this.nome, this.slug, this.dif);
}

const List<_Marca> _marcas = [
  // --- Apps e internet ---
  _Marca('YOUTUBE', 'youtube', Dificuldade.medio),
  _Marca('NETFLIX', 'netflix', Dificuldade.medio),
  _Marca('GOOGLE', 'google', Dificuldade.medio),
  _Marca('WHATSAPP', 'whatsapp', Dificuldade.medio),
  _Marca('INSTAGRAM', 'instagram', Dificuldade.medio),
  _Marca('TIKTOK', 'tiktok', Dificuldade.medio),
  _Marca('FACEBOOK', 'facebook', Dificuldade.medio),
  _Marca('APPLE', 'apple', Dificuldade.medio),
  _Marca('CHROME', 'googlechrome', Dificuldade.medio),
  _Marca('DUOLINGO', 'duolingo', Dificuldade.medio),
  _Marca('SPOTIFY', 'spotify', Dificuldade.medio),
  _Marca('GMAIL', 'gmail', Dificuldade.medio),
  _Marca('GOOGLE MAPS', 'googlemaps', Dificuldade.medio),
  _Marca('WAZE', 'waze', Dificuldade.medio),
  _Marca('SNAPCHAT', 'snapchat', Dificuldade.medio),
  _Marca('MESSENGER', 'messenger', Dificuldade.dificil),
  _Marca('SHOPEE', 'shopee', Dificuldade.medio),
  _Marca('FIREFOX', 'firefox', Dificuldade.dificil),
  _Marca('OPERA', 'opera', Dificuldade.dificil),
  _Marca('TELEGRAM', 'telegram', Dificuldade.dificil),
  _Marca('DISCORD', 'discord', Dificuldade.dificil),
  _Marca('TWITCH', 'twitch', Dificuldade.dificil),
  _Marca('PINTEREST', 'pinterest', Dificuldade.dificil),
  _Marca('REDDIT', 'reddit', Dificuldade.dificil),
  _Marca('LINUX', 'linux', Dificuldade.dificil),
  _Marca('MERCADO PAGO', 'mercadopago', Dificuldade.dificil),
  _Marca('NUBANK', 'nubank', Dificuldade.dificil),

  // --- Jogos ---
  _Marca('PLAYSTATION', 'playstation', Dificuldade.medio),
  _Marca('ANDROID', 'android', Dificuldade.medio),
  _Marca('ROBLOX', 'roblox', Dificuldade.medio),
  _Marca('STEAM', 'steam', Dificuldade.dificil),

  // --- Esporte e consumo ---
  _Marca('NIKE', 'nike', Dificuldade.medio),
  _Marca('ADIDAS', 'adidas', Dificuldade.medio),
  _Marca('NEW BALANCE', 'newbalance', Dificuldade.dificil),
  _Marca('MCDONALDS', 'mcdonalds', Dificuldade.medio),
  _Marca('STARBUCKS', 'starbucks', Dificuldade.dificil),
  _Marca('RED BULL', 'redbull', Dificuldade.dificil),
  _Marca('SHELL', 'shell', Dificuldade.dificil),
  _Marca('MASTERCARD', 'mastercard', Dificuldade.dificil),

  // --- Carros e tecnologia ---
  _Marca('FERRARI', 'ferrari', Dificuldade.dificil),
  _Marca('LAMBORGHINI', 'lamborghini', Dificuldade.dificil),
  _Marca('TOYOTA', 'toyota', Dificuldade.dificil),
  _Marca('HONDA', 'honda', Dificuldade.dificil),
  _Marca('TESLA', 'tesla', Dificuldade.dificil),
  _Marca('VOLKSWAGEN', 'volkswagen', Dificuldade.dificil),
  _Marca('AUDI', 'audi', Dificuldade.dificil),
  _Marca('PEUGEOT', 'peugeot', Dificuldade.dificil),
  _Marca('RENAULT', 'renault', Dificuldade.dificil),
  _Marca('XIAOMI', 'xiaomi', Dificuldade.dificil),
  _Marca('NVIDIA', 'nvidia', Dificuldade.dificil),
];

/// Itens do modo Marcas (mostra o logo em SVG; sem dica de texto).
final List<AdivinheItem> seedMarcas = [
  for (final m in _marcas)
    AdivinheItem(
      id: 'marca_${m.slug}',
      materia: 'marcas',
      tipo: TipoVisual.marca,
      resposta: m.nome,
      assetImagem: 'assets/brands/${m.slug}.svg',
      dica: '',
      dificuldade: m.dif,
    ),
];
