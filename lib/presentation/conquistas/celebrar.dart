import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/perfil_controller.dart';
import '../../application/progresso_controller.dart';
import '../../core/audio/sons.dart';
import 'conquista_popup.dart';

/// Chamado ao fim de uma partida: toca o som de vitória (se venceu), registra o
/// progresso do perfil atual e mostra o popup de conquistas desbloqueadas.
///
/// Centraliza a gamificação para todos os jogos (RF01.4/01.5, Fase 5).
Future<void> registrarFimDePartida(
  BuildContext context,
  WidgetRef ref, {
  required String jogo, // 'forca'|'adivinhe'|'matematica'|'quiz'
  String? materia,
  required int acertos,
  required int erros,
  int sequenciaMax = 0,
  bool venceu = true,
}) async {
  if (venceu) ref.read(sonsProvider).vitoria();

  final perfilId = ref.read(perfilAtualProvider)?.id;
  if (perfilId == null) return;

  final novas =
      await ref.read(progressoProvider(perfilId).notifier).registrarPartida(
            jogo: jogo,
            materia: materia,
            acertos: acertos,
            erros: erros,
            sequenciaMax: sequenciaMax,
          );

  if (context.mounted) {
    await mostrarConquistas(context, novas);
  }
}
