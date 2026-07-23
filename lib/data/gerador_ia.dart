import '../domain/models/pergunta.dart';

/// Interface de geração de perguntas por IA (RF05.3).
///
/// IMPORTANTE (RNF06): a chamada real a uma API de IA (Anthropic/Gemini)
/// NUNCA pode partir do app — a chave vazaria. O fluxo correto é:
///   App → Supabase Edge Function (guarda a chave) → API de IA → volta ao app
/// Esta interface existe para plugar essa Edge Function no futuro sem mexer na
/// UI. Por ora, [GeradorIALocal] produz rascunhos locais para demonstrar a
/// fila de revisão (as perguntas geradas entram como `pendente`).
abstract class GeradorIA {
  Future<List<Pergunta>> gerar({
    required String tema,
    required String materia,
    required int quantidade,
    required int idade,
  });
}

/// Implementação local (sem rede). Gera rascunhos claramente marcados como
/// pendentes, para o responsável revisar, editar e aprovar (RF05.4).
class GeradorIALocal implements GeradorIA {
  DateTime _agora() => DateTime.now();

  @override
  Future<List<Pergunta>> gerar({
    required String tema,
    required String materia,
    required int quantidade,
    required int idade,
  }) async {
    // Simula latência de rede.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final agora = _agora();
    return List.generate(quantidade, (i) {
      final n = i + 1;
      return Pergunta(
        id: 'ia_${agora.microsecondsSinceEpoch}_$n',
        materia: materia,
        subtema: tema,
        dificuldade: idade <= 8 ? 'facil' : 'medio',
        enunciado: 'Rascunho $n sobre "$tema" — edite o enunciado antes de aprovar.',
        alternativas: const [
          'Alternativa A',
          'Alternativa B',
          'Alternativa C',
          'Alternativa D',
        ],
        indiceCorreta: 0,
        explicacao: 'Escreva aqui a explicação correta antes de aprovar.',
        origem: OrigemPergunta.iaGerada,
        status: StatusPergunta.pendente,
        criadaEm: agora,
      );
    });
  }
}
