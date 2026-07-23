import 'package:pocketbase/pocketbase.dart';

import '../../domain/models/progresso.dart';

/// Uma linha do ranking da família (vinda da nuvem).
class RankingItem {
  final String perfilId;
  final String nome;
  final String avatar;
  final int acertos;
  final int erros;
  final int partidas;
  final int melhorSequencia;
  final int medalhas;

  const RankingItem({
    required this.perfilId,
    required this.nome,
    required this.avatar,
    required this.acertos,
    required this.erros,
    required this.partidas,
    required this.melhorSequencia,
    required this.medalhas,
  });
}

/// Cliente do backend na nuvem (PocketBase) — login da família e sincronização
/// de progresso/ranking. Tudo é best-effort: se a nuvem falhar, o app segue
/// funcionando com os dados locais (offline-first).
class Nuvem {
  PocketBase? _pb;
  String? url;

  bool get configurada => _pb != null;
  bool get logada => _pb?.authStore.isValid ?? false;
  String? get email => _pb?.authStore.record?.getStringValue('email');
  String? get _ownerId => _pb?.authStore.record?.id;

  /// Configura a URL do backend e, opcionalmente, restaura uma sessão salva.
  void configurar(String novaUrl, {String? token, Map<String, dynamic>? record}) {
    url = novaUrl.trim().replaceAll(RegExp(r'/+$'), '');
    _pb = PocketBase(url!);
    if (token != null && token.isNotEmpty) {
      _pb!.authStore.save(
        token,
        record != null ? RecordModel.fromJson(record) : null,
      );
    }
  }

  String? get token => _pb?.authStore.token;
  Map<String, dynamic>? get recordJson => _pb?.authStore.record?.toJson();

  Future<void> criarConta(String email, String senha) async {
    await _pb!.collection('users').create(body: {
      'email': email.trim(),
      'password': senha,
      'passwordConfirm': senha,
    });
    await entrar(email, senha);
  }

  Future<void> entrar(String email, String senha) async {
    await _pb!.collection('users').authWithPassword(email.trim(), senha);
  }

  void sair() => _pb?.authStore.clear();

  /// Envia (cria ou atualiza) o progresso de um perfil para a nuvem.
  Future<void> enviarProgresso(
    ProgressoPerfil p, {
    required String nome,
    required String avatar,
  }) async {
    if (!logada) return;
    final owner = _ownerId!;
    final body = <String, dynamic>{
      'perfilId': p.perfilId,
      'nome': nome,
      'avatar': avatar,
      'acertos': p.acertos,
      'erros': p.erros,
      'partidas': p.partidas,
      'melhorSequencia': p.melhorSequencia,
      'acertosPorMateria': p.acertosPorMateria,
      'partidasPorJogo': p.partidasPorJogo,
      'conquistas': p.conquistas.toList(),
      'errosPorPergunta': p.errosPorPergunta,
      'owner': owner,
    };
    final existentes = await _pb!.collection('progresso').getFullList(
          filter: "perfilId='${p.perfilId}' && owner='$owner'",
        );
    if (existentes.isNotEmpty) {
      await _pb!.collection('progresso').update(existentes.first.id, body: body);
    } else {
      await _pb!.collection('progresso').create(body: body);
    }
  }

  /// Ranking da família: progresso ordenado por acertos.
  Future<List<RankingItem>> ranking() async {
    if (!logada) return const [];
    final owner = _ownerId!;
    final registros = await _pb!.collection('progresso').getFullList(
          sort: '-acertos',
          filter: "owner='$owner'",
        );
    return [
      for (final r in registros)
        RankingItem(
          perfilId: r.getStringValue('perfilId'),
          nome: r.getStringValue('nome'),
          avatar: r.getStringValue('avatar'),
          acertos: r.getIntValue('acertos'),
          erros: r.getIntValue('erros'),
          partidas: r.getIntValue('partidas'),
          melhorSequencia: r.getIntValue('melhorSequencia'),
          medalhas: (r.data['conquistas'] as List?)?.length ?? 0,
        ),
    ];
  }
}
