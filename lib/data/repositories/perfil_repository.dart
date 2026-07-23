import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/perfil.dart';

/// Persistência local de perfis (RF01.1, "persistem entre sessões").
///
/// Usa SharedPreferences por simplicidade — o PRD adverte para não
/// sobre-engenheirar o offline em uso familiar. A interface é isolada
/// para que, no futuro, um repositório Supabase possa substituí-la.
class PerfilRepository {
  static const _chave = 'eduplay.perfis';

  Future<List<Perfil>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chave);
    if (raw == null || raw.isEmpty) return [];
    final lista = jsonDecode(raw) as List<dynamic>;
    return lista
        .map((e) => Perfil.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvarTodos(List<Perfil> perfis) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(perfis.map((p) => p.toMap()).toList());
    await prefs.setString(_chave, raw);
  }
}
