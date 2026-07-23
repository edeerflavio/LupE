import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Desenho progressivo da forca. [erros] vai de 0 a 6; cada erro adiciona
/// uma parte do boneco. Feedback visual redundante ao som (RNF07).
class BonecoForca extends StatelessWidget {
  final int erros;
  final int maxErros;

  const BonecoForca({super.key, required this.erros, this.maxErros = 6});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _ForcaPainter(erros: erros.clamp(0, maxErros)),
      ),
    );
  }
}

class _ForcaPainter extends CustomPainter {
  final int erros;
  _ForcaPainter({required this.erros});

  @override
  void paint(Canvas canvas, Size size) {
    final estrutura = Paint()
      ..color = AppTheme.texto
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final corpo = Paint()
      ..color = AppTheme.vermelho
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Base e mastro da forca (sempre visíveis).
    canvas.drawLine(Offset(w * 0.1, h * 0.95), Offset(w * 0.6, h * 0.95), estrutura);
    canvas.drawLine(Offset(w * 0.25, h * 0.95), Offset(w * 0.25, h * 0.08), estrutura);
    canvas.drawLine(Offset(w * 0.25, h * 0.08), Offset(w * 0.62, h * 0.08), estrutura);
    canvas.drawLine(Offset(w * 0.62, h * 0.08), Offset(w * 0.62, h * 0.2), estrutura);

    final cx = w * 0.62;
    // Partes do boneco conforme os erros.
    if (erros >= 1) {
      canvas.drawCircle(Offset(cx, h * 0.28), h * 0.08, corpo); // cabeça
    }
    if (erros >= 2) {
      canvas.drawLine(Offset(cx, h * 0.36), Offset(cx, h * 0.62), corpo); // tronco
    }
    if (erros >= 3) {
      canvas.drawLine(Offset(cx, h * 0.42), Offset(cx - w * 0.12, h * 0.52), corpo); // braço esq
    }
    if (erros >= 4) {
      canvas.drawLine(Offset(cx, h * 0.42), Offset(cx + w * 0.12, h * 0.52), corpo); // braço dir
    }
    if (erros >= 5) {
      canvas.drawLine(Offset(cx, h * 0.62), Offset(cx - w * 0.1, h * 0.8), corpo); // perna esq
    }
    if (erros >= 6) {
      canvas.drawLine(Offset(cx, h * 0.62), Offset(cx + w * 0.1, h * 0.8), corpo); // perna dir
    }
  }

  @override
  bool shouldRepaint(_ForcaPainter old) => old.erros != erros;
}
