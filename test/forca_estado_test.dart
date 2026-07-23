import 'package:eduplay_kids/domain/models/forca_estado.dart';
import 'package:eduplay_kids/domain/models/palavra_forca.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const palavra = PalavraForca(
    id: 't1',
    materia: 'geografia',
    palavra: 'MARINGÁ',
    dica: 'cidade',
    dificuldade: Dificuldade.medio,
  );

  test('digitar A acerta o Á acentuado (RF03.5)', () {
    var estado = ForcaEstado.iniciar(palavra);
    estado = estado.tentar('A');
    // Deve revelar tanto o A quanto o Á acentuado, sem contar como erro.
    expect(estado.erros, 0);
    expect(estado.exibicao, ['_', 'A', '_', '_', '_', '_', 'Á']);
  });

  test('letra ausente conta erro', () {
    var estado = ForcaEstado.iniciar(palavra);
    estado = estado.tentar('Z');
    expect(estado.erros, 1);
    expect(estado.letrasErradas, {'Z'});
  });

  test('repetir letra não muda o estado', () {
    var estado = ForcaEstado.iniciar(palavra).tentar('A');
    final depois = estado.tentar('A');
    expect(depois.letrasTentadas, estado.letrasTentadas);
  });

  test('vitória ao revelar todas as letras', () {
    var estado = ForcaEstado.iniciar(palavra);
    for (final l in ['M', 'A', 'R', 'I', 'N', 'G']) {
      estado = estado.tentar(l);
    }
    expect(estado.status, StatusForca.venceu);
  });

  test('derrota após 6 erros', () {
    var estado = ForcaEstado.iniciar(palavra);
    for (final l in ['B', 'C', 'D', 'E', 'F', 'H']) {
      estado = estado.tentar(l);
    }
    expect(estado.erros, 6);
    expect(estado.status, StatusForca.perdeu);
  });
}
