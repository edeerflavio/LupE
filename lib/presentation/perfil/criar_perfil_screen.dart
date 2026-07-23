import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/perfil_controller.dart';
import '../../core/constants/avatares.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsivo.dart';

/// RF01.1 — criação de perfil com avatar, nome e ano escolar.
class CriarPerfilScreen extends ConsumerStatefulWidget {
  const CriarPerfilScreen({super.key});

  @override
  ConsumerState<CriarPerfilScreen> createState() => _CriarPerfilScreenState();
}

class _CriarPerfilScreenState extends ConsumerState<CriarPerfilScreen> {
  final _nomeCtrl = TextEditingController();
  String _avatar = Avatares.chaves.first;
  int _anoEscolar = 3;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  bool get _podeSalvar => _nomeCtrl.text.trim().isNotEmpty;

  Future<void> _salvar() async {
    await ref.read(perfisProvider.notifier).criar(
          nome: _nomeCtrl.text,
          avatar: _avatar,
          anoEscolar: _anoEscolar,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Novo perfil'),
      ),
      body: CloudBackground(
        child: SafeArea(
        child: Limitado(
          maxWidth: 620,
          child: ListView(
          padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 24),
          children: [
            const Text('Escolha um bichinho',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final chave in Avatares.chaves)
                  _AvatarOpcao(
                    simbolo: Avatares.simbolo(chave),
                    selecionado: chave == _avatar,
                    onTap: () => setState(() => _avatar = chave),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Nome',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            TextField(
              controller: _nomeCtrl,
              onChanged: (_) => setState(() {}),
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Ex.: Ana',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Ano escolar: $_anoEscolar º',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Slider(
              value: _anoEscolar.toDouble(),
              min: 1,
              max: 9,
              divisions: 8,
              label: '$_anoEscolar º ano',
              activeColor: AppTheme.roxo,
              onChanged: (v) => setState(() => _anoEscolar = v.round()),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _podeSalvar ? _salvar : null,
              icon: const Icon(Icons.check),
              label: const Text('Criar perfil'),
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

class _AvatarOpcao extends StatelessWidget {
  final String simbolo;
  final bool selecionado;
  final VoidCallback onTap;

  const _AvatarOpcao({
    required this.simbolo,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: selecionado ? AppTheme.amarelo : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado ? AppTheme.roxo : Colors.black12,
            width: selecionado ? 3 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(simbolo, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}
