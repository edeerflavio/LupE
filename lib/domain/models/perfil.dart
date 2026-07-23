import 'dart:convert';

/// Perfil de uma criança (RF01).
/// Sem senha; a seleção é por toque no avatar.
class Perfil {
  final String id;
  final String nome;
  final String avatar; // chave do emoji/ícone (ex.: 'raposa')
  final int anoEscolar; // 1..9, usado para filtrar dificuldade (RF01.3)
  final DateTime criadoEm;

  const Perfil({
    required this.id,
    required this.nome,
    required this.avatar,
    required this.anoEscolar,
    required this.criadoEm,
  });

  Perfil copyWith({String? nome, String? avatar, int? anoEscolar}) {
    return Perfil(
      id: id,
      nome: nome ?? this.nome,
      avatar: avatar ?? this.avatar,
      anoEscolar: anoEscolar ?? this.anoEscolar,
      criadoEm: criadoEm,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'avatar': avatar,
        'ano_escolar': anoEscolar,
        'criado_em': criadoEm.toIso8601String(),
      };

  factory Perfil.fromMap(Map<String, dynamic> map) => Perfil(
        id: map['id'] as String,
        nome: map['nome'] as String,
        avatar: map['avatar'] as String,
        anoEscolar: map['ano_escolar'] as int,
        criadoEm: DateTime.parse(map['criado_em'] as String),
      );

  String toJson() => jsonEncode(toMap());
  factory Perfil.fromJson(String source) =>
      Perfil.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
