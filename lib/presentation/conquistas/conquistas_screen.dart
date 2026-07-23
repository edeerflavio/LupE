import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/nuvem_controller.dart';
import '../../application/perfil_controller.dart';
import '../../application/progresso_controller.dart';
import '../../core/constants/avatares.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../data/sync/nuvem.dart';
import '../../domain/conquistas.dart';

/// Tela de conquistas do perfil atual (RF01.4): grade de medalhas, com as
/// bloqueadas em cinza e as desbloqueadas coloridas.
class ConquistasScreen extends ConsumerWidget {
  const ConquistasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilAtualProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Conquistas')),
      body: CloudBackground(
        child: SafeArea(
          child: perfil == null
              ? const Center(child: Text('Escolha um perfil primeiro.'))
              : _Conteudo(perfilId: perfil.id),
        ),
      ),
    );
  }
}

class _Conteudo extends ConsumerWidget {
  final String perfilId;
  const _Conteudo({required this.perfilId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressoAsync = ref.watch(progressoProvider(perfilId));

    return progressoAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (progresso) {
        final desbloqueadas = progresso.conquistas;
        final total = catalogoConquistas.length;
        final feitas = catalogoConquistas
            .where((c) => desbloqueadas.contains(c.id))
            .length;

        return Limitado(
          maxWidth: 720,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const KickerLabel('Suas medalhas'),
                      const SizedBox(height: 6),
                      Text('$feitas de $total conquistas',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      const _RankingFamilia(),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate:
                      gradeAdaptativa(extentMax: 170, aspecto: 0.85),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final c = catalogoConquistas[i];
                      return _Medalha(
                        conquista: c,
                        desbloqueada: desbloqueadas.contains(c.id),
                      );
                    },
                    childCount: catalogoConquistas.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Ranking da família, vindo da nuvem. Só aparece se a família estiver logada.
class _RankingFamilia extends ConsumerStatefulWidget {
  const _RankingFamilia();

  @override
  ConsumerState<_RankingFamilia> createState() => _RankingFamiliaState();
}

class _RankingFamiliaState extends ConsumerState<_RankingFamilia> {
  late Future<List<RankingItem>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _carregar();
  }

  Future<List<RankingItem>> _carregar() async {
    final nuvem = ref.read(nuvemProvider);
    if (!nuvem.logada) return const [];
    try {
      return await nuvem.ranking();
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa o estado de login para reconstruir quando a família entra/sai.
    final estado = ref.watch(nuvemEstadoProvider).valueOrNull;
    if (estado == null || !estado.logada) return const SizedBox.shrink();

    return FutureBuilder<List<RankingItem>>(
      future: _futuro,
      builder: (context, snap) {
        final itens = snap.data ?? const [];
        if (itens.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KickerLabel('Ranking da família ☁️'),
              const SizedBox(height: 8),
              for (var i = 0; i < itens.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LinhaRanking(pos: i + 1, item: itens[i]),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _LinhaRanking extends StatelessWidget {
  final int pos;
  final RankingItem item;
  const _LinhaRanking({required this.pos, required this.item});

  @override
  Widget build(BuildContext context) {
    final medalha = pos == 1
        ? '🥇'
        : pos == 2
            ? '🥈'
            : pos == 3
                ? '🥉'
                : '$posº';
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          SizedBox(
              width: 34,
              child: Text(medalha,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900))),
          Text(Avatares.simbolo(item.avatar),
              style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(item.nome,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          Text('${item.acertos} ✅',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w900,
                  color: AppTheme.verde)),
          const SizedBox(width: 10),
          Text('🏅 ${item.medalhas}',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Medalha extends StatelessWidget {
  final Conquista conquista;
  final bool desbloqueada;
  const _Medalha({required this.conquista, required this.desbloqueada});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      tint: desbloqueada ? AppTheme.amarelo.withValues(alpha: 0.22) : null,
      child: Opacity(
        opacity: desbloqueada ? 1 : 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(conquista.emoji, style: const TextStyle(fontSize: 46)),
                if (!desbloqueada)
                  const Icon(Icons.lock_rounded,
                      size: 22, color: Colors.black45),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              conquista.titulo,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            Text(
              conquista.descricao,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppTheme.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
