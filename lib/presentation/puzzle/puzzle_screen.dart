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

/// Quebra-cabeça deslizante: a foto é fatiada em peças e uma casa fica vazia.
/// Toque numa peça vizinha ao buraco para deslizá-la.
class PuzzleScreen extends ConsumerStatefulWidget {
  const PuzzleScreen({super.key});

  @override
  ConsumerState<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _ImagemPuzzle {
  final String nome;
  final String asset;
  const _ImagemPuzzle(this.nome, this.asset);
}

const List<_ImagemPuzzle> _imagens = [
  _ImagemPuzzle('Leão', 'assets/animals/leao.jpg'),
  _ImagemPuzzle('Panda', 'assets/animals/panda.jpg'),
  _ImagemPuzzle('Gato', 'assets/animals/gato.jpg'),
  _ImagemPuzzle('Cachorro', 'assets/animals/cachorro.jpg'),
  _ImagemPuzzle('Girafa', 'assets/animals/girafa.jpg'),
  _ImagemPuzzle('Tigre', 'assets/animals/tigre.jpg'),
  _ImagemPuzzle('Coruja', 'assets/animals/coruja.jpg'),
  _ImagemPuzzle('Pinguim', 'assets/animals/pinguim.jpg'),
  _ImagemPuzzle('Raposa', 'assets/animals/raposa.jpg'),
  _ImagemPuzzle('Golfinho', 'assets/animals/golfinho.jpg'),
  _ImagemPuzzle('Borboleta', 'assets/animals/borboleta.jpg'),
  _ImagemPuzzle('Papagaio', 'assets/animals/papagaio.jpg'),
];

class _PuzzleScreenState extends ConsumerState<PuzzleScreen> {
  final Random _rng = Random();

  _ImagemPuzzle? _imagem;
  int _n = 3; // 3x3 ou 4x4
  late List<int> _pecas; // posição -> índice da peça (n*n-1 = buraco)
  int _movimentos = 0;
  bool _venceu = false;

