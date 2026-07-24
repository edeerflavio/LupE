import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/narrador.dart';
import '../../core/theme/app_theme.dart';

/// Botão de alto-falante que lê [texto] em voz alta ao toque.
class BotaoFalar extends ConsumerWidget {
  final String texto;
  final double tamanho;
  final Color? cor;

  const BotaoFalar(this.texto, {super.key, this.tamanho = 22, this.cor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Ouvir',
      visualDensity: VisualDensity.compact,
      onPressed: () => ref.read(narradorProvider).falar(texto),
      icon: Icon(Icons.volume_up_rounded,
          size: tamanho, color: cor ?? AppTheme.indigo),
    );
  }
}

/// Widget invisível que narra [texto] automaticamente quando entra na árvore.
/// Use com uma `key` que mude a cada novo conteúdo (ex.: `ValueKey(pergunta.id)`)
/// para narrar de novo a cada pergunta/dica nova.
class NarrarAuto extends ConsumerStatefulWidget {
  final String texto;
  const NarrarAuto(this.texto, {super.key});

  @override
  ConsumerState<NarrarAuto> createState() => _NarrarAutoState();
}

class _NarrarAutoState extends ConsumerState<NarrarAuto> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(narradorProvider).falar(widget.texto);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
