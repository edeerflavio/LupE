import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Se os efeitos sonoros estão ligados (persistido). Padrão: ligado.
/// O feedback visual é sempre redundante ao som (RNF07), então mudo não
/// atrapalha a jogabilidade.
final somAtivoProvider =
    NotifierProvider<SomController, bool>(SomController.new);

class SomController extends Notifier<bool> {
  static const _chave = 'lupe.som_ativo';

  @override
  bool build() {
    _carregar();
    return true;
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool(_chave);
    if (v != null) state = v;
  }

  Future<void> alternar() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chave, state);
  }
}
