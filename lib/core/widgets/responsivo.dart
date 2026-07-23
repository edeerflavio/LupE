import 'package:flutter/widgets.dart';

/// Helpers de responsividade para celular e iPad.
///
/// A regra geral: em telas largas (iPad/desktop) o conteúdo não deve esticar —
/// ele fica centralizado com uma largura máxima confortável, como nos apps iOS.

/// Centraliza o filho e limita a largura máxima.
class Limitado extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const Limitado({super.key, required this.child, this.maxWidth = 720});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Grade adaptativa: o número de colunas varia com a largura disponível.
/// Cada célula tem no máximo [extentMax] de largura — 2 colunas no celular,
/// 3–5 no iPad, sem código condicional.
SliverGridDelegate gradeAdaptativa({
  double extentMax = 220,
  double aspecto = 1.0,
  double espaco = 18,
}) {
  return SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: extentMax,
    childAspectRatio: aspecto,
    mainAxisSpacing: espaco,
    crossAxisSpacing: espaco,
  );
}

/// True quando a tela é larga o suficiente para ser tratada como tablet.
bool ehTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).shortestSide >= 600;
