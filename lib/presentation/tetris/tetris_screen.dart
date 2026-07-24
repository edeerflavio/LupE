import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../conquistas/celebrar.dart';
import '../widgets/narrar.dart';

/// Tetris clássico: peças caem, linhas completas somem. Controles por toque
/// (botões) e teclado (setas) — funciona no celular e na web.
class TetrisScreen extends ConsumerStatefulWidget {
  const TetrisScreen({super.key});

  @override
  ConsumerState<TetrisScreen> createState() => _TetrisScreenState();
}

/// Uma peça: rotações como listas de células (linha, coluna).
class _Peca {
  final List<List<Point<int>>> rotacoes;
  final Color cor;
  const _Peca(this.rotacoes, this.cor);
}

class _TetrisScreenState extends ConsumerState<TetrisScreen> {
  static const int _cols = 10;
  static const int _rows = 18;

  static final Map<String, _Peca> _pecas = {
    'I': _Peca([
      [Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3)],
      [Point(0, 1), Point(1, 1), Point(2, 1), Point(3, 1)],
    ], const Color(0xFF00BCD4)),
    'O': _Peca([
      [Point(0, 0), Point(0, 1), Point(1, 0), Point(1, 1)],
    ], const Color(0xFFFFC531)),
    'T': _Peca([
      [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 1)],
      [Point(0, 1), Point(1, 0), Point(1, 1), Point(2, 1)],
      [Point(1, 0), Point(1, 1), Point(1, 2), Point(0, 1)],
      [Point(0, 0), Point(1, 0), Point(2, 0), Point(1, 1)],
    ], const Color(0xFF6C5CE7)),
    'S': _Peca([
      [Point(0, 1), Point(0, 2), Point(1, 0), Point(1, 1)],
      [Point(0, 0), Point(1, 0), Point(1, 1), Point(2, 1)],
    ], const Color(0xFF00B894)),
    'Z': _Peca([
      [Point(0, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
      [Point(0, 1), Point(1, 0), Point(1, 1), Point(2, 0)],
    ], const Color(0xFFE84393)),
    'J': _Peca([
      [Point(0, 0), Point(1, 0), Point(1, 1), Point(1, 2)],
      [Point(0, 0), Point(0, 1), Point(1, 0), Point(2, 0)],
      [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 2)],
      [Point(0, 1), Point(1, 1), Point(2, 0), Point(2, 1)],
    ], const Color(0xFF0984E3)),
    'L': _Peca([
      [Point(0, 2), Point(1, 0), Point(1, 1), Point(1, 2)],
      [Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1)],
      [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 0)],
      [Point(0, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
    ], const Color(0xFFFF7043)),
  };

  final Random _rng = Random();
  final FocusNode _foco = FocusNode();

  late List<List<Color?>> _grade;
  String _tipo = 'T';
  String _proximoTipo = 'I';
  int _rot = 0, _linha = 0, _coluna = 3;
  int _pontos = 0, _linhas = 0, _nivel = 1;
  bool _rodando = false, _pausado = false, _fim = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _grade = List.generate(_rows, (_) => List.filled(_cols, null));
    _proximoTipo = _sortearTipo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _foco.dispose();
    super.dispose();
  }

  String _sortearTipo() =>
      _pecas.keys.elementAt(_rng.nextInt(_pecas.length));

  List<Point<int>> get _celulas {
    final p = _pecas[_tipo]!;
    final forma = p.rotacoes[_rot % p.rotacoes.length];
    return [for (final c in forma) Point(c.x + _linha, c.y + _coluna)];
  }

  bool _cabe(String tipo, int rot, int linha, int coluna) {
    final p = _pecas[tipo]!;
    final forma = p.rotacoes[rot % p.rotacoes.length];
    for (final c in forma) {
      final r = c.x + linha, q = c.y + coluna;
      if (q < 0 || q >= _cols || r >= _rows) return false;
      if (r >= 0 && _grade[r][q] != null) return false;
    }
    return true;
  }

  // ---- Fluxo do jogo ----

  void _comecar() {
    setState(() {
      _grade = List.generate(_rows, (_) => List.filled(_cols, null));
      _pontos = 0;
      _linhas = 0;
      _nivel = 1;
      _fim = false;
      _pausado = false;
      _rodando = true;
    });
    _novaPeca();
    _agendar();
    _foco.requestFocus();
  }

  void _agendar() {
    _timer?.cancel();
    final ms = max(120, 620 - (_nivel - 1) * 60);
    _timer = Timer.periodic(Duration(milliseconds: ms), (_) => _tick());
  }

  void _tick() {
    if (!_rodando || _pausado || _fim) return;
    if (_cabe(_tipo, _rot, _linha + 1, _coluna)) {
      setState(() => _linha++);
    } else {
      _fixar();
    }
  }

  void _novaPeca() {
    _tipo = _proximoTipo;
    _proximoTipo = _sortearTipo();
    _rot = 0;
    _linha = -1;
    _coluna = (_cols ~/ 2) - 2;
    if (!_cabe(_tipo, _rot, _linha + 1, _coluna)) {
      _encerrar();
    }
  }

  void _fixar() {
    for (final c in _celulas) {
      if (c.x < 0) {
        _encerrar();
        return;
      }
      _grade[c.x][c.y] = _pecas[_tipo]!.cor;
    }
    _limparLinhas();
    setState(_novaPeca);
  }

  void _limparLinhas() {
    final completas = <int>[];
    for (var r = 0; r < _rows; r++) {
      if (_grade[r].every((c) => c != null)) completas.add(r);
    }
    if (completas.isEmpty) return;
    ref.read(sonsProvider).acerto();
    HapticFeedback.mediumImpact();
    for (final r in completas) {
      _grade.removeAt(r);
      _grade.insert(0, List.filled(_cols, null));
    }
    const tabela = {1: 100, 2: 300, 3: 500, 4: 800};
    setState(() {
      _pontos += (tabela[completas.length] ?? 100) * _nivel;
      _linhas += completas.length;
      final novoNivel = (_linhas ~/ 10) + 1;
      if (novoNivel != _nivel) {
        _nivel = novoNivel;
        _agendar();
      }
    });
  }

  void _encerrar() {
    _timer?.cancel();
    setState(() {
      _fim = true;
      _rodando = false;
    });
    registrarFimDePartida(
      context,
      ref,
      jogo: 'tetris',
      acertos: _linhas,
      erros: 0,
      venceu: _linhas > 0,
    );
  }

  // ---- Controles ----

  void _mover(int delta) {
    if (!_jogavel) return;
    if (_cabe(_tipo, _rot, _linha, _coluna + delta)) {
      setState(() => _coluna += delta);
    }
  }

  void _girar() {
    if (!_jogavel) return;
    final novaRot = _rot + 1;
    // "Wall kick" simples: tenta no lugar, depois 1 casa para cada lado.
    for (final ajuste in const [0, -1, 1, -2, 2]) {
      if (_cabe(_tipo, novaRot, _linha, _coluna + ajuste)) {
        setState(() {
          _rot = novaRot;
          _coluna += ajuste;
        });
        return;
      }
    }
  }

  void _descer() {
    if (!_jogavel) return;
    if (_cabe(_tipo, _rot, _linha + 1, _coluna)) {
      setState(() {
        _linha++;
        _pontos += 1;
      });
    } else {
      _fixar();
    }
  }

  void _soltar() {
    if (!_jogavel) return;
    var l = _linha;
    while (_cabe(_tipo, _rot, l + 1, _coluna)) {
      l++;
    }
    setState(() {
      _pontos += (l - _linha) * 2;
      _linha = l;
    });
    _fixar();
  }

  bool get _jogavel => _rodando && !_pausado && !_fim;

  KeyEventResult _tecla(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _mover(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _mover(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _girar();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _descer();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        _soltar();
        return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Tetris'),
        actions: [
          if (_rodando)
            IconButton(
              tooltip: _pausado ? 'Continuar' : 'Pausar',
              onPressed: () => setState(() => _pausado = !_pausado),
              icon: Icon(_pausado ? Icons.play_arrow : Icons.pause),
            ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
          child: Focus(
            focusNode: _foco,
            onKeyEvent: _tecla,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 8),
                  child: Limitado(
                    maxWidth: 560,
                    child: Column(
                      children: [
                        _painelInfo(),
                        const SizedBox(height: 8),
                        Expanded(child: Center(child: _tabuleiro())),
                        const SizedBox(height: 8),
                        _controles(),
                      ],
                    ),
                  ),
                ),
                if (!_rodando && !_fim) _overlayInicio(),
                if (_fim) _overlayFim(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _painelInfo() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _info('⭐', '$_pontos'),
          _info('📏', '$_linhas linhas'),
          _info('🚀', 'Nível $_nivel'),
          Row(
            children: [
              const Text('Próxima:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              _miniPeca(_proximoTipo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String emoji, String texto) {
    return Text('$emoji $texto',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800));
  }

  Widget _miniPeca(String tipo) {
    final p = _pecas[tipo]!;
    final forma = p.rotacoes.first;
    final maxR = forma.map((c) => c.x).reduce(max) + 1;
    final maxC = forma.map((c) => c.y).reduce(max) + 1;
    return SizedBox(
      width: maxC * 10.0,
      height: maxR * 10.0,
      child: CustomPaint(
        painter: _MiniPecaPainter(forma: forma, cor: p.cor),
      ),
    );
  }

  Widget _tabuleiro() {
    return AspectRatio(
      aspectRatio: _cols / _rows,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1D2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CustomPaint(
            painter: _TabuleiroPainter(
              grade: _grade,
              celulasPeca: _rodando && !_fim ? _celulas : const [],
              corPeca: _pecas[_tipo]!.cor,
              cols: _cols,
              rows: _rows,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _controles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _botao(Icons.chevron_left, () => _mover(-1)),
        _botao(Icons.rotate_right, _girar),
        _botao(Icons.keyboard_double_arrow_down, _soltar,
            cor: AppTheme.vermelho),
        _botao(Icons.arrow_downward, _descer),
        _botao(Icons.chevron_right, () => _mover(1)),
      ],
    );
  }

  Widget _botao(IconData icone, VoidCallback acao, {Color? cor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: cor ?? AppTheme.indigo,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.selectionClick();
            acao();
          },
          child: SizedBox(
            width: 58,
            height: 52,
            child: Icon(icone, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _overlayInicio() {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NarrarAuto(
                  'Tetris! Encaixe as peças e complete linhas para marcar pontos.'),
              const Text('🧱', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              const Text('Tetris',
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text(
                'Encaixe as peças que caem e\ncomplete linhas para pontuar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.textoSuave),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _comecar,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Jogar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verde,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overlayFim() {
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
              const Text('🧱', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              const Text('Fim de jogo!',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('⭐ $_pontos pontos · 📏 $_linhas linhas',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _comecar,
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

class _TabuleiroPainter extends CustomPainter {
  final List<List<Color?>> grade;
  final List<Point<int>> celulasPeca;
  final Color corPeca;
  final int cols, rows;

  _TabuleiroPainter({
    required this.grade,
    required this.celulasPeca,
    required this.corPeca,
    required this.cols,
    required this.rows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cw = size.width / cols;
    final ch = size.height / rows;
    final paint = Paint();

    // Grade de fundo
    paint.color = Colors.white10;
    for (var c = 1; c < cols; c++) {
      canvas.drawLine(Offset(c * cw, 0), Offset(c * cw, size.height), paint);
    }
    for (var r = 1; r < rows; r++) {
      canvas.drawLine(Offset(0, r * ch), Offset(size.width, r * ch), paint);
    }

    void bloco(int r, int c, Color cor) {
      if (r < 0) return;
      final rect = Rect.fromLTWH(c * cw + 1, r * ch + 1, cw - 2, ch - 2);
      paint.color = cor;
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)), paint);
      paint.color = Colors.white.withValues(alpha: 0.25);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * 0.3),
            const Radius.circular(3)),
        paint,
      );
    }

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final cor = grade[r][c];
        if (cor != null) bloco(r, c, cor);
      }
    }
    for (final p in celulasPeca) {
      bloco(p.x, p.y, corPeca);
    }
  }

  @override
  bool shouldRepaint(covariant _TabuleiroPainter old) => true;
}

class _MiniPecaPainter extends CustomPainter {
  final List<Point<int>> forma;
  final Color cor;
  _MiniPecaPainter({required this.forma, required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = cor;
    for (final c in forma) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(c.y * 10.0 + 1, c.x * 10.0 + 1, 8, 8),
            const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniPecaPainter old) =>
      old.forma != forma || old.cor != cor;
}
