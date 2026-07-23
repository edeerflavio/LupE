import '../../core/utils/diacritics.dart';
import 'palavra_forca.dart';

enum StatusForca { jogando, venceu, perdeu }

/// Estado imutável de uma partida de Forca.
class ForcaEstado {
  final PalavraForca palavra;
  final Set<String> letrasTentadas; // normalizadas (A-Z)
  final int maxErros;

  const ForcaEstado({
    required this.palavra,
    this.letrasTentadas = const {},
    this.maxErros = 6, // RF03.4
  });

  factory ForcaEstado.iniciar(PalavraForca palavra) =>
      ForcaEstado(palavra: palavra);

  /// Letras erradas já tentadas.
  Set<String> get letrasErradas =>
      letrasTentadas.where((l) => !palavra.normalizada.contains(l)).toSet();

  int get erros => letrasErradas.length;
  int get errosRestantes => maxErros - erros;

  bool jaTentou(String letra) => letrasTentadas.contains(normalizar(letra));

  /// True se todas as letras necessárias foram descobertas.
  bool get _todasReveladas =>
      palavra.letrasNecessarias.every(letrasTentadas.contains);

  StatusForca get status {
    if (_todasReveladas) return StatusForca.venceu;
    if (erros >= maxErros) return StatusForca.perdeu;
    return StatusForca.jogando;
  }

  bool get terminou => status != StatusForca.jogando;

  /// Palavra para exibição: letras reveladas com acento; ocultas viram '_'.
  /// Espaços e hífens são sempre mostrados.
  List<String> get exibicao {
    final display = palavra.palavra.toUpperCase().split('');
    final norm = palavra.normalizada.split('');
    final resultado = <String>[];
    for (var i = 0; i < display.length; i++) {
      final letraNorm = norm[i];
      if (!ehLetra(letraNorm)) {
        resultado.add(display[i]); // espaço, hífen etc.
      } else if (letrasTentadas.contains(letraNorm) || terminou) {
        resultado.add(display[i]); // revela com acento
      } else {
        resultado.add('_');
      }
    }
    return resultado;
  }

  /// Aplica uma tentativa de letra e retorna o novo estado.
  ForcaEstado tentar(String letra) {
    final l = normalizar(letra);
    if (!ehLetra(l) || letrasTentadas.contains(l) || terminou) return this;
    return ForcaEstado(
      palavra: palavra,
      letrasTentadas: {...letrasTentadas, l},
      maxErros: maxErros,
    );
  }

  /// True se a última tentativa de [letra] foi um acerto (para feedback).
  bool acertou(String letra) => palavra.normalizada.contains(normalizar(letra));
}
