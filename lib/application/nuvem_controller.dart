import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sync/nuvem.dart';

/// Instância única do cliente de nuvem.
final nuvemProvider = Provider<Nuvem>((_) => Nuvem());

class NuvemEstado {
  final String? url;
  final bool logada;
  final String? email;
  const NuvemEstado({this.url, this.logada = false, this.email});

  bool get configurada => url != null && url!.isNotEmpty;
}

final nuvemEstadoProvider =
    AsyncNotifierProvider<NuvemController, NuvemEstado>(NuvemController.new);

class NuvemController extends AsyncNotifier<NuvemEstado> {
  static const _kUrl = 'lupe.nuvem.url';
  static const _kToken = 'lupe.nuvem.token';
  static const _kRecord = 'lupe.nuvem.record';

  Nuvem get _nuvem => ref.read(nuvemProvider);

  @override
  Future<NuvemEstado> build() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(_kUrl);
    if (url == null || url.isEmpty) return const NuvemEstado();

    final token = prefs.getString(_kToken);
    final recordRaw = prefs.getString(_kRecord);
    _nuvem.configurar(
      url,
      token: token,
      record: recordRaw != null
          ? jsonDecode(recordRaw) as Map<String, dynamic>
          : null,
    );
    return NuvemEstado(url: url, logada: _nuvem.logada, email: _nuvem.email);
  }

  Future<void> _salvarSessao(SharedPreferences prefs) async {
    if (_nuvem.token != null) await prefs.setString(_kToken, _nuvem.token!);
    if (_nuvem.recordJson != null) {
      await prefs.setString(_kRecord, jsonEncode(_nuvem.recordJson));
    }
  }

  NuvemEstado get _estado =>
      NuvemEstado(url: _nuvem.url, logada: _nuvem.logada, email: _nuvem.email);

  Future<void> definirUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUrl, url.trim());
    _nuvem.configurar(url);
    state = AsyncData(_estado);
  }

  Future<void> criarConta(String email, String senha) async {
    await _nuvem.criarConta(email, senha);
    final prefs = await SharedPreferences.getInstance();
    await _salvarSessao(prefs);
    state = AsyncData(_estado);
  }

  Future<void> entrar(String email, String senha) async {
    await _nuvem.entrar(email, senha);
    final prefs = await SharedPreferences.getInstance();
    await _salvarSessao(prefs);
    state = AsyncData(_estado);
  }

  Future<void> sair() async {
    _nuvem.sair();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRecord);
    state = AsyncData(_estado);
  }
}
