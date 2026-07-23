import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Teclado virtual A-Z (RF03.3). Sem teclas acentuadas: a normalização
/// resolve acentos e cedilha (RF03.5). Letras já tentadas ficam bloqueadas.
class TecladoVirtual extends StatelessWidget {
  final Set<String> letrasCertas;
  final Set<String> letrasErradas;
  final bool habilitado;
  final void Function(String letra) onLetra;

  const TecladoVirtual({
    super.key,
    required this.letrasCertas,
    required this.letrasErradas,
    required this.habilitado,
    required this.onLetra,
  });

  static const _linhas = ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final linha in _linhas)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final letra in linha.split(''))
                  _Tecla(
                    letra: letra,
                    estado: _estado(letra),
                    habilitado: habilitado,
                    onTap: () => onLetra(letra),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  _EstadoTecla _estado(String letra) {
    if (letrasCertas.contains(letra)) return _EstadoTecla.certa;
    if (letrasErradas.contains(letra)) return _EstadoTecla.errada;
    return _EstadoTecla.livre;
  }
}

enum _EstadoTecla { livre, certa, errada }

class _Tecla extends StatelessWidget {
  final String letra;
  final _EstadoTecla estado;
  final bool habilitado;
  final VoidCallback onTap;

  const _Tecla({
    required this.letra,
    required this.estado,
    required this.habilitado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final usada = estado != _EstadoTecla.livre;
    final ativo = habilitado && !usada;

    Color fundo;
    Color texto = Colors.white;
    switch (estado) {
      case _EstadoTecla.certa:
        fundo = AppTheme.verde;
        break;
      case _EstadoTecla.errada:
        fundo = AppTheme.vermelho;
        break;
      case _EstadoTecla.livre:
        fundo = ativo ? AppTheme.roxo : Colors.grey.shade300;
        texto = ativo ? Colors.white : Colors.grey;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 40,
        height: 48,
        child: Material(
          color: fundo,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: ativo ? onTap : null,
            child: Center(
              child: Text(
                letra,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: texto,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
