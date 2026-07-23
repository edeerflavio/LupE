import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/pergunta_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import 'fila_revisao_screen.dart';
import 'gerar_ia_screen.dart';
import 'pergunta_form_screen.dart';
import 'relatorios_screen.dart';

/// Menu do Painel dos Pais (RF05). Só é alcançado depois de passar pelo PIN
/// (ver [PainelGateScreen]).
class PainelHomeScreen extends ConsumerWidget {
  const PainelHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendentes = ref.watch(perguntasPendentesProvider).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Painel dos Pais')),
      body: CloudBackground(
        child: SafeArea(
          child: Limitado(
            maxWidth: 640,
            child: ListView(
            padding:
                const EdgeInsets.fromLTRB(24, kToolbarHeight + 16, 24, 24),
            children: [
              const KickerLabel('Área dos responsáveis'),
              const SizedBox(height: 8),
              const Text(
                'O que vamos fazer?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              _CartaoMenu(
                emoji: '✏️',
                titulo: 'Cadastrar pergunta',
                subtitulo: 'Crie uma pergunta manualmente',
                cor: AppTheme.verde,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PerguntaFormScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _CartaoMenu(
                emoji: '📥',
                titulo: 'Fila de revisão',
                subtitulo: 'Aprove ou rejeite perguntas pendentes',
                cor: AppTheme.azul,
                badge: pendentes,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FilaRevisaoScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _CartaoMenu(
                emoji: '🤖',
                titulo: 'Gerar por IA',
                subtitulo: 'Crie rascunhos para revisar',
                cor: AppTheme.roxo,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GerarIaScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _CartaoMenu(
                emoji: '📊',
                titulo: 'Relatórios',
                subtitulo: 'Conteúdo por matéria e perfis',
                cor: AppTheme.amarelo,
                corTexto: AppTheme.texto,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RelatoriosScreen(),
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _CartaoMenu extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final Color cor;
  final Color corTexto;
  final int? badge;
  final VoidCallback onTap;

  const _CartaoMenu({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.cor,
    required this.onTap,
    this.corTexto = Colors.white,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(
                      fontSize: 14, color: AppTheme.textoSuave),
                ),
              ],
            ),
          ),
          if (badge != null && badge! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: AppTheme.vermelho,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              alignment: Alignment.center,
              child: Text(
                '${badge!}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppTheme.textoSuave),
        ],
      ),
    );
  }
}
