import 'package:eduplay_kids/domain/models/adivinhe_estado.dart';
import 'package:eduplay_kids/domain/models/adivinhe_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const item = AdivinheItem(
    id: 'x',
    materia: 'geografia',
    tipo: TipoVisual.bandeira,
    resposta: 'JAPÃO',
    dica: 'sushi',
    dificuldade: Dificuldade.facil,
  );

  // Bandeja fixa (não embaralhada) para o teste ser determinístico.
  List<LetraTile> bandeja() => const [
        LetraTile(0, 'J'),
        LetraTile(1, 'A'),
        LetraTile(2, 'P'),
        LetraTile(3, 'A'), // Ã normalizado
        LetraTile(4, 'O'),
      ];

  test('alvos ignoram acento (Ã -> A)', () {
    final e = AdivinheEstado.iniciar(item, bandeja());
    expect(e.alvos, ['J', 'A', 'P', 'A', 'O']);
  });

  test('montar na ordem certa vence', () {
    var e = AdivinheEstado.iniciar(item, bandeja());
    for (final id in [0, 1, 2, 3, 4]) {
      e = e.colocar(id);
    }
    expect(e.completo, true);
    expect(e.correto, true);
  });

  test('ordem errada não vence', () {
    var e = AdivinheEstado.iniciar(item, bandeja());
    for (final id in [1, 0, 2, 3, 4]) {
      e = e.colocar(id);
    }
    expect(e.completo, true);
    expect(e.correto, false);
  });

  test('remover slot devolve a peça', () {
    var e = AdivinheEstado.iniciar(item, bandeja()).colocar(0);
    expect(e.tileUsada(0), true);
    e = e.removerSlot(0);
    expect(e.tileUsada(0), false);
    expect(e.letraNoSlot(0), '');
  });

  test('grupos separam palavras', () {
    const dois = AdivinheItem(
      id: 'y',
      materia: 'geografia',
      tipo: TipoVisual.mapa,
      resposta: 'COSTA RICA',
      dica: '',
      dificuldade: Dificuldade.medio,
    );
    final e = AdivinheEstado.iniciar(dois, const [
      LetraTile(0, 'C'), LetraTile(1, 'O'), LetraTile(2, 'S'),
      LetraTile(3, 'T'), LetraTile(4, 'A'), LetraTile(5, 'R'),
      LetraTile(6, 'I'), LetraTile(7, 'C'), LetraTile(8, 'A'),
    ]);
    expect(e.grupos.length, 2);
    expect(e.grupos[0], [0, 1, 2, 3, 4]); // COSTA
    expect(e.grupos[1], [5, 6, 7, 8]); // RICA
  });
}
