/// Utilitários de normalização de texto para o jogo da Forca.
///
/// Requisito RF03.5: a criança digita `A` e deve acertar `Á`/`À`/`Ã`/`Â`.
/// A comparação é feita sobre a versão sem acentos, mas a palavra é
/// exibida sempre com os acentos corretos.
library;

const Map<String, String> _mapaDiacriticos = {
  'Á': 'A', 'À': 'A', 'Ã': 'A', 'Â': 'A', 'Ä': 'A',
  'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
  'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
  'Ó': 'O', 'Ò': 'O', 'Õ': 'O', 'Ô': 'O', 'Ö': 'O',
  'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
  'Ç': 'C',
  'Ñ': 'N',
};

/// Remove acentos e cedilha, deixando em MAIÚSCULAS.
/// Ex.: "Maringá" -> "MARINGA"; "São Paulo" -> "SAO PAULO".
String normalizar(String texto) {
  final buffer = StringBuffer();
  for (final char in texto.toUpperCase().split('')) {
    buffer.write(_mapaDiacriticos[char] ?? char);
  }
  return buffer.toString();
}

/// Verifica se um caractere é uma letra do alfabeto (A-Z, já normalizada).
bool ehLetra(String char) {
  if (char.length != 1) return false;
  final code = char.codeUnitAt(0);
  return code >= 65 && code <= 90; // A..Z
}
