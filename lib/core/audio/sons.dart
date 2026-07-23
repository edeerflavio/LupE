import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/config_controller.dart';

/// Efeitos sonoros do app (RF02.3 / engajamento infantil).
///
/// Os sons foram gerados por síntese (sem copyright) e ficam em
/// `assets/sounds/`. O áudio é redundante ao feedback visual (RNF07): se o som
/// falhar ou estiver mudo, o jogo continua normal.
enum Efeito { acerto, erro, vitoria, conquista, toque }

final sonsProvider = Provider<Sons>((ref) {
  final s = Sons(ativo: () => ref.read(somAtivoProvider));
  ref.onDispose(s.dispose);
  return s;
});

class Sons {
  final AudioPlayer _player = AudioPlayer(playerId: 'lupe_sfx');

  /// Consulta se o som está ligado (respeita o botão de mudo).
  final bool Function() _ativo;

  static const Map<Efeito, String> _arquivos = {
    Efeito.acerto: 'sounds/acerto.wav',
    Efeito.erro: 'sounds/erro.wav',
    Efeito.vitoria: 'sounds/vitoria.wav',
    Efeito.conquista: 'sounds/conquista.wav',
    Efeito.toque: 'sounds/toque.wav',
  };

  Sons({bool Function()? ativo}) : _ativo = ativo ?? (() => true) {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  /// Toca um efeito. Nunca lança — falha de áudio não pode quebrar o jogo.
  Future<void> tocar(Efeito efeito) async {
    if (!_ativo()) return;
    final arq = _arquivos[efeito];
    if (arq == null) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(arq), volume: 0.9);
    } catch (_) {
      // Silencioso: o feedback visual já cobre (RNF07).
    }
  }

  void acerto() => tocar(Efeito.acerto);
  void erro() => tocar(Efeito.erro);
  void vitoria() => tocar(Efeito.vitoria);
  void conquista() => tocar(Efeito.conquista);

  void dispose() => _player.dispose();
}
