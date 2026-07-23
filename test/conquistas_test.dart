import 'package:eduplay_kids/domain/conquistas.dart';
import 'package:eduplay_kids/domain/models/progresso.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('conquistas por marcos de acertos', () {
    const p = ProgressoPerfil(perfilId: 'x', acertos: 10, partidas: 3);
    final ids = conquistasAlcancadas(p);
    expect(ids, contains('primeira_partida'));
    expect(ids, contains('dez_acertos'));
    expect(ids, isNot(contains('cinquenta_acertos')));
  });

  test('medalha por matéria exige 20 acertos na matéria', () {
    const p = ProgressoPerfil(
      perfilId: 'x',
      acertos: 25,
      partidas: 5,
      acertosPorMateria: {'geografia': 20, 'ciencias': 5},
    );
    final ids = conquistasAlcancadas(p);
    expect(ids, contains('medalha_geografia'));
    expect(ids, isNot(contains('medalha_ciencias')));
  });

  test('explorador exige ter jogado todos os jogos', () {
    const incompleto = ProgressoPerfil(
      perfilId: 'x',
      partidas: 3,
      partidasPorJogo: {'forca': 1, 'quiz': 2},
    );
    expect(conquistasAlcancadas(incompleto), isNot(contains('explorador')));

    const completo = ProgressoPerfil(
      perfilId: 'x',
      partidas: 4,
      partidasPorJogo: {'forca': 1, 'adivinhe': 1, 'matematica': 1, 'quiz': 1},
    );
    expect(conquistasAlcancadas(completo), contains('explorador'));
  });

  test('sequência desbloqueia conquistas de sequência', () {
    const p = ProgressoPerfil(perfilId: 'x', partidas: 1, melhorSequencia: 5);
    final ids = conquistasAlcancadas(p);
    expect(ids, contains('sequencia_5'));
    expect(ids, isNot(contains('sequencia_10')));
  });
}