  int get _buraco => _n * _n - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Quebra-cabeça'),
        actions: [
          if (_imagem != null)
            IconButton(
              tooltip: 'Trocar imagem',
              onPressed: () => setState(() {
                _imagem = null;
                _venceu = false;
              }),
              icon: const Icon(Icons.photo_library_outlined),
            ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
          child: _imagem == null ? _escolha() : _jogo(),
        ),
      ),
    );
  }

  // ---- Tela de escolha ----

  Widget _escolha() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 12, 20, 20),
      child: Limitado(
        maxWidth: 640,
        child: Column(
          children: [
            const NarrarAuto(
                'Quebra-cabeça! Escolha uma foto e deslize as peças até montar a imagem.'),
            const KickerLabel('Deslize as peças'),
            const SizedBox(height: 6),
            const Text('Escolha uma foto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  _botaoTamanho(3, '🙂 Fácil (3×3)'),
                  _botaoTamanho(4, '🤓 Difícil (4×4)'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: gradeAdaptativa(extentMax: 150, aspecto: 1.0),
              children: [
                for (final img in _imagens)
                  GestureDetector(
                    onTap: () => _iniciar(img),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(img.asset,
                                fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(img.nome,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoTamanho(int n, String rotulo) {
    final ativo = _n == n;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _n = n),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: ativo ? AppTheme.indigo : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            rotulo,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: ativo ? Colors.white : AppTheme.texto,
            ),
          ),
        ),
      ),
    );
  }

  // ---- Jogo ----

  void _iniciar(_ImagemPuzzle img) {
    _imagem = img;
    _movimentos = 0;
    _venceu = false;
    // Embaralha a partir do estado resolvido com jogadas válidas — assim o
    // quebra-cabeça sempre tem solução.
    _pecas = List.generate(_n * _n, (i) => i);
    var posBuraco = _pecas.indexOf(_buraco);
    int? ultima;
    final passos = _n == 3 ? 80 : 160;
    for (var i = 0; i < passos; i++) {
      final vizinhos = _vizinhas(posBuraco)
          .where((v) => v != ultima)
          .toList();
      final escolhida = vizinhos[_rng.nextInt(vizinhos.length)];
      _pecas[posBuraco] = _pecas[escolhida];
      _pecas[escolhida] = _buraco;
      ultima = posBuraco;
      posBuraco = escolhida;
    }
    setState(() {});
  }

  List<int> _vizinhas(int pos) {
    final r = pos ~/ _n, c = pos % _n;
    return [
      if (r > 0) pos - _n,
      if (r < _n - 1) pos + _n,
      if (c > 0) pos - 1,
      if (c < _n - 1) pos + 1,
    ];
  }

  void _tocar(int pos) {
    if (_venceu) return;
    final posBuraco = _pecas.indexOf(_buraco);
    if (!_vizinhas(posBuraco).contains(pos)) return;
    HapticFeedback.selectionClick();
    ref.read(sonsProvider).tocar(Efeito.toque);
    setState(() {
      _pecas[posBuraco] = _pecas[pos];
      _pecas[pos] = _buraco;
      _movimentos++;
    });
    _verificar();
  }

  void _verificar() {
    for (var i = 0; i < _pecas.length; i++) {
      if (_pecas[i] != i) return;
    }
    setState(() => _venceu = true);
    registrarFimDePartida(
      context,
      ref,
      jogo: 'puzzle',
      acertos: 1,
      erros: 0,
      venceu: true,
    );
  }

  Widget _jogo() {
    final img = _imagem!;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 16),
          child: Limitado(
            maxWidth: 480,
            child: Column(
              children: [
                GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🧩 ${img.nome}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('👣 $_movimentos movimentos',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: AppTheme.sombraVidro,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: _grade(img),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Miniatura de referência
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Modelo: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(img.asset,
                          width: 72, height: 72, fit: BoxFit.cover),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _iniciar(img),
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Embaralhar de novo'),
                ),
              ],
            ),
          ),
        ),
        if (_venceu) _overlayVitoria(img),
        if (_venceu) const Confete(),
      ],
    );
  }

  Widget _grade(_ImagemPuzzle img) {
    return LayoutBuilder(builder: (context, constraints) {
      final lado = constraints.maxWidth;
      final tam = lado / _n;
      return Stack(
        children: [
          Container(color: const Color(0xFF1B1D2A)),
          for (var pos = 0; pos < _pecas.length; pos++)
            if (_pecas[pos] != _buraco || _venceu)
              AnimatedPositioned(
                key: ValueKey('peca_${_pecas[pos]}'),
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOut,
                left: (pos % _n) * tam,
                top: (pos ~/ _n) * tam,
                width: tam,
                height: tam,
                child: GestureDetector(
                  onTap: () => _tocar(pos),
                  child: _pedaco(img, _pecas[pos], tam),
                ),
              ),
        ],
      );
    });
  }

  /// Recorta o pedaço [indice] da imagem, na peça de lado [tam].
  Widget _pedaco(_ImagemPuzzle img, int indice, double tam) {
    final r = indice ~/ _n, c = indice % _n;
    return Container(
      decoration: BoxDecoration(
        border: _venceu ? null : Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRect(
        child: OverflowBox(
          maxWidth: tam * _n,
          maxHeight: tam * _n,
          alignment: Alignment(
            _n == 1 ? 0 : -1 + 2 * c / (_n - 1),
            _n == 1 ? 0 : -1 + 2 * r / (_n - 1),
          ),
          child: SizedBox(
            width: tam * _n,
            height: tam * _n,
            child: Image.asset(img.asset, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _overlayVitoria(_ImagemPuzzle img) {
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
              const Text('🧩', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              const Text('Montou!',
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text('${img.nome} em $_movimentos movimentos',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _imagem = null;
                  _venceu = false;
                }),
                icon: const Icon(Icons.photo_library),
                label: const Text('Outra imagem'),
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
