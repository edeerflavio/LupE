import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/diacritics.dart';
import '../data/repositories/adivinhe_repository.dart';
import '../domain/models/adivinhe_estado.dart';
import '../domain/models/adivinhe_item.dart';

final adivinheRepositoryProvider = Provider((_) => AdivinheRepository());

/// Controlador de uma rodada de "Adivinhe", parametrizado pela categoria.
final adivinheControllerProvider = NotifierProvider.family<AdivinheController,
    AdivinheEstado, CategoriaAdivinhe>(AdivinheController.new);

class AdivinheController extends FamilyNotifier<AdivinheEstado, CategoriaAdivinhe> {
  final Random _rng = Random();

  AdivinheRepository get _repo => ref.read(adivinheRepositoryProvider);

  @override
  AdivinheEstado build(CategoriaAdivinhe cat) => _montar(_repo.sortear(cat));

  AdivinheEstado _montar(AdivinheItem item) {
    final letras =
        normalizar(item.resposta).split('').where(ehLetra).toList();
    letras.shuffle(_rng);
    // Evita a bandeja já sair na ordem exata da resposta.
    final alvo = normalizar(item.resposta).split('').where(ehLetra).toList();
    if (letras.length > 1 && _mesmaOrdem(letras, alvo)) {
      final t = letras.removeAt(0);
      letras.add(t);
    }
    final bandeja = [
      for (var i = 0; i < letras.length; i++) LetraTile(i, letras[i]),
    ];
    return AdivinheEstado.iniciar(item, bandeja);
  }

  bool _mesmaOrdem(List<String> a, List<String> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void colocar(int tileId) => state = state.colocar(tileId);
  void removerSlot(int i) => state = state.removerSlot(i);
  void limpar() => state = state.limpar();

  /// Ajuda: coloca a letra certa no próximo slot vazio.
  void dica() {
    final s = state;
    final vazio = s.slots.indexOf(null);
    if (vazio == -1) return;
    final alvo = s.alvos[vazio];
    for (final tile in s.bandeja) {
      if (tile.letra == alvo && !s.tileUsada(tile.id)) {
        state = s.colocar(tile.id);
        return;
      }
    }
  }

  void proximo() =>
      state = _montar(_repo.sortear(arg, evitarId: state.item.id));
}
