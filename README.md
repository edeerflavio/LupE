# LuPe

App educacional gamificado para crianças (PT-BR). O nome **LuPe** é uma
homenagem aos filhos do autor — **Lu**iza e **Pe**dro. Construído a partir do
`EduPlay-Kids-Pesquisa-e-PRD.md` na raiz do repositório.

> Observação: o id interno do pacote Flutter continua `eduplay_kids` (renomear
> o pacote quebraria todos os imports); apenas o nome exibido é **LuPe**.

Stack: **Flutter + Riverpod**, offline-first (RNF03), sem anúncios, sem coleta
de dados (RNF05).

## Estado atual (o que já está pronto)

Fatia vertical jogável — **Fase 0 + Fase 1 do roadmap**:

- ✅ **Perfis** (RF01.1–01.3): criação com avatar/nome/ano escolar, seleção
  sem senha, persistência local entre sessões.
- ✅ **Forca de Geografia** (RF03): sorteio por dificuldade, dica obrigatória,
  teclado virtual com bloqueio de letras usadas, limite de 6 erros, desenho
  progressivo do boneco, tela de vitória/derrota.
- ✅ **Tratamento de acentos** (RF03.5): a criança digita `A` e acerta
  `Á/À/Ã/Â`; a cedilha entra via `C`. Coberto por testes.
- ✅ **Adivinhe** (letras embaralhadas): mostra um enigma e o jogador monta o
  nome com peças de letras embaralhadas (mesmo tratamento de acento).
  - **Bandeiras**: **imagem real** da bandeira em PNG (42 países), de domínio
    público (flagcdn.com / flagpedia.net), embutidas em `assets/flags/` e
    usadas offline.
  - **Mapa**: país destacado em cor diferente no mapa-múndi (pacote
    `countries_world_map`, vetorial e offline) — mesmos 42 países.
  - **Animais**: **fotos reais** (18 animais) do Wikimedia Commons, sob
    licenças livres (CC / domínio público). Créditos em `CREDITOS-IMAGENS.md`.
  - Botão de dica, feedback de acerto/erro, "próximo" com item novo.
- ✅ **Matemática** (RF04): gerador procedural (soma, subtração, tabuada,
  multiplicação, divisão exata), **dificuldade adaptativa** (sobe após 3
  acertos seguidos, desce após 2 erros) e **modo contra o tempo** (60s).
- ✅ **Quiz** (RF02): seleção de matéria, múltipla escolha (4 alternativas),
  timer opcional, ajuda "eliminar duas", e **explicação após cada resposta**
  (RF02.5). Consome apenas perguntas aprovadas.
- ✅ **Painel dos Pais** (RF05): acesso por **PIN**, cadastro manual de
  perguntas, **geração por IA** (interface pronta; rascunhos entram pendentes),
  **fila de revisão** obrigatória (aprovar/rejeitar), e relatórios de conteúdo.
- ✅ **Identidade visual "PetDex"** (inspirada no v0 codex-pet-gallery):
  fundo em gradiente azul-lavanda, painéis de vidro (glassmorphism), botões
  pílula, cards inclinados e micro-labels em maiúsculas. Primitivos
  reutilizáveis em `core/theme/app_theme.dart` (`CloudBackground`, `GlassCard`,
  `KickerLabel`). Mantém a usabilidade infantil (RNF01).
- ✅ Feedback visual + háptico em todos os jogos.
- ✅ **Gamificação** (Fase 5): efeitos **sonoros** (sintetizados, sem
  copyright), **conquistas/medalhas** por perfil com popup animado, **confete**
  na vitória, e **repetição dirigida** no Quiz (perguntas erradas voltam mais).
  Progresso persistido por perfil (`progresso_controller.dart`).
- ✅ **Botão de mudo** (som ligado/desligado, persistido) na Home.
- ✅ **Relatórios dos pais** por filho: partidas, acertos/erros, taxa de acerto,
  melhor sequência, medalhas e melhor matéria (do progresso persistido).
