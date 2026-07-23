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
    return Pergunta.decode(raw);
  }

  Future<void> salvarTodos(List<Pergunta> perguntas) async {
    final prefs = await SharedPreferences.getInstance();
    await _salvar(prefs, perguntas);
  }

  Future<void> _salvar(SharedPreferences prefs, List<Pergunta> l) =>
      prefs.setString(_chave, Pergunta.encode(l));
}
