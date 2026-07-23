import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/perfil_controller.dart';
import '../../core/constants/avatares.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/perfil.dart';
import '../home/home_screen.dart';
import 'criar_perfil_screen.dart';

/// RF01.2 — seleção de perfil na abertura, sem senha. Visual estilo PetDex.
class PerfilSelectionScreen extends ConsumerWidget {
  const PerfilSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfisAsync = ref.watch(perfisProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CloudBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Limitado(
              maxWidth: 760,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const KickerLabel('Pedro & Luiza'),
                const SizedBox(height: 8),
                const Text(
                  'LuPe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: AppTheme.texto,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Quem vai jogar hoje?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: AppTheme.textoSuave),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: perfisAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Erro: $e')),
                    data: (perfis) => _grade(context, ref, perfis),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _grade(BuildContext context, WidgetRef ref, List<Perfil> perfis) {
    return GridView(
      gridDelegate: gradeAdaptativa(extentMax: 180, aspecto: 0.82, espaco: 22),
      children: [
        for (var i = 0; i < perfis.length; i++)
          _Inclinado(
            index: i,
            child: _CartaoPerfil(perfil: perfis[i]),
          ),
        const _CartaoNovo(),
      ],
    );
  }
}

/// Leve inclinação alternada, como o "hero parade" do PetDex.
class _Inclinado extends StatelessWidget {
  final int index;
  final Widget child;
  const _Inclinado({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final angulo = (index.isEven ? -3 : 3) * 3.1415926 / 180;
    return Transform.rotate(angle: angulo, child: child);
  }
}

class _CartaoPerfil extends ConsumerWidget {
  final Perfil perfil;
  const _CartaoPerfil({required this.perfil});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () {
        ref.read(perfilAtualProvider.notifier).state = perfil;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      onLongPress: () => _confirmarRemocao(context, ref),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Avatares.simbolo(perfil.avatar),
              style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 8),
          Text(
            perfil.nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          Text('${perfil.anoEscolar}º ano',
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textoSuave)),
        ],
      ),
    );
  }

  void _confirmarRemocao(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remover ${perfil.nome}?'),
        content: const Text('O progresso deste perfil será apagado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(perfisProvider.notifier).remover(perfil.id);
              Navigator.pop(ctx);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

class _CartaoNovo extends StatelessWidget {
  const _CartaoNovo();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      tint: AppTheme.indigo.withValues(alpha: 0.16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CriarPerfilScreen()),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, size: 60, color: AppTheme.indigo),
          SizedBox(height: 8),
          Text('Novo perfil',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
