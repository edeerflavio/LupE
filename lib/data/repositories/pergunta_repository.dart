import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/pergunta.dart';
import '../seed/perguntas_seed.dart';

/// Persistência local de perguntas (offline-first). Na primeira execução,
/// semeia o banco com [seedPerguntas] (todas aprovadas).
class PerguntaRepository {
  static const _chave = 'lupe.perguntas';

  Future<List<Pergunta>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chave);
    if (raw == null || raw.isEmpty) {
      await _salvar(prefs, seedPerguntas);
      return List.of(seedPerguntas);
    }
    final atuais = Pergunta.decode(raw);
    // Novas perguntas da semente (de atualizações do app) entram no banco
    // local sem apagar as criadas/editadas pela família.
    final ids = atuais.map((p) => p.id).toSet();
    final novas = seedPerguntas.where((p) => !ids.contains(p.id)).toList();
    if (novas.isEmpty) return atuais;
    final todas = [...atuais, ...novas];
    await _salvar(prefs, todas);
    return todas;
  }

  Future<void> salvarTodos(List<Pergunta> perguntas) async {
    final prefs = await SharedPreferences.getInstance();
    await _salvar(prefs, perguntas);
  }

  Future<void> _salvar(SharedPreferences prefs, List<Pergunta> l) =>
      prefs.setString(_chave, Pergunta.encode(l));
}
