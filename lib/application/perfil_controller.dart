import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/perfil_repository.dart';
import '../domain/models/perfil.dart';

final perfilRepositoryProvider = Provider((_) => PerfilRepository());

/// Perfil atualmente selecionado (nulo até alguém tocar num avatar).
final perfilAtualProvider = StateProvider<Perfil?>((_) => null);

final perfisProvider =
    AsyncNotifierProvider<PerfisController, List<Perfil>>(PerfisController.new);

class PerfisController extends AsyncNotifier<List<Perfil>> {
  static const _uuid = Uuid();

  PerfilRepository get _repo => ref.read(perfilRepositoryProvider);

  @override
  Future<List<Perfil>> build() => _repo.carregar();

  Future<Perfil> criar({
    required String nome,
    required String avatar,
    required int anoEscolar,
  }) async {
    final atuais = state.valueOrNull ?? const [];
    final novo = Perfil(
      id: _uuid.v4(),
      nome: nome.trim(),
      avatar: avatar,
      anoEscolar: anoEscolar,
      criadoEm: _agora(),
    );
    final lista = [...atuais, novo];
    await _repo.salvarTodos(lista);
    state = AsyncData(lista);
    return novo;
  }

  Future<void> remover(String id) async {
    final atuais = state.valueOrNull ?? const [];
    final lista = atuais.where((p) => p.id != id).toList();
    await _repo.salvarTodos(lista);
    state = AsyncData(lista);
  }

  // Isolado para evitar DateTime.now() direto (facilita testes).
  DateTime _agora() => DateTime.now();
}
