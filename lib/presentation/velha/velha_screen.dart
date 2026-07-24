import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../conquistas/celebrar.dart';
import '../widgets/confete.dart';
import '../widgets/narrar.dart';

/// Jogo da Velha: contra o app (fácil/difícil) ou entre duas pessoas.
class VelhaScreen extends ConsumerStatefulWidget {
  const VelhaScreen({super.key});

  @override
  ConsumerState<VelhaScreen> createState() => _VelhaScreenState();
}

enum _Modo { computadorFacil, computadorDificil, duasPessoas }

class _VelhaScreenState extends ConsumerState<VelhaScreen> {
  static const _linhasVitoria = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // linhas
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // colunas
    [0, 4, 8], [2, 4, 6], // diagonais
  ];

  final Random _rng = Random();
  _Modo _modo = _Modo.computadorFacil;

  /// 9 casas: '', 'X' ou 'O'. X sempre começa e é o jogador 1.
  List<String> _casas = List.filled(9, '');
  bool _vezDoX = true;
  bool _terminou = false;
  String? _vencedor; // 'X' | 'O' | null (velha)
  List<int> _linhaVencedora = const [];
  int _vitoriasX = 0, _vitoriasO = 0, _velhas = 0;
  bool _pensando = false; // vez do computador (trava toques)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Jogo da Velha')),
      body: CloudBackground(
        child: SafeArea(
          child: Stack(
            children: [
              const NarrarAuto(
                  'Jogo da velha! Consiga três símbolos em linha para vencer.'),
              SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(16, kToolbarHeight + 12, 16, 16),
                child: Limitado(
                  maxWidth: 460,
                  child: Column(
                    children: [
                      _seletorModo(),
                      const SizedBox(height: 12),
                      _placar(),
                      const SizedBox(height: 12),
                      _statusVez(),
                      const SizedBox(height: 12),
                      _tabuleiro(),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _reiniciar,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Recomeçar'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_terminou) _overlayFim(),
              if (_terminou && _vencedorHumano) const Confete(),
            ],
          ),
        ),
      ),
    );
  }

  bool get _contraComputador => _modo != _Modo.duasPessoas;

  /// Se quem venceu foi uma pessoa (para o confete): no modo 2 pessoas
  /// qualquer vitória celebra; contra o app, só a vitória do X.
  bool get _vencedorHumano =>
      _vencedor != null && (!_contraComputador || _vencedor == 'X');

  Widget _seletorModo() {
    return GlassCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _botaoModo(_Modo.computadorFacil, '🤖', 'App fácil'),
          _botaoModo(_Modo.computadorDificil, '🧠', 'App difícil'),
          _botaoModo(_Modo.duasPessoas, '👧🧒', '2 pessoas'),
        ],
      ),
    );
  }

  Widget _botaoModo(_Modo m, String emoji, String rotulo) {
    final ativo = _modo == m;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _modo = m);
          _reiniciar();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: ativo ? AppTheme.indigo : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 2),
              Text(
                rotulo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: ativo ? Colors.white : AppTheme.texto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chipPlacar('❌', _vitoriasX, AppTheme.azul),
        const SizedBox(width: 10),
        _chipPlacar('🤝', _velhas, AppTheme.textoSuave),
        const SizedBox(width: 10),
        _chipPlacar('⭕', _vitoriasO, AppTheme.vermelho),
      ],
    );
  }

  Widget _chipPlacar(String emoji, int valor, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text('$emoji $valor',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: cor)),
    );
  }

  Widget _statusVez() {
    final texto = _terminou
        ? ''
        : _vezDoX
            ? (_contraComputador ? 'Sua vez! Você é o ❌' : 'Vez do ❌')
            : (_contraComputador ? 'O app está pensando… 🤖' : 'Vez do ⭕');
    return Text(texto,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800));
  }

  Widget _tabuleiro() {
    return AspectRatio(
      aspectRatio: 1,
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, i) {
            final valor = _casas[i];
            final naLinha = _linhaVencedora.contains(i);
            return Material(
              color: naLinha
                  ? AppTheme.verde.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: valor.isEmpty && !_terminou && !_pensando
                    ? () => _jogar(i)
                    : null,
                child: Center(
                  child: Text(
                    valor == 'X' ? '❌' : (valor == 'O' ? '⭕' : ''),
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _overlayFim() {
    final String emoji;
    final String frase;
    if (_vencedor == null) {
      emoji = '🤝';
      frase = 'Deu velha!';
    } else if (_contraComputador) {
      emoji = _vencedor == 'X' ? '🏆' : '🤖';
      frase = _vencedor == 'X' ? 'Você venceu!' : 'O app venceu!';
    } else {
      emoji = '🏆';
      frase = _vencedor == 'X' ? 'O ❌ venceu!' : 'O ⭕ venceu!';
    }
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
              Text(emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 8),
              Text(frase,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _proximaRodada,
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

  // ---- Lógica ----

  void _jogar(int i) {
    if (_casas[i].isNotEmpty || _terminou) return;
    HapticFeedback.lightImpact();
    ref.read(sonsProvider).tocar(Efeito.toque);
    setState(() {
      _casas[i] = _vezDoX ? 'X' : 'O';
      _vezDoX = !_vezDoX;
    });
    _verificarFim();
    if (!_terminou && _contraComputador && !_vezDoX) {
      _jogadaDoComputador();
    }
  }

  Future<void> _jogadaDoComputador() async {
    setState(() => _pensando = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted || _terminou) return;
    final i = _modo == _Modo.computadorDificil
        ? _melhorJogada('O')
        : _jogadaAleatoria();
    setState(() {
      _casas[i] = 'O';
      _vezDoX = true;
      _pensando = false;
    });
    _verificarFim();
  }

  int _jogadaAleatoria() {
    final livres = [
      for (var i = 0; i < 9; i++)
        if (_casas[i].isEmpty) i
    ];
    return livres[_rng.nextInt(livres.length)];
  }

  /// Heurística clássica: vencer > bloquear > centro > canto > lateral.
  int _melhorJogada(String eu) {
    final rival = eu == 'O' ? 'X' : 'O';
    final ganha = _casaQueFecha(eu);
    if (ganha != null) return ganha;
    final bloqueia = _casaQueFecha(rival);
    if (bloqueia != null) return bloqueia;
    if (_casas[4].isEmpty) return 4;
    final cantos = [0, 2, 6, 8].where((i) => _casas[i].isEmpty).toList();
    if (cantos.isNotEmpty) return cantos[_rng.nextInt(cantos.length)];
    return _jogadaAleatoria();
  }

  /// Casa vazia que completa três em linha para [jogador], ou null.
  int? _casaQueFecha(String jogador) {
    for (final linha in _linhasVitoria) {
      final valores = linha.map((i) => _casas[i]).toList();
      if (valores.where((v) => v == jogador).length == 2 &&
          valores.contains('')) {
        return linha[valores.indexOf('')];
      }
    }
    return null;
  }

  void _verificarFim() {
    for (final linha in _linhasVitoria) {
      final a = _casas[linha[0]];
      if (a.isNotEmpty && a == _casas[linha[1]] && a == _casas[linha[2]]) {
        setState(() {
          _terminou = true;
          _vencedor = a;
          _linhaVencedora = linha;
          if (a == 'X') {
            _vitoriasX++;
          } else {
            _vitoriasO++;
          }
        });
        _registrar(venceuHumano: _vencedorHumano, empate: false);
        return;
      }
    }
    if (!_casas.contains('')) {
      setState(() {
        _terminou = true;
        _vencedor = null;
        _velhas++;
      });
      _registrar(venceuHumano: false, empate: true);
    }
  }

  void _registrar({required bool venceuHumano, required bool empate}) {
    if (venceuHumano) {
      // Som + progresso + conquistas via fluxo padrão dos jogos.
      registrarFimDePartida(
        context,
        ref,
        jogo: 'velha',
        acertos: 1,
        erros: 0,
        venceu: true,
      );
    } else {
      if (!empate) ref.read(sonsProvider).erro();
      registrarFimDePartida(
        context,
        ref,
        jogo: 'velha',
        acertos: 0,
        erros: empate ? 0 : 1,
        venceu: false,
      );
    }
  }

  void _proximaRodada() {
    setState(() {
      _casas = List.filled(9, '');
      _vezDoX = true;
      _terminou = false;
      _vencedor = null;
      _linhaVencedora = const [];
      _pensando = false;
    });
  }

  void _reiniciar() {
    _proximaRodada();
    setState(() {
      _vitoriasX = 0;
      _vitoriasO = 0;
      _velhas = 0;
    });
  }
}
