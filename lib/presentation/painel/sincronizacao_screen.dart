import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/nuvem_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';

/// Configuração da sincronização na nuvem (RF01.5 + ranking familiar).
/// Login da família contra o backend PocketBase da VPS.
class SincronizacaoScreen extends ConsumerStatefulWidget {
  const SincronizacaoScreen({super.key});

  @override
  ConsumerState<SincronizacaoScreen> createState() => _SincronizacaoState();
}

class _SincronizacaoState extends ConsumerState<SincronizacaoScreen> {
  final _urlCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _ocupado = false;
  String? _erro;

  @override
  void dispose() {
    _urlCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _acao(Future<void> Function() f) async {
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      await f();
    } catch (e) {
      setState(() => _erro = 'Não deu certo: ${_limpar(e)}');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  String _limpar(Object e) {
    final s = e.toString();
    return s.length > 120 ? '${s.substring(0, 120)}…' : s;
  }

  @override
  Widget build(BuildContext context) {
    final estadoAsync = ref.watch(nuvemEstadoProvider);
    final estado = estadoAsync.valueOrNull ?? const NuvemEstado();
    if (_urlCtrl.text.isEmpty && estado.url != null) {
      _urlCtrl.text = estado.url!;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Sincronização na nuvem')),
      body: CloudBackground(
        child: SafeArea(
          child: Limitado(
            maxWidth: 560,
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 24),
              children: [
                const Text('☁️', style: TextStyle(fontSize: 56),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Center(
                  child: _Status(logada: estado.logada, email: estado.email),
                ),
                const SizedBox(height: 20),
                const Text('Endereço do servidor',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _campo(_urlCtrl, 'https://lupe-api.seudominio.com',
                    teclado: TextInputType.url),
                const SizedBox(height: 8),
                _BotaoLargo(
                  rotulo: 'Salvar endereço',
                  cor: AppTheme.indigo,
                  onTap: _ocupado || _urlCtrl.text.trim().isEmpty
                      ? null
                      : () => _acao(() => ref
                          .read(nuvemEstadoProvider.notifier)
                          .definirUrl(_urlCtrl.text)),
                ),
                const SizedBox(height: 24),
                if (!estado.logada) ...[
                  const Text('Conta da família',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _campo(_emailCtrl, 'e-mail da família',
                      teclado: TextInputType.emailAddress),
                  const SizedBox(height: 8),
                  _campo(_senhaCtrl, 'senha (mín. 8 caracteres)',
                      senha: true),
                  const SizedBox(height: 12),
                  _BotaoLargo(
                    rotulo: 'Entrar',
                    cor: AppTheme.verde,
                    onTap: _ocupado || !estado.configurada
                        ? null
                        : () => _acao(() => ref
                            .read(nuvemEstadoProvider.notifier)
                            .entrar(_emailCtrl.text, _senhaCtrl.text)),
                  ),
                  const SizedBox(height: 8),
                  _BotaoLargo(
                    rotulo: 'Criar conta da família',
                    cor: AppTheme.roxo,
                    onTap: _ocupado || !estado.configurada
                        ? null
                        : () => _acao(() => ref
                            .read(nuvemEstadoProvider.notifier)
                            .criarConta(_emailCtrl.text, _senhaCtrl.text)),
                  ),
                ] else
                  _BotaoLargo(
                    rotulo: 'Sair da conta',
                    cor: AppTheme.vermelho,
                    onTap: _ocupado
                        ? null
                        : () => _acao(
                            () => ref.read(nuvemEstadoProvider.notifier).sair()),
                  ),
                if (_ocupado) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
                if (_erro != null) ...[
                  const SizedBox(height: 12),
                  Text(_erro!,
                      style: const TextStyle(
                          color: AppTheme.vermelho,
                          fontWeight: FontWeight.w700)),
                ],
                const SizedBox(height: 24),
                Text(
                  'Sem servidor, tudo continua salvo só neste aparelho. Com a '
                  'conta da família, o progresso e as conquistas ficam salvos na '
                  'sua VPS, sincronizam entre aparelhos e o ranking da família '
                  'aparece nas Conquistas. Veja backend/README.md para subir o '
                  'servidor.',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textoSuave.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController c, String hint,
      {bool senha = false, TextInputType? teclado}) {
    return TextField(
      controller: c,
      obscureText: senha,
      keyboardType: teclado,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final bool logada;
  final String? email;
  const _Status({required this.logada, this.email});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(logada ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              color: logada ? AppTheme.verde : AppTheme.textoSuave),
          const SizedBox(width: 10),
          Text(
            logada ? 'Conectado: ${email ?? ''}' : 'Não conectado',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _BotaoLargo extends StatelessWidget {
  final String rotulo;
  final Color cor;
  final VoidCallback? onTap;
  const _BotaoLargo({required this.rotulo, required this.cor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
        ),
        child: Text(rotulo),
      ),
    );
  }
}
