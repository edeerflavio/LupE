import 'dart:math';

import '../../domain/models/adivinhe_item.dart';
import '../seed/animais_adivinhe.dart';
import '../seed/paises_adivinhe.dart';

/// Categorias jogáveis do modo Adivinhe.
enum CategoriaAdivinhe { bandeiras, mapa, animais }

extension CategoriaAdivinheX on CategoriaAdivinhe {
  String get rotulo => switch (this) {
        CategoriaAdivinhe.bandeiras => 'Bandeiras',
        CategoriaAdivinhe.mapa => 'Mapa',
        CategoriaAdivinhe.animais => 'Animais',
      };
}

/// Fornece itens do modo Adivinhe a partir das sementes locais.
class AdivinheRepository {
  final Random _random;
  AdivinheRepository({Random? random}) : _random = random ?? Random();

  List<AdivinheItem> _itens(CategoriaAdivinhe cat) => switch (cat) {
        CategoriaAdivinhe.bandeiras => seedBandeiras,
        CategoriaAdivinhe.mapa => seedMapa,
        CategoriaAdivinhe.animais => seedAnimais,
      };

  /// Sorteia um item, evitando repetir o [evitarId] anterior quando possível.
  AdivinheItem sortear(CategoriaAdivinhe cat, {String? evitarId}) {
    final todos = _itens(cat);
    if (todos.isEmpty) {
      throw StateError('Sem itens para a categoria ${cat.rotulo}.');
    }
    var pool = todos;
    if (evitarId != null && todos.length > 1) {
      pool = todos.where((i) => i.id != evitarId).toList();
    }
    return pool[_random.nextInt(pool.length)];
  }
}
