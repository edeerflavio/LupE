import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/mat_controller.dart';
import '../../application/perfil_controller.dart';
import '../../application/progresso_controller.dart';
import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/mat_estado.dart';
import '../conquistas/celebrar.dart';
import '../widgets/confete.dart';

/// Módulo Matemática (RF04): conta gerada, 4 alternativas, dificuldade que
/// sobe e desce sozinha, e modo opcional contra o tempo.
class MatScreen extends ConsumerStatefulWidget {
  final ModoMat modo;
  const MatScreen({super.key, required this.modo});

  @override
  ConsumerState<MatScreen> createState() => _MatScreenState();
}

class _MatScreenState extends ConsumerState<MatScreen> {
  Timer? _avanco;
  MatEstado? _ultimo; // última foto do estado, para registrar ao sair
  bool _registrado = false;

  @override
  void dispose() {
    _avanco?.cancel();
    _registrarNoFim(comPopup: false); // modo livre: registra ao sair da tela
    super.dispose();
  }

  void _registrarNoFim({required bool comPopup, MatEstado? estado}) {
    if (_registrado) return;
    final e = estado ?? _ultimo;
    if (e == null || (e.acertos + e.erros) == 0) return;
    _registrado = true;
    final perfilId = ref.read(perfilAtualProvider)?.id;
    if (perfilId == null) return;
    if (comPopup) {
      registrarFimDePartida(
        context,
        ref,
        jogo: 'matematica',
        materia: 'matematica',
        acertos: e.acertos,
        erros: e.erros,
        venceu: true,
      );
    } else {
      // Sem contexto de UI (dispose): só persiste o progresso.
      ref.read(progressoProvider(perfilId).notifier).registrarPartida(
            jogo: 'matematica',
            materia: 'matematica',
            acertos: e.acertos,
            erros: e.erros,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = matControllerProvider(widget.modo);
    final estado = ref.watch(prov);
    final controller = ref.read(prov.notifier);
    _ultimo = estado;

    // Ao responder, dá feedback e agenda a próxima conta.
    ref.listen(prov, (ant, atual) {
      final respondeuAgora =
          (ant == null || !ant.respondida) && atual.respondida;
      if (respondeuAgora) {
        HapticFeedback.lightImpact();
        if (atual.acertou) {
          ref.read(sonsProvider).acerto();
        } else {
          ref.read(sonsProvider).erro();
        }
        _avanco?.cancel();
        _avanco = Timer(const Duration(milliseconds: 850), () {
          if (mounted) controller.proximo();
        });
      }
      // Fim do modo contra o tempo: registra com popup de conquista.
      if ((ant == null || !ant.terminou) && atual.terminou) {
        _registrarNoFim(comPopup: true, estado: atual);
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Matemática'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('⭐ ${estado.pontuacao}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 20, 20, 20),
              child: Limitado(
                maxWidth: 560,
                child: Column(
                children: [
                  _BarraNivel(nivel: estado.nivel, variacao: estado.variacao),
                  if (estado.modo == ModoMat.tempo) ...[
                    const SizedBox(height: 12),
                    _BarraTempo(segundos: estado.segundos),
                  ],
                  const Spacer(),
                  _Conta(texto: estado.conta.enunciado),
                  const Spacer(),
                  _Opcoes(estado: estado, onEscolher: controller.responder),
                  const SizedBox(height: 12),
                  Text('Acertos: ${estado.acertos}   Erros: ${estado.erros}',
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black54)),
                ],
              ),
              ),
            ),
            if (estado.terminou)
              _OverlayFim(estado: estado, onReiniciar: controller.reiniciar),
            if (estado.terminou) const Confete(),
          ],
        ),
      ),
      ),
    );
  }
}

class _BarraNivel extends StatelessWidget {
  final int nivel;
  final VariacaoNivel variacao;
  const _BarraNivel({required this.nivel, required this.variacao});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nível $nivel  ',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            for (var i = 0; i < 6; i++)
              Icon(
                i < nivel ? Icons.star : Icons.star_border,
                color: AppTheme.amarelo,
                size: 22,
              ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: variacao == VariacaoNivel.nenhuma
              ? const SizedBox(height: 0)
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    variacao == VariacaoNivel.subiu
                        ? 'Subiu de nível! ⬆️'
                        : 'Vamos com calma ⬇️',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: variacao == VariacaoNivel.subiu
                          ? AppTheme.verde
                          : AppTheme.azul,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _BarraTempo extends StatelessWidget {
  final int segundos;
  const _BarraTempo({required this.segundos});

  @override
  Widget build(BuildContext context) {
    final frac = (segundos / 60).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 20),
            const SizedBox(width: 6),
            Text('$segundos s',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: frac,
            minHeight: 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(
                frac > 0.3 ? AppTheme.verde : AppTheme.vermelho),
          ),
        ),
      ],
    );
  }
}

class _Conta extends StatelessWidget {
  final String texto;
  const _Conta({required this.texto});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        '$texto = ?',
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w900,
          color: AppTheme.texto,
        ),
      ),
    );
  }
}

class _Opcoes extends StatelessWidget {
  final MatEstado estado;
  final void Function(int) onEscolher;
  const _Opcoes({required this.estado, required this.onEscolher});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 2.2,
      children: [
        for (final valor in estado.opcoes)
          _BotaoOpcao(
            valor: valor,
            estado: estado,
            onTap: () => onEscolher(valor),
          ),
      ],
    );
  }
}

class _BotaoOpcao extends StatelessWidget {
  final int valor;
  final MatEstado estado;
  final VoidCallback onTap;
  const _BotaoOpcao(
      {required this.valor, required this.estado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final respondida = estado.respondida;
    final ehCerta = valor == estado.conta.resposta;
    final foiEscolhida = valor == estado.escolha;

    Color cor = AppTheme.roxo;
    if (respondida) {
      if (ehCerta) {
        cor = AppTheme.verde;
      } else if (foiEscolhida) {
        cor = AppTheme.vermelho;
      } else {
        cor = Colors.grey.shade400;
      }
    }

    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(20),
      elevation: respondida ? 0 : 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: respondida ? null : onTap,
        child: Center(
          child: Text(
            '$valor',
            style: const TextStyle(
                fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _OverlayFim extends StatelessWidget {
  final MatEstado estado;
  final VoidCallback onReiniciar;
  const _OverlayFim({required this.estado, required this.onReiniciar});

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
              const Text('⏱️', style: TextStyle(fontSize: 64)),
              const Text('Tempo!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Pontuação: ${estado.pontuacao}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.azul)),
              Text('${estado.acertos} acertos • ${estado.erros} erros',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onReiniciar,
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
