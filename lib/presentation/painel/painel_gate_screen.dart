import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/pin_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import 'painel_home_screen.dart';

/// RF05.1 — Porta de entrada do Painel dos Pais, protegida por PIN de 4 dígitos.
///
/// Se ainda não há PIN, o responsável define um (digita e confirma). Se já há,
/// pede o PIN para entrar. O teclado numérico é próprio (botões grandes), para
/// não depender do teclado do sistema e reforçar que é uma área "de adulto".
class PainelGateScreen extends ConsumerStatefulWidget {
  const PainelGateScreen({super.key});

  @override
  ConsumerState<PainelGateScreen> createState() => _PainelGateScreenState();
}

enum _Fase { carregando, criar, confirmar, pedir }

class _PainelGateScreenState extends ConsumerState<PainelGateScreen> {
  _Fase _fase = _Fase.carregando;
  String _digitos = '';
  String _primeiroPin = ''; // guardado entre "criar" e "confirmar"
  String? _erro;
  bool _verificando = false;

  static const int _tamanho = 4;

  @override
  void initState() {
    super.initState();
    _decidirFaseInicial();
  }

  Future<void> _decidirFaseInicial() async {
    final existe = await ref.read(pinProvider.notifier).existePin();
    if (!mounted) return;
    setState(() => _fase = existe ? _Fase.pedir : _Fase.criar);
  }

  void _digitar(String d) {
    if (_verificando || _digitos.length >= _tamanho) return;
    setState(() {
      _erro = null;
      _digitos += d;
    });
    if (_digitos.length == _tamanho) {
      _aoCompletar();
    }
  }

  void _apagar() {
    if (_verificando || _digitos.isEmpty) return;
    setState(() {
      _erro = null;
      _digitos = _digitos.substring(0, _digitos.length - 1);
    });
  }

  Future<void> _aoCompletar() async {
    switch (_fase) {
      case _Fase.criar:
        setState(() {
          _primeiroPin = _digitos;
          _digitos = '';
          _fase = _Fase.confirmar;
        });
        break;
      case _Fase.confirmar:
        if (_digitos == _primeiroPin) {
          await ref.read(pinProvider.notifier).definirPin(_primeiroPin);
          _entrar();
        } else {
          setState(() {
            _erro = 'Os PINs não coincidem. Vamos começar de novo.';
            _digitos = '';
            _primeiroPin = '';
            _fase = _Fase.criar;
          });
        }
        break;
      case _Fase.pedir:
        setState(() => _verificando = true);
        final ok = await ref.read(pinProvider.notifier).verificarPin(_digitos);
        if (!mounted) return;
        if (ok) {
          _entrar();
        } else {
          setState(() {
            _erro = 'PIN incorreto. Tente novamente.';
            _digitos = '';
            _verificando = false;
          });
        }
        break;
      case _Fase.carregando:
        break;
    }
  }

  void _entrar() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PainelHomeScreen()),
    );
  }

  String get _titulo {
    switch (_fase) {
      case _Fase.criar:
        return 'Crie um PIN';
      case _Fase.confirmar:
        return 'Confirme o PIN';
      case _Fase.pedir:
        return 'Digite o PIN';
      case _Fase.carregando:
        return '';
    }
  }

  String get _subtitulo {
    switch (_fase) {
      case _Fase.criar:
        return 'Escolha 4 números que só o responsável vai saber.';
      case _Fase.confirmar:
        return 'Digite os mesmos 4 números outra vez.';
      case _Fase.pedir:
        return 'Área dos responsáveis.';
      case _Fase.carregando:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Painel dos Pais')),
      body: CloudBackground(
        child: SafeArea(
          child: _fase == _Fase.carregando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.fromLTRB(24, kToolbarHeight + 16, 24, 24),
                  child: Limitado(
                    maxWidth: 420,
                    child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text('🔒', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 12),
                      KickerLabel(
                        _fase == _Fase.pedir ? 'Acesso restrito' : 'Configuração',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _titulo,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _subtitulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, color: AppTheme.textoSuave),
                      ),
                      const SizedBox(height: 24),
                      _Pontinhos(preenchidos: _digitos.length, total: _tamanho),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 24,
                        child: _erro == null
                            ? null
                            : Text(
                                _erro!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppTheme.vermelho,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      const Spacer(),
                      _Teclado(
                        onDigito: _digitar,
                        onApagar: _apagar,
                        habilitado: !_verificando,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Pontinhos extends StatelessWidget {
  final int preenchidos;
  final int total;
  const _Pontinhos({required this.preenchidos, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < preenchidos ? AppTheme.indigo : Colors.transparent,
              border: Border.all(color: AppTheme.indigo, width: 2),
            ),
          ),
      ],
    );
  }
}

class _Teclado extends StatelessWidget {
  final void Function(String) onDigito;
  final VoidCallback onApagar;
  final bool habilitado;

  const _Teclado({
    required this.onDigito,
    required this.onApagar,
    required this.habilitado,
  });

  @override
  Widget build(BuildContext context) {
    Widget tecla(String d) => _Tecla(
          rotulo: d,
          onTap: habilitado ? () => onDigito(d) : null,
        );

    return Column(
      children: [
        Row(children: [tecla('1'), tecla('2'), tecla('3')]),
        Row(children: [tecla('4'), tecla('5'), tecla('6')]),
        Row(children: [tecla('7'), tecla('8'), tecla('9')]),
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            tecla('0'),
            _Tecla(
              icone: Icons.backspace_outlined,
              onTap: habilitado ? onApagar : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _Tecla extends StatelessWidget {
  final String? rotulo;
  final IconData? icone;
  final VoidCallback? onTap;

  const _Tecla({this.rotulo, this.icone, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AspectRatio(
          aspectRatio: 1.6,
          child: Material(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Center(
                child: icone != null
                    ? Icon(icone, size: 28, color: AppTheme.texto)
                    : Text(
                        rotulo ?? '',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.texto,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
