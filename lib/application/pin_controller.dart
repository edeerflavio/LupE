import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local do PIN do Painel dos Pais (RF05.1).
///
/// Guarda apenas 4 dígitos em SharedPreferences. A interface é isolada para,
/// no futuro, poder migrar para um armazenamento mais seguro sem mexer na UI.
/// (O objetivo aqui é apenas impedir que a criança entre por curiosidade — não
/// é um cofre criptográfico.)
class PinRepository {
  static const _chave = 'lupe.painel.pin';

  Future<String?> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chave);
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  Future<void> salvar(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, pin);
  }
}

final pinRepositoryProvider = Provider((_) => PinRepository());

/// Estado do PIN: `true` quando já existe um PIN definido pelo responsável.
final pinProvider =
    AsyncNotifierProvider<PinController, bool>(PinController.new);

class PinController extends AsyncNotifier<bool> {
  PinRepository get _repo => ref.read(pinRepositoryProvider);

  @override
  Future<bool> build() async {
    final pin = await _repo.carregar();
    return pin != null;
  }

  /// Já existe um PIN cadastrado?
  Future<bool> existePin() async => (await _repo.carregar()) != null;

  /// Define (ou substitui) o PIN. Espera 4 dígitos.
  Future<void> definirPin(String pin) async {
    await _repo.salvar(pin);
    state = const AsyncData(true);
  }

  /// Confere o PIN informado contra o armazenado.
  Future<bool> verificarPin(String pin) async {
    final atual = await _repo.carregar();
    return atual != null && atual == pin;
  }
}