- ✅ **Ícone e splash** do app (carinha LuPe) para Android/iOS/Windows; guia de
  build em `BUILD.md`.
- ✅ Conteúdo: **60 perguntas** de Quiz, **~77 palavras** de Forca, **60 países**
  (bandeiras + mapa) e **28 animais** (fotos).
- ✅ **Multiplataforma mobile**: Android + **iOS (iPhone e iPad)**. Layouts
  **responsivos** — grades adaptativas por largura (2 colunas no celular, mais
  no iPad) e conteúdo com largura máxima para não esticar em telas grandes
  (helper `core/widgets/responsivo.dart`).

> **Marcas famosas e personagens** usam o mesmo motor "Adivinhe", mas dependem
> de imagens (logos/personagens são material protegido por direitos autorais).
> Entram numa fase seguinte, cadastrados pelo responsável no Painel dos Pais —
> o motor (`TipoVisual.marca` / `.personagem`) já está pronto para recebê-las.

## Rodar

```bash
flutter pub get
flutter run            # escolha o dispositivo (iPhone/iPad, Android, Windows)
flutter test           # testes da lógica da forca
flutter analyze
```

## Estrutura

```
lib/
  core/
    constants/avatares.dart      # catálogo de avatares (emoji)
    theme/app_theme.dart         # tema infantil
    utils/diacritics.dart        # normalização de acentos (RF03.5)
  domain/models/                 # Perfil, PalavraForca, ForcaEstado
  data/
    seed/palavras_geografia.dart # semente local de conteúdo (offline)
    repositories/                # Perfil e Palavra (isolados p/ trocar por Supabase)
  application/                   # controllers Riverpod
  presentation/
    perfil/                      # seleção e criação de perfil
    home/                        # grade de jogos
    forca/                       # jogo da forca + widgets
```

## Próximos passos (roadmap do PRD)

- **Fase 5 — Gamificação**: sons, conquistas, avatares, animações, repetição
  dirigida (perguntas erradas voltam com mais frequência).
- **Backend (quando publicar)**: migrar de SharedPreferences/seed local para
  Supabase; ligar a geração por IA real via Edge Function (chave nunca no app,
  RNF06); persistir histórico de partidas para relatórios de desempenho.

### Fontes de conteúdo (livres para uso)

| Conteúdo | Fonte | Licença |
|---|---|---|
| Bandeiras (PNG) | [flagcdn.com / flagpedia.net](https://flagpedia.net) | Domínio público, sem atribuição exigida |
| Mapa-múndi vetorial | pacote `countries_world_map` | Ver licença do pacote no pub.dev |
| Palavras/países (PT-BR) | curadoria própria (base: PRD) | — |

> **Marcas e personagens** ficam de fora por ora: logos e personagens têm
> direitos autorais/marca registrada e **não** são de uso livre, mesmo pessoal.
> Fontes seguras para expandir o visual no futuro, todas de uso livre:
> **Wikimedia Commons** (imagens PD/CC), **Openclipart** (CC0), **Openmoji**
> (CC BY-SA, ícones), **Pexels/Unsplash** (fotos, animais/objetos). O responsável
> adiciona pelo Painel dos Pais (Fase 4).

### Decisões de arquitetura

- **Offline-first com semente local**: o conteúdo (`data/seed/`) vem embutido.
  Conforme o PRD, as APIs gratuitas (countries.dev, IBGE, Tryvia, `fserb/pt-br`)
  serão importadas **uma vez** para o banco, nunca consumidas em runtime.
- **Repositórios isolados**: `PerfilRepository`/`PalavraRepository` escondem a
  fonte de dados. Trocar SharedPreferences/seed por Supabase não toca na UI.
- **Riverpod 2.x**: fixado para alinhar com o padrão já usado no AppPocus.
