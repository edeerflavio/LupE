import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/narrador.dart';
import '../../core/audio/sons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/diacritics.dart';
import '../../core/widgets/responsivo.dart';
import '../../data/seed/palavras_cruzada.dart';
import '../conquistas/celebrar.dart';
import '../forca/widgets/teclado_virtual.dart';
import '../widgets/confete.dart';
import '../widgets/narrar.dart';

/// Cruzadinha: palavras se cruzam na grade; toque numa casa, leia a dica e
/// complete com o teclado. Níveis criança e adulto.
class CruzadaScreen extends ConsumerStatefulWidget {
  const CruzadaScreen({super.key});

  @override
  ConsumerState<CruzadaScreen> createState() => _CruzadaScreenState();
}

enum _Nivel { crianca, adulto }

/// Palavra posicionada na grade gerada.
class _Slot {
  final int numero;
  final String resposta; // normalizada (A-Z)
  final String exibicao; // com acentos, para o fim de jogo
  final String dica;
  final int linha, coluna;
  final bool horizontal;

  const _Slot({
    required this.numero,
    required this.resposta,
    required this.exibicao,
    required this.dica,
    required this.linha,
    required this.coluna,
    required this.horizontal,
  });

  int get tamanho => resposta.length;

  List<Point<int>> get celulas => [
        for (var i = 0; i < tamanho; i++)
          horizontal
              ? Point(linha, coluna + i)
              : Point(linha + i, coluna),
      ];
}

/// Resultado do gerador: grade retangular + slots.
class _Cruzada {
  final int linhas, colunas;
  final List<_Slot> slots;
  const _Cruzada(this.linhas, this.colunas, this.slots);
}

class _CruzadaScreenState extends ConsumerState<CruzadaScreen> {
  final Random _rng = Random();

  _Nivel? _nivel;
  late _Cruzada _cruzada;
  final Map<String, String> _preenchido = {}; // 'r,c' -> letra
  final Set<int> _certas = {}; // números dos slots corretos (travados)
  final Set<int> _erradasAgora = {}; // feedback vermelho temporário
  int? _slotSelecionado;
  bool _venceu = false;

  // ---- Geração da grade ----

  _Cruzada _gerar(List<PalavraCruzada> banco, int alvo) {
    _Cruzada? melhor;
    for (var tentativa = 0; tentativa < 24; tentativa++) {
      final pool = [...banco]..shuffle(_rng);
      final resultado = _tentarGerar(pool.take(alvo + 4).toList(), alvo);
      if (melhor == null || resultado.slots.length > melhor.slots.length) {
        melhor = resultado;
      }
      if (melhor.slots.length >= alvo) break;
    }
    return melhor!;
  }

