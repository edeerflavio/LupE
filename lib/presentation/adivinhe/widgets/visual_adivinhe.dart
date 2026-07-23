import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/models/adivinhe_item.dart';

/// Mostra o "enigma" do item conforme seu tipo: bandeira (emoji), país no
/// mapa-múndi, emoji de objeto, ou imagem (marca/personagem — futuro).
class VisualAdivinhe extends StatelessWidget {
  final AdivinheItem item;
  const VisualAdivinhe({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return switch (item.tipo) {
      TipoVisual.bandeira => _bandeira(),
      TipoVisual.foto => _foto(),
      TipoVisual.emoji => _emoji(item.emoji ?? '❓', tamanho: 110),
      TipoVisual.mapa => _mapa(),
      TipoVisual.marca ||
      TipoVisual.personagem =>
        _imagemOuPlaceholder(),
    };
  }

  /// Foto real (animais etc.), preenchendo a área com cantos arredondados.
  Widget _foto() {
    final asset = item.assetImagem;
    if (asset == null) return _emoji('🐾', tamanho: 110);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(asset, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _emoji(String e, {required double tamanho}) {
    return Center(
      child: Text(e, style: TextStyle(fontSize: tamanho)),
    );
  }

  /// Imagem real da bandeira (PNG de domínio público), com moldura suave.
  Widget _bandeira() {
    final asset = item.assetImagem;
    if (asset == null) return _emoji('🏳️', tamanho: 120);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(asset, height: 150, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mapa() {
    final iso = item.codigoPais;
    if (iso == null) return _emoji('🗺️', tamanho: 110);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SimpleMap(
        instructions: SMapWorld.instructions,
        defaultColor: const Color(0xFFDDE3F0),
        countryBorder: const CountryBorder(color: Colors.white, width: 0.12),
        colors: {iso: AppTheme.vermelho},
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _imagemOuPlaceholder() {
    final asset = item.assetImagem;
    if (asset != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(asset, fit: BoxFit.contain),
      );
    }
    // Sem imagem ainda: as marcas/personagens entram pelo Painel dos Pais.
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🖼️', style: TextStyle(fontSize: 72)),
          SizedBox(height: 8),
          Text('Imagem em breve',
              style: TextStyle(fontSize: 14, color: Colors.black45)),
        ],
      ),
    );
  }
}
