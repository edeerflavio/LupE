import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/adivinhe_controller.dart';
import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../data/repositories/adivinhe_repository.dart';
import '../../domain/models/adivinhe_estado.dart';
import '../conquistas/celebrar.dart';
import '../widgets/confete.dart';
import '../widgets/narrar.dart';
import 'widgets/visual_adivinhe.dart';

/// Jogo "Adivinhe" (RF-novo): mostra um visual e o jogador monta o nome com
/// letras embaralhadas. Categorias: Bandeiras e Mapa.
class AdivinheScreen extends ConsumerWidget {
  final CategoriaAdivinhe categoria;
  const AdivinheScreen({super.key, required this.categoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = adivinheControllerProvider(categoria);
    final estado = ref.watch(prov);
    final controller = ref.read(prov.notifier);

    ref.listen(prov, (anterior, atual) {
      final acertouAgora =
          (anterior == null || !anterior.correto) && atual.correto;
      if (acertouAgora) {
        HapticFeedback.heavyImpact();
        registrarFimDePartida(
          context,
          ref,
          jogo: 'adivinhe',
          materia: atual.item.materia,
          acertos: 1,
          erros: 0,
          venceu: true,
        );
      } else if (atual.completo && !atual.correto) {
        HapticFeedback.mediumImpact();
        ref.read(sonsProvider).erro();
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Adivinhe · ${categoria.rotulo}'),
        actions: [
          IconButton(
            tooltip: 'Dica',
            onPressed: estado.correto ? null : controller.dica,
            icon: const Icon(Icons.lightbulb_outline),
          ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 16),
              child: Limitado(
                maxWidth: 620,
                child: Column(
                children: [
                  // Marcas não têm dica de texto: o desafio é só o símbolo.
                  if (estado.item.dica.isNotEmpty) ...[
                    NarrarAuto('Dica: ${estado.item.dica}',
                        key: ValueKey('narra_${estado.item.id}')),
                    _Dica(texto: estado.item.dica),
                  ],
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: VisualAdivinhe(item: estado.item),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Slots(estado: estado, onRemover: controller.removerSlot),
                  if (estado.completo && !estado.correto)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Quase! Tente reordenar as letras.',
                          style: TextStyle(
                              color: AppTheme.vermelho,
                              fontWeight: FontWeight.w700)),
                    ),
                  const SizedBox(height: 16),
                  _Bandeja(estado: estado, onColocar: controller.colocar),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: controller.limpar,
                    icon: const Icon(Icons.backspace_outlined),
                    label: const Text('Limpar'),
                  ),
                ],
              ),
              ),
            ),
            if (estado.correto)
              _OverlayAcerto(
                resposta: estado.item.resposta,
                onProximo: controller.proximo,
              ),
            if (estado.correto) const Confete(),
          ],
        ),
      ),
      ),
    );
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
            child: Text(texto,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          BotaoFalar('Dica: $texto'),
        ],
      ),
    );
  }
}

class _Slots extends StatelessWidget {
  final AdivinheEstado estado;
  final void Function(int) onRemover;
  const _Slots({required this.estado, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 10,
      children: [
        for (final grupo in estado.grupos)
          Wrap(
            spacing: 6,
            children: [
              for (final i in grupo)
                _CaixaSlot(
                  letra: estado.letraNoSlot(i),
                  onTap: () => onRemover(i),
                ),
            ],
          ),
      ],
    );
  }
}

class _CaixaSlot extends StatelessWidget {
  final String letra;
  final VoidCallback onTap;
  const _CaixaSlot({required this.letra, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preenchida = letra.isNotEmpty;
    return GestureDetector(
      onTap: preenchida ? onTap : null,
      child: Container(
        width: 40,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: preenchida ? AppTheme.azul : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.azul, width: 2),
        ),
        child: Text(
          letra,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: preenchida ? Colors.white : AppTheme.texto,
          ),
        ),
      ),
    );
  }
}

class _Bandeja extends StatelessWidget {
  final AdivinheEstado estado;
  final void Function(int) onColocar;
  const _Bandeja({required this.estado, required this.onColocar});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tile in estado.bandeja)
          _Peca(
            letra: tile.letra,
            usada: estado.tileUsada(tile.id),
            onTap: () => onColocar(tile.id),
          ),
      ],
    );
  }
}

class _Peca extends StatelessWidget {
  final String letra;
  final bool usada;
  final VoidCallback onTap;
  const _Peca({required this.letra, required this.usada, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: Material(
        color: usada ? Colors.grey.shade200 : AppTheme.roxo,
        borderRadius: BorderRadius.circular(12),
        elevation: usada ? 0 : 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: usada ? null : onTap,
          child: Center(
            child: Text(
              usada ? '' : letra,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayAcerto extends StatelessWidget {
  final String resposta;
  final VoidCallback onProximo;
  const _OverlayAcerto({required this.resposta, required this.onProximo});

  @override
  Widget build(BuildContext context) {
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
              const Text('🎉', style: TextStyle(fontSize: 72)),
              const Text('Isso mesmo!',
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(resposta.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.azul)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onProximo,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Próximo'),
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
