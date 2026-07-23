import 'dart:math';

import '../../domain/models/palavra_forca.dart';
import '../seed/palavras_geografia.dart';

/// Fornece palavras para a Forca a partir das sementes locais.
/// Substituível por uma fonte Supabase no futuro sem mudar a UI.
class PalavraRepository {
  final Random _random;

  PalavraRepository({Random? random}) : _random = random ?? Random();

  List<PalavraForca> _porMateria(String materia) {
    switch (materia) {
      case 'geografia':
        return seedGeografia;
      default:
        return const [];
    }
  }

  /// Materias disponíveis com pelo menos uma palavra.
  List<String> materiasDisponiveis() => const ['geografia'];

  /// Sorteia uma palavra (RF03.1). Filtra por dificuldade quando informada;
  /// se não houver palavra na dificuldade pedida, cai para o conjunto todo.
  PalavraForca sortear(String materia, {Dificuldade? dificuldade}) {
    final todas = _porMateria(materia);
    if (todas.isEmpty) {
      throw StateError('Sem palavras para a matéria "$materia".');
    }
    var pool = dificuldade == null
        ? todas
        : todas.where((p) => p.dificuldade == dificuldade).toList();
    if (pool.isEmpty) pool = todas;
    return pool[_random.nextInt(pool.length)];
  }
}
