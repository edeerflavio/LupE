import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/palavra_repository.dart';
import '../domain/models/forca_estado.dart';
import '../domain/models/palavra_forca.dart';

final palavraRepositoryProvider = Provider((_) => PalavraRepository());

/// Controlador de uma partida de Forca. Recebe a matéria como argumento.
final forcaControllerProvider =
    NotifierProvider.family<ForcaController, ForcaEstado, String>(
  ForcaController.new,
);

class ForcaController extends FamilyNotifier<ForcaEstado, String> {
  Dificuldade? _dificuldade;

  PalavraRepository get _repo => ref.read(palavraRepositoryProvider);

  @override
  ForcaEstado build(String materia) {
    final palavra = _repo.sortear(materia, dificuldade: _dificuldade);
    return ForcaEstado.iniciar(palavra);
  }

  /// Tenta uma letra. Ignora repetições e jogadas após o fim.
  void tentar(String letra) {
    state = state.tentar(letra);
  }

  /// Sorteia uma nova palavra e reinicia a partida.
  void novaPartida({Dificuldade? dificuldade}) {
    _dificuldade = dificuldade ?? _dificuldade;
    final palavra = _repo.sortear(arg, dificuldade: _dificuldade);
    state = ForcaEstado.iniciar(palavra);
  }
}
