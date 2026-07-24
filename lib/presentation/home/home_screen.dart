import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/config_controller.dart';
import '../../application/perfil_controller.dart';
import '../../core/audio/narrador.dart';
import '../../core/constants/avatares.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../data/repositories/adivinhe_repository.dart';
import '../adivinhe/adivinhe_screen.dart';
import '../conquistas/conquistas_screen.dart';
import '../cruzada/cruzada_screen.dart';
import '../forca/forca_screen.dart';
import '../matematica/mat_intro_screen.dart';
import '../painel/painel_gate_screen.dart';
import '../puzzle/puzzle_screen.dart';
import '../quiz/quiz_intro_screen.dart';
import '../tetris/tetris_screen.dart';
import '../velha/velha_screen.dart';

/// Tela inicial após escolher o perfil. Grade de jogos em painéis de vidro.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilAtualProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CloudBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Limitado(
              maxWidth: 900,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppTheme.texto,
                    ),
                    const Spacer(),
                    if (perfil != null)
                      GlassCard(
                        radius: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Avatares.simbolo(perfil.avatar),
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Text(perfil.nome,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    const SizedBox(width: 4),
                    Consumer(builder: (context, ref, _) {
                      final somAtivo = ref.watch(somAtivoProvider);
                      return IconButton(
                        tooltip: somAtivo ? 'Desligar som' : 'Ligar som',
                        onPressed: () =>
                            ref.read(somAtivoProvider.notifier).alternar(),
                        icon: Icon(somAtivo
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded),
                        color: AppTheme.texto,
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      final narracao = ref.watch(narracaoAtivaProvider);
                      return IconButton(
                        tooltip: narracao
                            ? 'Desligar narração'
                            : 'Ligar narração',
                        onPressed: () {
                          ref.read(narracaoAtivaProvider.notifier).alternar();
                          if (!narracao) {
                            ref
                                .read(narradorProvider)
                                .falar('Narração ligada!');
                          }
                        },
                        icon: Icon(narracao
                            ? Icons.record_voice_over_rounded
                            : Icons.voice_over_off_rounded),
                        color: AppTheme.texto,
                      );
                    }),
                    IconButton(
                      tooltip: 'Área dos pais',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const PainelGateScreen()),
                      ),
                      icon: const Icon(Icons.lock_outline_rounded),
                      color: AppTheme.texto,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const KickerLabel('Escolha uma aventura'),
                const SizedBox(height: 6),
                Text(
                  perfil != null ? 'Oi, ${perfil.nome}! 👋' : 'Vamos jogar!',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GridView(
                    gridDelegate:
                        gradeAdaptativa(extentMax: 240, aspecto: 1.02),
                    children: [
                      _CartaoJogo(
                        titulo: 'Forca',
                        subtitulo: 'Geografia',
                        emoji: '🌎',
                        cor: AppTheme.verde,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const ForcaScreen(materia: 'geografia'),
                          ),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Adivinhe',
                        subtitulo: 'Bandeiras',
                        emoji: '🚩',
                        cor: AppTheme.azul,
                        onTap: () => _abrirAdivinhe(
                            context, CategoriaAdivinhe.bandeiras),
                      ),
                      _CartaoJogo(
                        titulo: 'Adivinhe',
                        subtitulo: 'No mapa',
                        emoji: '🗺️',
                        cor: AppTheme.roxo,
                        onTap: () =>
                            _abrirAdivinhe(context, CategoriaAdivinhe.mapa),
                      ),
                      _CartaoJogo(
                        titulo: 'Adivinhe',
                        subtitulo: 'Animais',
                        emoji: '🦁',
                        cor: AppTheme.verde,
                        onTap: () => _abrirAdivinhe(
                            context, CategoriaAdivinhe.animais),
                      ),
                      _CartaoJogo(
                        titulo: 'Adivinhe',
                        subtitulo: 'Marcas',
                        emoji: '🔶',
                        cor: AppTheme.vermelho,
                        onTap: () => _abrirAdivinhe(
                            context, CategoriaAdivinhe.marcas),
                      ),
                      _CartaoJogo(
                        titulo: 'Matemática',
                        subtitulo: 'Contas',
                        emoji: '➗',
                        cor: AppTheme.vermelho,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const MatIntroScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Quiz',
                        subtitulo: 'Perguntas',
                        emoji: '🧠',
                        cor: AppTheme.indigo,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const QuizIntroScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Jogo da Velha',
                        subtitulo: 'Estratégia',
                        emoji: '⭕',
                        cor: AppTheme.roxo,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const VelhaScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Cruzadinha',
                        subtitulo: 'Palavras',
                        emoji: '✏️',
                        cor: AppTheme.amarelo,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const CruzadaScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Tetris',
                        subtitulo: 'Blocos',
                        emoji: '🧱',
                        cor: AppTheme.azul,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const TetrisScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Quebra-cabeça',
                        subtitulo: 'Deslize',
                        emoji: '🧩',
                        cor: AppTheme.verde,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const PuzzleScreen()),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Forca',
                        subtitulo: 'Modo adulto',
                        emoji: '🎓',
                        cor: AppTheme.vermelho,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const ForcaScreen(materia: 'adulto'),
                          ),
                        ),
                      ),
                      _CartaoJogo(
                        titulo: 'Conquistas',
                        subtitulo: 'Medalhas',
                        emoji: '🏅',
                        cor: AppTheme.amarelo,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ConquistasScreen()),
                        ),
                      ),
                    ],
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

  void _abrirAdivinhe(BuildContext context, CategoriaAdivinhe cat) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AdivinheScreen(categoria: cat)),
    );
  }
}

class _CartaoJogo extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String emoji;
  final Color cor;
  final VoidCallback onTap;

  const _CartaoJogo({
    required this.titulo,
    required this.subtitulo,
    required this.emoji,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 34)),
          ),
          const Spacer(),
          Text(subtitulo.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: cor,
              )),
          const SizedBox(height: 2),
          Text(titulo,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.texto)),
        ],
      ),
    );
  }
}
