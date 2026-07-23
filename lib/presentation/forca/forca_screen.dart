import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/forca_controller.dart';
import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/forca_estado.dart';
import '../conquistas/celebrar.dart';
import '../widgets/confete.dart';
import 'widgets/boneco_forca.dart';
import 'widgets/teclado_virtual.dart';

/// Módulo Forca (RF03). Recebe a matéria e monta uma partida.
class ForcaScreen extends ConsumerWidget {
  final String materia;
  const ForcaScreen({super.key, required this.materia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(forcaControllerProvider(materia));
    final controller = ref.read(forcaControllerProvider(materia).notifier);

    // Feedback e registro ao terminar a partida.
    ref.listen(forcaControllerProvider(materia), (anterior, atual) {
      if (anterior != null && !anterior.terminou && atual.terminou) {
        final venceu = atual.status == StatusForca.venceu;
        if (venceu) {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.vibrate();
          ref.read(sonsProvider).erro();
        }
        registrarFimDePartida(
          context,
          ref,
          jogo: 'forca',
          materia: materia,
          acertos: venceu ? 1 : 0,
          erros: atual.erros,
          venceu: venceu,
        );
      }
    });

    final certas = estado.letrasTentadas
        .where((l) => estado.palavra.normalizada.contains(l))
        .toSet();
    final erradas = estado.letrasErradas;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Forca · Geografia'),
      ),
      body: CloudBackground(
        child: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, kToolbarHeight + 8, 16, 8),
                      child: Limitado(
                        maxWidth: 560,
                        child: Column(
                        children: [
                          _Dica(texto: estado.palavra.dica),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 180,
                            child: BonecoForca(erros: estado.erros),
                          ),
                          _Coracoes(restantes: estado.errosRestantes),
                          const SizedBox(height: 12),
                          _Palavra(letras: estado.exibicao),
                          const SizedBox(height: 16),
                          TecladoVirtual(
                            letrasCertas: certas,
                            letrasErradas: erradas,
                            habilitado: !estado.terminou,
                            onLetra: (l) =>
                                _tentar(ref, controller, estado, l),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (estado.terminou)
              _OverlayFim(
                estado: estado,
                onNovaPartida: controller.novaPartida,
              ),
            if (estado.status == StatusForca.venceu) const Confete(),
          ],
        ),
      ),
      ),
    );
  }

  void _tentar(
      WidgetRef ref, ForcaController controller, ForcaEstado estado, String letra) {
    if (estado.jaTentou(letra) || estado.terminou) return;
    if (estado.acertou(letra)) {
      HapticFeedback.lightImpact();
      ref.read(sonsProvider).acerto();
    } else {
      HapticFeedback.mediumImpact();
      ref.read(sonsProvider).erro();
    }
    controller.tentar(letra);
  }
}

class _Dica extends StatelessWidget {
  final String texto;
  const _Dica({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.amarelo.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Coracoes extends StatelessWidget {
  final int restantes;
  const _Coracoes({required this.restantes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              i < restantes ? '❤️' : '🖤',
              style: const TextStyle(fontSize: 24),
            ),
          ),
      ],
    );
  }
}

class _Palavra extends StatelessWidget {
  final List<String> letras;
  const _Palavra({required this.letras});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final l in letras)
          Container(
            width: l == ' ' ? 16 : 38,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: (l == ' ')
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppTheme.roxo, width: 4),
                    ),
            ),
            child: Text(
              l == '_' ? '' : l,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppTheme.texto,
              ),
            ),
          ),
      ],
    );
  }
}

class _OverlayFim extends StatelessWidget {
  final ForcaEstado estado;
  final VoidCallback onNovaPartida;

  const _OverlayFim({required this.estado, required this.onNovaPartida});

  @override
  Widget build(BuildContext context) {
    final venceu = estado.status == StatusForca.venceu;
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(venceu ? '🎉' : '😅', style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 8),
              Text(
                venceu ? 'Você acertou!' : 'Quase!',
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text('A palavra era:', style: TextStyle(fontSize: 16)),
              Text(
                estado.palavra.palavra.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.roxo,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => onNovaPartida(),
                icon: const Icon(Icons.refresh),
                label: const Text('Jogar de novo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verde,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Voltar aos jogos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
