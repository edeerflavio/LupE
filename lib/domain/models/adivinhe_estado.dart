import '../../core/utils/diacritics.dart';
import 'adivinhe_item.dart';

/// Uma peça de letra na bandeja. O [id] é o índice na lista de peças.
class LetraTile {
  final int id;
  final String letra; // normalizada (A-Z)
  const LetraTile(this.id, this.letra);
}

/// Estado imutável de uma rodada de "Adivinhe".
///
/// A resposta é decomposta em letras (sem espaços/acentos) — os "alvos".
/// As mesmas letras, embaralhadas, viram a [bandeja]. O jogador coloca peças
/// nos [slots]; acerta quando as letras montadas batem com os alvos.
class AdivinheEstado {
  final AdivinheItem item;

  /// Letras da resposta, normalizadas, na ordem correta (sem espaços).
  final List<String> alvos;

  /// Peças disponíveis, embaralhadas (id = índice nesta lista).
  final List<LetraTile> bandeja;

  /// slots[i] = id da peça colocada na posição i, ou null se vazia.
  final List<int?> slots;

  const AdivinheEstado({
    required this.item,
    required this.alvos,
    required this.bandeja,
    required this.slots,
  });

  /// Cria uma rodada. [bandeja] já deve vir embaralhada pelo controller.
  factory AdivinheEstado.iniciar(AdivinheItem item, List<LetraTile> bandeja) {
    final alvos =
        normalizar(item.resposta).split('').where(ehLetra).toList();
    return AdivinheEstado(
      item: item,
      alvos: alvos,
      bandeja: bandeja,
      slots: List<int?>.filled(alvos.length, null),
    );
  }

  /// Ids de peças já colocadas em algum slot.
  Set<int> get _usadas => slots.whereType<int>().toSet();

  bool tileUsada(int id) => _usadas.contains(id);

  /// Letra atualmente montada na posição [i] (ou '' se vazia).
  String letraNoSlot(int i) {
    final id = slots[i];
    return id == null ? '' : bandeja[id].letra;
  }

  bool get completo => !slots.contains(null);

  bool get correto {
    if (!completo) return false;
    for (var i = 0; i < alvos.length; i++) {
      if (letraNoSlot(i) != alvos[i]) return false;
    }
    return true;
  }

  /// Agrupa os índices de slot por palavra (para exibir com espaços).
  List<List<int>> get grupos {
    final palavras = normalizar(item.resposta).split(' ');
    final resultado = <List<int>>[];
    var idx = 0;
    for (final p in palavras) {
      final letras = p.split('').where(ehLetra).length;
      resultado.add(List.generate(letras, (k) => idx + k));
      idx += letras;
    }
    return resultado;
  }

  /// Coloca a peça [id] no primeiro slot vazio.
  AdivinheEstado colocar(int id) {
    if (tileUsada(id) || completo) return this;
    final vazio = slots.indexOf(null);
    if (vazio == -1) return this;
    final novos = [...slots];
    novos[vazio] = id;
    return _com(novos);
  }

  /// Remove a peça do slot [i], devolvendo-a à bandeja.
  AdivinheEstado removerSlot(int i) {
    if (slots[i] == null) return this;
    final novos = [...slots];
    novos[i] = null;
    return _com(novos);
  }

  /// Esvazia todos os slots.
  AdivinheEstado limpar() => _com(List<int?>.filled(alvos.length, null));

  AdivinheEstado _com(List<int?> novosSlots) => AdivinheEstado(
        item: item,
        alvos: alvos,
        bandeja: bandeja,
        slots: novosSlots,
      );
}
