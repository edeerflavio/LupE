import 'dart:ui';

import 'package:flutter/material.dart';

/// Identidade visual inspirada no "PetDex" (codex-pet-gallery): fundo em
/// gradiente azul-lavanda sonhador, painéis de vidro (glassmorphism), botões
/// em formato de pílula e alto contraste — mantendo a usabilidade infantil
/// (RNF01: botões grandes, cantos arredondados).
class AppTheme {
  // Paleta
  static const Color indigo = Color(0xFF5266EA); // acento principal
  static const Color roxo = Color(0xFF6C5CE7);
  static const Color amarelo = Color(0xFFFFC531);
  static const Color verde = Color(0xFF00B894);
  static const Color vermelho = Color(0xFFE84393);
  static const Color azul = Color(0xFF0984E3);
  static const Color fundo = Color(0xFFF7F8FF);
  static const Color texto = Color(0xFF202127);
  static const Color textoSuave = Color(0xFF5B5E6B);

  // Gradiente "cloud" (fundo das telas principais)
  static const List<Color> nuvem = [
    Color(0xFFD8E9FF),
    Color(0xFFF7F8FF),
    Color(0xFFC9C6FF),
  ];

  // Vidro (glassmorphism)
  static Color get vidroFundo => Colors.white.withValues(alpha: 0.62);
  static Color get vidroBorda => Colors.white.withValues(alpha: 0.72);
  static const List<BoxShadow> sombraVidro = [
    BoxShadow(
      color: Color(0x292A3778), // rgb(42,55,120) ~16%
      blurRadius: 40,
      offset: Offset(0, 24),
    ),
  ];

  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: indigo,
        primary: indigo,
        secondary: amarelo,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: fundo,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: texto, displayColor: texto),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(96, 56), // botões grandes (RNF01)
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          shape: const StadiumBorder(), // pílula
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: const StadiumBorder(),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: texto,
        titleTextStyle: TextStyle(
          color: texto,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/// Fundo em gradiente "cloud" com brilhos suaves. Use como raiz do corpo das
/// telas: `CloudBackground(child: ...)`.
class CloudBackground extends StatelessWidget {
  final Widget child;
  const CloudBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.nuvem,
          stops: [0.0, 0.47, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Brilhos radiais (o "petdex-cloud")
          Positioned(
            top: -120,
            right: -80,
            child: _Brilho(color: const Color(0xFF6478F6), size: 320),
          ),
          Positioned(
            bottom: -100,
            left: -90,
            child: _Brilho(color: Colors.white, size: 300, opacity: 0.7),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Brilho extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  const _Brilho({required this.color, required this.size, this.opacity = 0.5});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

/// Painel de vidro translúcido (glassmorphism), com blur e sombra suave.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? tint;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 24,
    this.onTap,
    this.onLongPress,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borda,
        boxShadow: AppTheme.sombraVidro,
      ),
      child: ClipRRect(
        borderRadius: borda,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: tint ?? AppTheme.vidroFundo,
              borderRadius: borda,
              border: Border.all(color: AppTheme.vidroBorda, width: 1.2),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: borda,
                onTap: onTap,
                onLongPress: onLongPress,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Micro-rótulo em maiúsculas com espaçamento largo (estilo PetDex).
class KickerLabel extends StatelessWidget {
  final String texto;
  final Color? cor;
  const KickerLabel(this.texto, {super.key, this.cor});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.4,
        color: cor ?? AppTheme.indigo,
      ),
    );
  }
}
