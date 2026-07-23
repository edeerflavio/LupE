import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/perfil_controller.dart';
import '../../application/pergunta_controller.dart';
import '../../application/progresso_controller.dart';
import '../../core/constants/avatares.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/perfil.dart';
import '../../domain/models/pergunta.dart';

/// RF05.5 — Relatórios. Enquanto o histórico de partidas não é persistido,
/// mostramos um panorama de CONTEÚDO: por matéria, quantas perguntas aprovadas
/// e pendentes existem; o total geral; e a lista de perfis (filhos).
class RelatoriosScreen extends ConsumerWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todas = ref.watch(perguntasProvider).valueOrNull ?? const <Pergunta>[];
    final perfis = ref.watch(perfisProvider).valueOrNull ?? const [];

    final totalAprovadas =
        todas.where((p) => p.status == StatusPergunta.aprovada).length;
    final totalPendentes =
        todas.where((p) => p.status == StatusPergunta.pendente).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Relatórios')),
      body: CloudBackground(
        child: SafeArea(
          child: Limitado(
            maxWidth: 640,
            child: ListView(
            padding:
                const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 32),
            children: [
              const KickerLabel('Panorama de conteúdo'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CartaoTotal(
                      valor: '${todas.length}',
                      rotulo: 'perguntas no total',
                      cor: AppTheme.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CartaoTotal(
                      valor: '$totalAprovadas',
                      rotulo: 'aprovadas',
                      cor: AppTheme.verde,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CartaoTotal(
                      valor: '$totalPendentes',
                      rotulo: 'pendentes',
                      cor: AppTheme.amarelo,
                      corTexto: AppTheme.texto,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Por matéria',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              for (final chave in Materias.chaves)
                _LinhaMateria(
                  chave: chave,
                  aprovadas: todas
                      .where((p) =>
                          p.materia == chave &&
                          p.status == StatusPergunta.aprovada)
                      .length,
                  pendentes: todas
                      .where((p) =>
                          p.materia == chave &&
                          p.status == StatusPergunta.pendente)
                      .length,
                ),
              const SizedBox(height: 24),
              const Text('Desempenho dos filhos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              if (perfis.isEmpty)
                const Text(
                  'Nenhum perfil cadastrado ainda.',
                  style: TextStyle(color: AppTheme.textoSuave),
                )
              else
                for (final perfil in perfis)
                  _CartaoDesempenho(perfil: perfil),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

/// Desempenho de um filho, lido do progresso persistido (RF05.5).
class _CartaoDesempenho extends ConsumerWidget {
  final Perfil perfil;
  const _CartaoDesempenho({required this.perfil});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prog = ref.watch(progressoProvider(perfil.id)).valueOrNull;
    final acertos = prog?.acertos ?? 0;
    final erros = prog?.erros ?? 0;
    final partidas = prog?.partidas ?? 0;
    final sequencia = prog?.melhorSequencia ?? 0;
    final medalhas = prog?.conquistas.length ?? 0;
    final totalResp = acertos + erros;
    final taxa = totalResp == 0 ? 0 : ((acertos / totalResp) * 100).round();

    // Matéria com mais acertos.
    String? melhorMateria;
    var melhor = 0;
    (prog?.acertosPorMateria ?? const <String, int>{}).forEach((m, v) {
      if (v > melhor) {
        melhor = v;
        melhorMateria = m;
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(Avatares.simbolo(perfil.avatar),
                    style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(perfil.nome,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                Text('${perfil.anoEscolar}º ano',
                    style: const TextStyle(
                        color: AppTheme.textoSuave,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            if (partidas == 0) ...[
              const SizedBox(height: 10),
              const Text('Ainda não jogou.',
                  style: TextStyle(color: AppTheme.textoSuave)),
            ] else ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Mini(rotulo: 'partidas', valor: '$partidas', cor: AppTheme.indigo),
                  _Mini(rotulo: 'acertos', valor: '$acertos', cor: AppTheme.verde),
                  _Mini(rotulo: 'erros', valor: '$erros', cor: AppTheme.vermelho),
                  _Mini(rotulo: 'acerto', valor: '$taxa%', cor: AppTheme.azul),
                  _Mini(rotulo: 'sequência', valor: '🔥 $sequencia', cor: AppTheme.roxo),
                  _Mini(rotulo: 'medalhas', valor: '🏅 $medalhas', cor: AppTheme.amarelo, corTexto: AppTheme.texto),
                ],
              ),
              if (melhorMateria != null) ...[
                const SizedBox(height: 10),
                Text('Melhor matéria: ${Materias.rotulo(melhorMateria!)} ($melhor acertos)',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textoSuave)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String rotulo;
  final String valor;
  final Color cor;
  final Color corTexto;
  const _Mini({
    required this.rotulo,
    required this.valor,
    required this.cor,
    this.corTexto = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(valor,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: corTexto)),
          Text(rotulo,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: corTexto.withValues(alpha: 0.9))),
        ],
      ),
    );
  }
}

class _CartaoTotal extends StatelessWidget {
  final String valor;
  final String rotulo;
  final Color cor;
  final Color corTexto;

  const _CartaoTotal({
    required this.valor,
    required this.rotulo,
    required this.cor,
    this.corTexto = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w900, color: corTexto),
          ),
          const SizedBox(height: 4),
          Text(
            rotulo,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: corTexto.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}

class _LinhaMateria extends StatelessWidget {
  final String chave;
  final int aprovadas;
  final int pendentes;

  const _LinhaMateria({
    required this.chave,
    required this.aprovadas,
    required this.pendentes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(Materias.emoji(chave),
                style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                Materias.rotulo(chave),
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ),
            _Selo(
              texto: '$aprovadas',
              legenda: 'aprov.',
              cor: AppTheme.verde,
            ),
            const SizedBox(width: 8),
            _Selo(
              texto: '$pendentes',
              legenda: 'pend.',
              cor: AppTheme.amarelo,
              corTexto: AppTheme.texto,
            ),
          ],
        ),
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  final String texto;
  final String legenda;
  final Color cor;
  final Color corTexto;

  const _Selo({
    required this.texto,
    required this.legenda,
    required this.cor,
    this.corTexto = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            texto,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: corTexto),
          ),
          Text(
            legenda,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: corTexto.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