  _Cruzada _tentarGerar(List<PalavraCruzada> pool, int alvo) {
    final letras = <Point<int>, String>{}; // célula -> letra
    final colocadas = <({String norm, String exib, String dica, int linha, int coluna, bool horizontal})>[];

    bool podeColocar(String palavra, int linha, int coluna, bool horizontal) {
      var cruzou = false;
      for (var i = 0; i < palavra.length; i++) {
        final r = horizontal ? linha : linha + i;
        final c = horizontal ? coluna + i : coluna;
        final atual = letras[Point(r, c)];
        if (atual != null) {
          if (atual != palavra[i]) return false;
          cruzou = true;
          continue;
        }
        // Célula nova: os lados perpendiculares precisam estar livres.
        final lados = horizontal
            ? [Point(r - 1, c), Point(r + 1, c)]
            : [Point(r, c - 1), Point(r, c + 1)];
        if (lados.any(letras.containsKey)) return false;
      }
      // Antes do início e depois do fim, nada encostado.
      final antes = horizontal
          ? Point(linha, coluna - 1)
          : Point(linha - 1, coluna);
      final depois = horizontal
          ? Point(linha, coluna + palavra.length)
          : Point(linha + palavra.length, coluna);
      if (letras.containsKey(antes) || letras.containsKey(depois)) return false;
      return colocadas.isEmpty || cruzou;
    }

    void colocar(PalavraCruzada p, String norm, int linha, int coluna,
        bool horizontal) {
      for (var i = 0; i < norm.length; i++) {
        final r = horizontal ? linha : linha + i;
        final c = horizontal ? coluna + i : coluna;
        letras[Point(r, c)] = norm[i];
      }
      colocadas.add((
        norm: norm,
        exib: p.palavra,
        dica: p.dica,
        linha: linha,
        coluna: coluna,
        horizontal: horizontal,
      ));
    }

    for (final p in pool) {
      if (colocadas.length >= alvo) break;
      final norm =
          normalizar(p.palavra).split('').where(ehLetra).join();
      if (colocadas.isEmpty) {
        colocar(p, norm, 0, 0, true);
        continue;
      }
      var colocada = false;
      // Tenta cruzar em cada letra igual já presente na grade.
      final celulas = letras.entries.toList()..shuffle(_rng);
      for (final entrada in celulas) {
        if (colocada) break;
        for (var i = 0; i < norm.length && !colocada; i++) {
          if (norm[i] != entrada.value) continue;
          final ponto = entrada.key;
          // Cruza na perpendicular das duas orientações possíveis.
          for (final horizontal in [true, false]) {
            final linha = horizontal ? ponto.x : ponto.x - i;
            final coluna = horizontal ? ponto.y - i : ponto.y;
            if (podeColocar(norm, linha, coluna, horizontal)) {
              colocar(p, norm, linha, coluna, horizontal);
              colocada = true;
              break;
            }
          }
        }
      }
    }

    // Normaliza as coordenadas para começarem em (0,0).
    var minR = 0, minC = 0, maxR = 0, maxC = 0;
    for (final p in letras.keys) {
      minR = min(minR, p.x);
      minC = min(minC, p.y);
      maxR = max(maxR, p.x);
      maxC = max(maxC, p.y);
    }
    final slots = <_Slot>[];
    final ordenadas = [...colocadas]
      ..sort((a, b) {
        final ra = a.linha - minR, rb = b.linha - minR;
        if (ra != rb) return ra.compareTo(rb);
        return (a.coluna - minC).compareTo(b.coluna - minC);
      });
    for (var i = 0; i < ordenadas.length; i++) {
      final w = ordenadas[i];
      slots.add(_Slot(
        numero: i + 1,
        resposta: w.norm,
        exibicao: w.exib,
        dica: w.dica,
        linha: w.linha - minR,
        coluna: w.coluna - minC,
        horizontal: w.horizontal,
      ));
    }
    return _Cruzada(maxR - minR + 1, maxC - minC + 1, slots);
  }

  // ---- Estado do jogo ----

  void _iniciar(_Nivel nivel) {
    final banco = nivel == _Nivel.crianca ? cruzadaCrianca : cruzadaAdulto;
    final alvo = nivel == _Nivel.crianca ? 6 : 9;
    setState(() {
      _nivel = nivel;
      _cruzada = _gerar(banco, alvo);
      _preenchido.clear();
      _certas.clear();
      _erradasAgora.clear();
      _venceu = false;
      _slotSelecionado = _cruzada.slots.isEmpty ? null : 0;
    });
  }

  String _chave(int r, int c) => '$r,$c';

  _Slot? get _selecionado =>
      _slotSelecionado == null ? null : _cruzada.slots[_slotSelecionado!];

  /// Primeira célula vazia do slot selecionado (cursor).
  Point<int>? get _cursor {
    final s = _selecionado;
    if (s == null || _certas.contains(s.numero)) return null;
    for (final cel in s.celulas) {
      if ((_preenchido[_chave(cel.x, cel.y)] ?? '').isEmpty) return cel;
    }
    return null;
  }

