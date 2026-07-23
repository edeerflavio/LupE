import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/progresso.dart';

/// Persistência local do progresso, uma chave por perfil.
class ProgressoRepository {
  String _chave(String perfilId) => 'lupe.progresso.$perfilId';

  Future<ProgressoPerfil> carregar(String perfilId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chave(perfilId));
    if (raw == null || raw.isEmpty) {
      return ProgressoPerfil(perfilId: perfilId);
    }
    return ProgressoPerfil.fromJson(raw);
  }

  Future<void> salvar(ProgressoPerfil p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave(p.perfilId), p.toJson());
  }
}
