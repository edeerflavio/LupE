# Backend do LuPe — PocketBase (SQLite na sua VPS)

Guarda **perfis, progresso, conquistas e o ranking da família** na sua VPS, com
**login por família**. É um único serviço (PocketBase) com **SQLite embutido** —
leve, como você já roda o Immich.

## O que é

- **PocketBase**: servidor único (Go) com SQLite, autenticação e API REST.
- Coleções (criadas automaticamente pelas migrações em `pb_migrations/`):
  - `users` — a **conta da família** (e-mail + senha). Cada família = 1 conta.
  - `perfis` — os filhos (nome, avatar, ano).
  - `progresso` — acertos, erros, partidas, sequência, medalhas, por perfil.
- **Ranking** = os `progresso` da mesma família, ordenados por acertos.
- Regras simples, baseadas no dono (`owner`) — sem RLS complexa, como você pediu.

## Subir na VPS

```bash
# na sua VPS, dentro desta pasta backend/
docker compose up -d
# cria o superusuário (painel admin do PocketBase)
docker compose exec pocketbase /usr/local/bin/pocketbase superuser upsert SEU_EMAIL SUA_SENHA
```

O painel admin fica em `http://SEU_IP:8090/_/`. As coleções já vêm prontas.

### HTTPS (importante para a versão web)

A versão web do LuPe (Netlify, em `https://`) só consegue falar com o backend se
ele estiver em **HTTPS** (senão o navegador bloqueia por "mixed content"). Como
você já tem um proxy reverso para o Immich, adicione um host, por exemplo:

- **Caddy**: `lupe-api.seudominio.com { reverse_proxy localhost:8090 }`
- **Nginx Proxy Manager**: novo Proxy Host → `localhost:8090`, com SSL.

Para o app **Android** instalado (APK), HTTP puro também funciona, mas HTTPS é
recomendado.

## Ligar o app ao backend

No app LuPe: **Área dos pais (cadeado) → Sincronização na nuvem**:
1. Cole a URL do backend (ex.: `https://lupe-api.seudominio.com`).
2. **Criar conta da família** (e-mail + senha) na primeira vez, ou **Entrar**.
3. Pronto: a partir daí, perfis e progresso sincronizam automaticamente, e o
   ranking da família aparece na tela de Conquistas.

O app continua **funcionando offline** — sem backend, tudo fica salvo localmente
(como antes). Com o backend, os dados passam a ser salvos na nuvem também e
sincronizam entre os aparelhos.

## Backup

Todo o banco é o arquivo `pb_data/data.db` (SQLite). Backup = copiar `pb_data/`.
O painel admin também tem exportação/backup embutida em Settings → Backups.

## Fechar o cadastro (opcional)

Depois de criar a conta da família, se quiser impedir novos cadastros: no painel
admin, coleção `users` → API Rules → **Create rule** → deixe vazio/`null` e salve.
