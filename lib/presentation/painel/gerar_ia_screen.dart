import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/pergunta_controller.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import 'fila_revisao_screen.dart';

/// RF05.3 — Geração de perguntas por IA. As perguntas geradas entram como
/// PENDENTES na fila de revisão (nunca vão direto ao jogo).
class GerarIaScreen extends ConsumerStatefulWidget {
  const GerarIaScreen({super.key});

  @override
  ConsumerState<GerarIaScreen> createState() => _GerarIaScreenState();
}

class _GerarIaScreenState extends ConsumerState<GerarIaScreen> {
  final _temaCtrl = TextEditingController();
  String _materia = Materias.chaves.first;
  int _idade = 8;
  int _quantidade = 5;
  bool _gerando = false;

  @override
  void dispose() {
    _temaCtrl.dispose();
    super.dispose();
  }

  bool get _podeGerar => _temaCtrl.text.trim().isNotEmpty && !_gerando;

  Future<void> _gerar() async {
    setState(() => _gerando = true);
    final novas = await ref.read(perguntasProvider.notifier).gerarPorIA(
          tema: _temaCtrl.text.trim(),
          materia: _materia,
          quantidade: _quantidade,
          idade: _idade,
        );
    if (!mounted) return;
    setState(() => _gerando = false);
    _mostrarResultado(novas.length);
  }

  void _mostrarResultado(int qtd) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Rascunhos criados 🎉'),
        content: Text(
          '$qtd '
          '${qtd == 1 ? "pergunta foi adicionada" : "perguntas foram adicionadas"} '
          'à fila de revisão como PENDENTES.\n\n'
          'Revise, edite o texto e só então aprove para entrar no jogo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Continuar aqui'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const FilaRevisaoScreen(),
                ),
              );
            },
            child: const Text('Ver fila'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Gerar por IA')),
      body: CloudBackground(
        child: SafeArea(
          child: Limitado(
            maxWidth: 640,
            child: ListView(
            padding:
                const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 32),
            children: [
              GlassCard(
                tint: AppTheme.roxo.withValues(alpha: 0.12),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('🔐', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A geração real por IA passará por uma Supabase Edge '
                        'Function — a chave da IA nunca fica no app (RNF06). '
                        'Por enquanto, criamos rascunhos locais para você '
                        'revisar, editar e aprovar.',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textoSuave),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              TextField(
                controller: _temaCtrl,
                onChanged: (_) => setState(() {}),
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Ex.: Sistema Solar, capitais do Brasil...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Matéria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chave in Materias.chaves)
                    _ChipSel(
                      rotulo:
                          '${Materias.emoji(chave)} ${Materias.rotulo(chave)}',
                      selecionado: chave == _materia,
                      onTap: () => setState(() => _materia = chave),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Idade da criança: $_idade anos',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              Slider(
                value: _idade.toDouble(),
                min: 4,
                max: 12,
                divisions: 8,
                label: '$_idade anos',
                activeColor: AppTheme.roxo,
                onChanged: (v) => setState(() => _idade = v.round()),
              ),
              const SizedBox(height: 8),
              Text('Quantidade: $_quantidade perguntas',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              Slider(
                value: _quantidade.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_quantidade',
                activeColor: AppTheme.roxo,
                onChanged: (v) => setState(() => _quantidade = v.round()),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _podeGerar ? _gerar : null,
                icon: _gerando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_gerando ? 'Gerando...' : 'Gerar rascunhos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.roxo,
                  foregroundColor: Colors.white,
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

class _ChipSel extends StatelessWidget {
  final String rotulo;
  final bool selecionado;
  final VoidCallback onTap;

  const _ChipSel({
    required this.rotulo,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado ? AppTheme.roxo : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selecionado ? AppTheme.roxo : Colors.black12,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Text(
          rotulo,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selecionado ? Colors.white : AppTheme.texto,
          ),
        ),
      ),
    );
  }
}
