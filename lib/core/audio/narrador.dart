import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Se a narração por voz está ligada (persistido). Padrão: ligada.
/// A narração é redundante ao texto na tela (RNF07): se a voz falhar ou
/// estiver desligada, o jogo continua normal.
final narracaoAtivaProvider =
    NotifierProvider<NarracaoController, bool>(NarracaoController.new);

class NarracaoController extends Notifier<bool> {
  static const _chave = 'lupe.narracao_ativa';

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

final narradorProvider = Provider<Narrador>((ref) {
  final n = Narrador(ativo: () => ref.read(narracaoAtivaProvider));
  ref.onDispose(n.dispose);
  return n;
});

/// Narração em voz alta (pt-BR) via síntese de fala do próprio aparelho.
/// Pensada para crianças pré-alfabetizadas: lê perguntas, dicas e instruções.
class Narrador {
  final FlutterTts _tts = FlutterTts();

  /// Consulta se a narração está ligada (respeita o botão de voz).
  final bool Function() _ativo;
  bool _pronto = false;

  Narrador({bool Function()? ativo}) : _ativo = ativo ?? (() => true);

  Future<void> _preparar() async {
    if (_pronto) return;
    await _tts.setLanguage('pt-BR');
    // Na web a taxa 1.0 é a fala normal; no mobile o normal é ~0.5.
    await _tts.setSpeechRate(kIsWeb ? 0.9 : 0.45);
    await _tts.setPitch(1.05);
    _pronto = true;
  }

  /// Fala [texto] em pt-BR. Nunca lança — falha de voz não pode quebrar o jogo.
  Future<void> falar(String texto) async {
    if (!_ativo() || texto.trim().isEmpty) return;
    try {
      await _preparar();
      await _tts.stop();
      await _tts.speak(texto);
    } catch (_) {
      // Silencioso: o texto na tela já cobre (RNF07).
    }
  }

  Future<void> parar() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  void dispose() {
    try {
      _tts.stop();
    } catch (_) {}
  }
}
