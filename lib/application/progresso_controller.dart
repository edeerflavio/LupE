import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/progresso_repository.dart';
import '../domain/conquistas.dart';
import '../domain/models/progresso.dart';

final progressoRepositoryProvider = Provider((_) => ProgressoRepository());

/// Fila de conquistas recém-desbloqueadas, aguardando serem exibidas no popup.
final conquistasRecentesProvider =
    StateProvider<List<Conquista>>((_) => const []);

/// Progresso de um perfil (por id).
final progressoProvider =
    AsyncNotifierProvider.family<ProgressoController, ProgressoPerfil, String>(
  ProgressoController.new,
);

class ProgressoController extends FamilyAsyncNotifier<ProgressoPerfil, String> {
  ProgressoRepository get _repo => ref.read(progressoRepositoryProvider);

  @override
  Future<ProgressoPerfil> build(String perfilId) => _repo.carregar(perfilId);

  ProgressoPerfil get _p =>
      state.valueOrNull ?? ProgressoPerfil(perfilId: arg);

  Future<void> _persistir(ProgressoPerfil novo) async {
    await _repo.salvar(novo);
    state = AsyncData(novo);
  }

  /// Registra o resultado de uma partida e desbloqueia conquistas.
  /// Retorna as conquistas recém-desbloqueadas (para o popup).
  Future<List<Conquista>> registrarPartida({
    required String jogo, // 'forca' | 'adivinhe' | 'matematica' | 'quiz'
    String? materia,
    required int acertos,
    required int erros,
    int sequenciaMax = 0,
  }) async {
    final p = _p;
    final porMateria = Map<String, int>.from(p.acertosPorMateria);
    if (materia != null && acertos > 0) {
      porMateria[materia] = (porMateria[materia] ?? 0) + acertos;
    }
    final porJogo = Map<String, int>.from(p.partidasPorJogo);
    porJogo[jogo] = (porJogo[jogo] ?? 0) + 1;

    final atualizado = p.copyWith(
      acertos: p.acertos + acertos,
      erros: p.erros + erros,
      partidas: p.partidas + 1,
      melhorSequencia:
          sequenciaMax > p.melhorSequencia ? sequenciaMax : p.melhorSequencia,
      acertosPorMateria: porMateria,
      partidasPorJogo: porJogo,
    );

    final alcancadas = conquistasAlcancadas(atualizado);
    final novasIds = alcancadas.difference(p.conquistas);
    final comConquistas = atualizado.copyWith(
      conquistas: {...p.conquistas, ...alcancadas},
    );

    await _persistir(comConquistas);

    final novas = [
      for (final c in catalogoConquistas)
        if (novasIds.contains(c.id)) c,
    ];
    if (novas.isNotEmpty) {
      ref.read(conquistasRecentesProvider.notifier).state = [
        ...ref.read(conquistasRecentesProvider),
        ...novas,
      ];
    }
    return novas;
  }

  /// Repetição dirigida: acumula erros por pergunta (Quiz).
  Future<void> registrarPergunta(String perguntaId, bool acertou) async {
    final p = _p;
    final mapa = Map<String, int>.from(p.errosPorPergunta);
    if (acertou) {
      final atual = (mapa[perguntaId] ?? 0) - 1;
      if (atual <= 0) {
        mapa.remove(perguntaId);
      } else {
        mapa[perguntaId] = atual;
      }
    } else {
      mapa[perguntaId] = (mapa[perguntaId] ?? 0) + 1;
    }
    await _persistir(p.copyWith(errosPorPergunta: mapa));
  }
}
