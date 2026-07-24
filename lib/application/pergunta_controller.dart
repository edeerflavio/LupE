import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/gerador_ia.dart';
import '../data/repositories/pergunta_repository.dart';
import '../domain/models/pergunta.dart';

final perguntaRepositoryProvider = Provider((_) => PerguntaRepository());
final geradorIAProvider = Provider<GeradorIA>((_) => GeradorIALocal());

/// Estado global das perguntas (compartilhado por Quiz e Painel dos Pais).
final perguntasProvider =
    AsyncNotifierProvider<PerguntasController, List<Pergunta>>(
  PerguntasController.new,
);

class PerguntasController extends AsyncNotifier<List<Pergunta>> {
  PerguntaRepository get _repo => ref.read(perguntaRepositoryProvider);

  @override
  Future<List<Pergunta>> build() => _repo.carregar();

  List<Pergunta> get _atuais => state.valueOrNull ?? const [];

  Future<void> _persistir(List<Pergunta> lista) async {
    await _repo.salvarTodos(lista);
    state = AsyncData(lista);
  }

  Future<void> adicionar(Pergunta p) => _persistir([..._atuais, p]);

  Future<void> adicionarVarias(List<Pergunta> ps) =>
      _persistir([..._atuais, ...ps]);

  Future<void> editar(Pergunta p) => _persistir(
        [for (final q in _atuais) if (q.id == p.id) p else q],
      );

  Future<void> definirStatus(String id, StatusPergunta status) => _persistir(
        [
          for (final q in _atuais)
            if (q.id == id) q.copyWith(status: status) else q
        ],
      );

  Future<void> remover(String id) =>
      _persistir(_atuais.where((q) => q.id != id).toList());

  Future<List<Pergunta>> gerarPorIA({
    required String tema,
    required String materia,
    required int quantidade,
    required int idade,
  }) async {
    final novas = await ref.read(geradorIAProvider).gerar(
          tema: tema,
          materia: materia,
          quantidade: quantidade,
          idade: idade,
        );
    await adicionarVarias(novas);
    return novas;
  }
}

// ---- Seletores derivados ----

/// Todas as perguntas aprovadas de uma matéria (o que o Quiz consome).
final perguntasAprovadasProvider =
    Provider.family<List<Pergunta>, String>((ref, materia) {
  final todas = ref.watch(perguntasProvider).valueOrNull ?? const [];
  return todas
      .where((p) => p.status == StatusPergunta.aprovada && p.materia == materia)
      .toList();
});

/// Matérias que têm ao menos uma pergunta aprovada.
final materiasComQuizProvider = Provider<List<String>>((ref) {
  final todas = ref.watch(perguntasProvider).valueOrNull ?? const [];
  final set = <String>{
    for (final p in todas)
      if (p.status == StatusPergunta.aprovada) p.materia
  };
  final ordem = [
    'geografia',
    'capitais',
    'ciencias',
    'historia',
    'portugues',
    'conhecimentos',
    'adulto',
  ];
  final lista = set.toList()
    ..sort((a, b) {
      final ia = ordem.indexOf(a), ib = ordem.indexOf(b);
      return (ia == -1 ? 999 : ia).compareTo(ib == -1 ? 999 : ib);
    });
  return lista;
});

/// Fila de revisão: perguntas pendentes (Painel dos Pais).
final perguntasPendentesProvider = Provider<List<Pergunta>>((ref) {
  final todas = ref.watch(perguntasProvider).valueOrNull ?? const [];
  return todas.where((p) => p.status == StatusPergunta.pendente).toList();
});
