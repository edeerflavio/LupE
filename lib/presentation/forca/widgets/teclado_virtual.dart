import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Teclado virtual A-Z (RF03.3). Sem teclas acentuadas: a normalização
/// resolve acentos e cedilha (RF03.5). Letras já tentadas ficam bloqueadas.
///
/// As teclas se ajustam à largura disponível (cabem numa tela de iPhone sem
/// cortar as laterais, e ficam maiores no tablet).
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
  static const double _margem = 2; // margem lateral de cada tecla

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // A linha mais larga tem 10 teclas — dimensiona por ela.
        final larguraTecla =
            ((constraints.maxWidth / 10) - _margem * 2).clamp(24.0, 46.0);
        final alturaTecla = larguraTecla * 1.18;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final linha in _linhas)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final letra in linha.split(''))
                      _Tecla(
                        letra: letra,
                        largura: larguraTecla,
                        altura: alturaTecla,
                        estado: _estado(letra),
                        habilitado: habilitado,
                        onTap: () => onLetra(letra),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
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
  final double largura;
  final double altura;
  final _EstadoTecla estado;
  final bool habilitado;
  final VoidCallback onTap;

  const _Tecla({
    required this.letra,
    required this.largura,
    required this.altura,
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
      padding: const EdgeInsets.symmetric(horizontal: TecladoVirtual._margem),
      child: SizedBox(
        width: largura,
        height: altura,
        child: Material(
          color: fundo,
          borderRadius: BorderRadius.circular(9),
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: ativo ? onTap : null,
            child: Center(
              child: Text(
                letra,
                style: TextStyle(
                  fontSize: (largura * 0.48).clamp(13.0, 20.0),
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