  void _tocarCelula(int r, int c) {
    // Slots que passam por esta célula.
    final aqui = <int>[];
    for (var i = 0; i < _cruzada.slots.length; i++) {
      if (_cruzada.slots[i].celulas.contains(Point(r, c))) aqui.add(i);
    }
    if (aqui.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (aqui.length > 1 && _slotSelecionado == aqui.first) {
        _slotSelecionado = aqui[1]; // alterna horizontal/vertical
      } else {
        _slotSelecionado = aqui.first;
      }
    });
    final s = _selecionado;
    if (s != null) {
      ref.read(narradorProvider).falar(s.dica);
    }
  }

  void _digitar(String letra) {
    final s = _selecionado;
    final cur = _cursor;
    if (s == null || cur == null) return;
    setState(() {
      _preenchido[_chave(cur.x, cur.y)] = letra;
      _erradasAgora.remove(s.numero);
    });
    _conferirSlot(s);
  }

  void _apagar() {
    final s = _selecionado;
    if (s == null || _certas.contains(s.numero)) return;
    // Apaga a última célula preenchida (não travada) do slot.
    for (final cel in s.celulas.reversed) {
      final k = _chave(cel.x, cel.y);
      if ((_preenchido[k] ?? '').isNotEmpty && !_celulaTravada(cel)) {
        setState(() => _preenchido.remove(k));
        return;
      }
    }
  }

  bool _celulaTravada(Point<int> cel) {
    for (final s in _cruzada.slots) {
      if (_certas.contains(s.numero) && s.celulas.contains(cel)) return true;
    }
    return false;
  }

  /// Ao completar um slot, confere na hora: certo trava, errado avisa.
  void _conferirSlot(_Slot s) {
    final atual = [
      for (final cel in s.celulas) _preenchido[_chave(cel.x, cel.y)] ?? ''
    ].join();
    if (atual.length < s.tamanho) return;
    if (atual == s.resposta) {
      ref.read(sonsProvider).acerto();
      setState(() {
        _certas.add(s.numero);
        _erradasAgora.remove(s.numero);
      });
      _verificarVitoria();
    } else {
      ref.read(sonsProvider).erro();
      HapticFeedback.mediumImpact();
      setState(() => _erradasAgora.add(s.numero));
    }
  }

  void _verificarVitoria() {
    if (_certas.length < _cruzada.slots.length) return;
    setState(() => _venceu = true);
    registrarFimDePartida(
      context,
      ref,
      jogo: 'cruzada',
      acertos: _cruzada.slots.length,
      erros: 0,
      venceu: true,
    );
  }

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Cruzadinha'),
        actions: [
          if (_nivel != null)
            IconButton(
              tooltip: 'Nova cruzadinha',
              onPressed: () => _iniciar(_nivel!),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: CloudBackground(
        child: SafeArea(
          child: _nivel == null ? _escolhaNivel() : _jogo(),
        ),
      ),
    );
  }

  Widget _escolhaNivel() {
    return Center(
      child: Limitado(
        maxWidth: 520,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NarrarAuto(
                  'Cruzadinha! Leia a dica e complete as palavras que se cruzam.'),
              const Text('✏️', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              const Text('Cruzadinha',
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 24),
              GlassCard(
                onTap: () => _iniciar(_Nivel.crianca),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Text('🙂', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nível criança',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('Palavras do dia a dia',
                              style: TextStyle(color: AppTheme.textoSuave)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              GlassCard(
                onTap: () => _iniciar(_Nivel.adulto),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Text('🎓', style: TextStyle(fontSize: 40)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nível adulto',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('Geografia, ciências e cultura',
                              style: TextStyle(color: AppTheme.textoSuave)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jogo() {
    final sel = _selecionado;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, kToolbarHeight + 8, 12, 12),
          child: Limitado(
            maxWidth: 560,
            child: Column(
              children: [
                if (sel != null) _cartaoDica(sel),
                const SizedBox(height: 10),
                _grade(),
                const SizedBox(height: 10),
                _listaNumeros(),
                const SizedBox(height: 10),
                TecladoVirtual(
                  letrasCertas: const {},
                  letrasErradas: const {},
                  habilitado: sel != null &&
                      !_certas.contains(sel.numero) &&
                      !_venceu,
                  onLetra: _digitar,
                ),
                TextButton.icon(
                  onPressed: _apagar,
                  icon: const Icon(Icons.backspace_outlined),
                  label: const Text('Apagar'),
                ),
              ],
            ),
          ),
        ),
        if (_venceu) _overlayVitoria(),
        if (_venceu) const Confete(),
      ],
    );
  }

  Widget _cartaoDica(_Slot s) {
    final resolvida = _certas.contains(s.numero);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: resolvida
            ? AppTheme.verde.withValues(alpha: 0.2)
            : AppTheme.amarelo.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('${s.numero} ${s.horizontal ? '➡️' : '⬇️'}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              s.dica,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          BotaoFalar(s.dica),
        ],
      ),
    );
  }

  Widget _grade() {
    final linhas = _cruzada.linhas, colunas = _cruzada.colunas;
    // Mapa célula -> letra correta (para saber quais existem).
    final ativas = <String>{};
    for (final s in _cruzada.slots) {
      for (final cel in s.celulas) {
        ativas.add(_chave(cel.x, cel.y));
      }
    }
    final numeros = <String, int>{};
    for (final s in _cruzada.slots) {
      numeros.putIfAbsent(_chave(s.linha, s.coluna), () => s.numero);
    }
    final celulasSel = _selecionado?.celulas
            .map((c) => _chave(c.x, c.y))
            .toSet() ??
        const <String>{};
    final cursor = _cursor;

    return LayoutBuilder(builder: (context, constraints) {
      final tam =
          min(constraints.maxWidth / colunas, 44.0);
      return Center(
        child: SizedBox(
          width: tam * colunas,
          height: tam * linhas,
          child: Stack(
            children: [
              for (var r = 0; r < linhas; r++)
                for (var c = 0; c < colunas; c++)
                  if (ativas.contains(_chave(r, c)))
                    Positioned(
                      left: c * tam,
                      top: r * tam,
                      width: tam,
                      height: tam,
                      child: _celula(
                        r,
                        c,
                        tam,
                        numero: numeros[_chave(r, c)],
                        selecionada: celulasSel.contains(_chave(r, c)),
                        cursor: cursor != null &&
                            cursor.x == r &&
                            cursor.y == c,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  Widget _celula(int r, int c, double tam,
      {int? numero, required bool selecionada, required bool cursor}) {
    final letra = _preenchido[_chave(r, c)] ?? '';
    final travada = _celulaTravada(Point(r, c));
    final errada = _erradasAgora.any((n) =>
        _cruzada.slots[n - 1].celulas.contains(Point(r, c)) &&
        !_celulaTravada(Point(r, c)));

    Color fundo = Colors.white;
    if (travada) {
      fundo = AppTheme.verde.withValues(alpha: 0.35);
    } else if (errada) {
      fundo = AppTheme.vermelho.withValues(alpha: 0.3);
    } else if (cursor) {
      fundo = AppTheme.amarelo.withValues(alpha: 0.55);
    } else if (selecionada) {
      fundo = AppTheme.azul.withValues(alpha: 0.18);
    }

    return GestureDetector(
      onTap: () => _tocarCelula(r, c),
      child: Container(
        decoration: BoxDecoration(
          color: fundo,
          border: Border.all(color: const Color(0xFF9AA0B5), width: 0.7),
        ),
        child: Stack(
          children: [
            if (numero != null)
              Positioned(
                left: 2,
                top: 1,
                child: Text('$numero',
                    style: TextStyle(
                        fontSize: max(8, tam * 0.22),
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textoSuave)),
              ),
            Center(
              child: Text(
                letra,
                style: TextStyle(
                  fontSize: tam * 0.52,
                  fontWeight: FontWeight.w900,
                  color: travada ? const Color(0xFF0B6E4F) : AppTheme.texto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaNumeros() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < _cruzada.slots.length; i++)
          GestureDetector(
            onTap: () => setState(() => _slotSelecionado = i),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _certas.contains(_cruzada.slots[i].numero)
                    ? AppTheme.verde
                    : (_slotSelecionado == i
                        ? AppTheme.indigo
                        : Colors.white.withValues(alpha: 0.8)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_cruzada.slots[i].numero}'
                '${_cruzada.slots[i].horizontal ? '➡️' : '⬇️'}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _certas.contains(_cruzada.slots[i].numero) ||
                          _slotSelecionado == i
                      ? Colors.white
                      : AppTheme.texto,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _overlayVitoria() {
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
              const Text('🎉', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 8),
              const Text('Cruzadinha completa!',
                  style:
                      TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _iniciar(_nivel!),
                icon: const Icon(Icons.refresh),
                label: const Text('Outra cruzadinha'),
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
