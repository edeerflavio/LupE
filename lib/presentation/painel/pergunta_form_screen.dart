import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../application/pergunta_controller.dart';
import '../../core/constants/materias.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';
import '../../domain/models/pergunta.dart';

/// RF05.2 — Cadastro/edição manual de uma pergunta.
///
/// [pergunta] nulo = nova pergunta (origem manual). Não-nulo = edição, que
/// preserva id/origem/data e usa `editar(...)`.
class PerguntaFormScreen extends ConsumerStatefulWidget {
  final Pergunta? pergunta;
  const PerguntaFormScreen({super.key, this.pergunta});

  @override
  ConsumerState<PerguntaFormScreen> createState() => _PerguntaFormScreenState();
}

const _dificuldades = <String, String>{
  'facil': 'Fácil',
  'medio': 'Médio',
  'dificil': 'Difícil',
};

class _PerguntaFormScreenState extends ConsumerState<PerguntaFormScreen> {
  late final TextEditingController _enunciadoCtrl;
  late final TextEditingController _explicacaoCtrl;
  late final List<TextEditingController> _altCtrls;

  late String _materia;
  late String _dificuldade;
  int _indiceCorreta = 0;
  bool _salvarAprovada = true;
  bool _salvando = false;

  bool get _editando => widget.pergunta != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pergunta;
    _enunciadoCtrl = TextEditingController(text: p?.enunciado ?? '');
    _explicacaoCtrl = TextEditingController(text: p?.explicacao ?? '');
    final alts = p?.alternativas ?? const ['', '', '', ''];
    _altCtrls = List.generate(
      4,
      (i) => TextEditingController(text: i < alts.length ? alts[i] : ''),
    );
    _materia = p?.materia ?? Materias.chaves.first;
    _dificuldade = p?.dificuldade ?? 'medio';
    _indiceCorreta = p?.indiceCorreta ?? 0;
    // Ao editar, mantém o status atual como padrão do seletor.
    _salvarAprovada = p == null ? true : p.status == StatusPergunta.aprovada;
  }

  @override
  void dispose() {
    _enunciadoCtrl.dispose();
    _explicacaoCtrl.dispose();
    for (final c in _altCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  String? get _erroValidacao {
    if (_enunciadoCtrl.text.trim().isEmpty) return 'Escreva o enunciado.';
    for (var i = 0; i < 4; i++) {
      if (_altCtrls[i].text.trim().isEmpty) {
        return 'Preencha as 4 alternativas.';
      }
    }
    if (_explicacaoCtrl.text.trim().isEmpty) {
      return 'Escreva a explicação (aparece após responder).';
    }
    return null;
  }

  Future<void> _salvar() async {
    final erro = _erroValidacao;
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    setState(() => _salvando = true);

    final alternativas = [for (final c in _altCtrls) c.text.trim()];
    final status =
        _salvarAprovada ? StatusPergunta.aprovada : StatusPergunta.pendente;
    final notifier = ref.read(perguntasProvider.notifier);

    if (_editando) {
      final atual = widget.pergunta!;
      await notifier.editar(
        atual.copyWith(
          materia: _materia,
          dificuldade: _dificuldade,
          enunciado: _enunciadoCtrl.text.trim(),
          alternativas: alternativas,
          indiceCorreta: _indiceCorreta,
          explicacao: _explicacaoCtrl.text.trim(),
          status: status,
        ),
      );
    } else {
      await notifier.adicionar(
        Pergunta(
          id: const Uuid().v4(),
          materia: _materia,
          dificuldade: _dificuldade,
          enunciado: _enunciadoCtrl.text.trim(),
          alternativas: alternativas,
          indiceCorreta: _indiceCorreta,
          explicacao: _explicacaoCtrl.text.trim(),
          origem: OrigemPergunta.manual,
          status: status,
          criadaEm: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_editando ? 'Editar pergunta' : 'Nova pergunta'),
      ),
      body: CloudBackground(
        child: SafeArea(
          child: Limitado(
            maxWidth: 640,
            child: ListView(
            padding:
                const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 32),
            children: [
              _Secao('Matéria'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chave in Materias.chaves)
                    _Chip(
                      rotulo: '${Materias.emoji(chave)} ${Materias.rotulo(chave)}',
                      selecionado: chave == _materia,
                      onTap: () => setState(() => _materia = chave),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _Secao('Enunciado'),
              const SizedBox(height: 8),
              _Campo(
                controller: _enunciadoCtrl,
                hint: 'Ex.: Qual é a capital do Brasil?',
                maxLines: 3,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 20),
              _Secao('Alternativas (toque para marcar a correta)'),
              const SizedBox(height: 8),
              for (var i = 0; i < 4; i++) ...[
                _AlternativaLinha(
                  letra: String.fromCharCode(65 + i),
                  controller: _altCtrls[i],
                  correta: _indiceCorreta == i,
                  onMarcarCorreta: () => setState(() => _indiceCorreta = i),
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              _Secao('Dificuldade'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final entrada in _dificuldades.entries)
                    _Chip(
                      rotulo: entrada.value,
                      selecionado: entrada.key == _dificuldade,
                      onTap: () => setState(() => _dificuldade = entrada.key),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _Secao('Explicação'),
              const SizedBox(height: 8),
              _Campo(
                controller: _explicacaoCtrl,
                hint: 'Aparece depois que a criança responde.',
                maxLines: 3,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 20),
              GlassCard(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppTheme.verde,
                  value: _salvarAprovada,
                  onChanged: (v) => setState(() => _salvarAprovada = v),
                  title: Text(
                    _salvarAprovada
                        ? 'Salvar como APROVADA'
                        : 'Salvar como PENDENTE',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    _salvarAprovada
                        ? 'Já entra no jogo.'
                        : 'Fica na fila de revisão.',
                    style: const TextStyle(color: AppTheme.textoSuave),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: const Icon(Icons.check),
                label: Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verde,
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

class _Secao extends StatelessWidget {
  final String texto;
  const _Secao(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    );
  }
}

class _Campo extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final VoidCallback onChanged;

  const _Campo({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String rotulo;
  final bool selecionado;
  final VoidCallback onTap;

  const _Chip({
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
          color: selecionado ? AppTheme.indigo : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selecionado ? AppTheme.indigo : Colors.black12,
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

class _AlternativaLinha extends StatelessWidget {
  final String letra;
  final TextEditingController controller;
  final bool correta;
  final VoidCallback onMarcarCorreta;
  final VoidCallback onChanged;

  const _AlternativaLinha({
    required this.letra,
    required this.controller,
    required this.correta,
    required this.onMarcarCorreta,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onMarcarCorreta,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: correta ? AppTheme.verde : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: correta ? AppTheme.verde : Colors.black12,
                width: correta ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: correta
                ? const Icon(Icons.check, color: Colors.white)
                : Text(
                    letra,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 18),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Alternativa $letra',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
