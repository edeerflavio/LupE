# Guia de build — LuPe

App: **LuPe** · pacote `eduplay_kids` · id `com.eder.eduplay` · versão `1.0.0+1`
(a versão vem do campo `version:` no `pubspec.yaml` — suba o número a cada release).

Plataformas prontas: **Android**, **iOS (iPhone/iPad)**, **Windows**.
Ícone e splash já gerados (carinha do LuPe). Para regenerar:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Rodar em desenvolvimento
```bash
flutter pub get
flutter devices            # lista aparelhos/emuladores conectados
flutter run                # escolha o dispositivo
flutter run -d <id>        # direto num aparelho específico
```

## Android

Rodar num celular Android (com "Depuração USB" ligada) ou emulador:
```bash
flutter run -d android
```

Gerar o instalável:
```bash
flutter build apk --release            # APK único (bom para instalar direto)
flutter build appbundle --release      # AAB (formato da Google Play)
```
O APK sai em `build/app/outputs/flutter-apk/app-release.apk` — dá para copiar
para o celular e instalar (permita "fontes desconhecidas").

**Assinatura (para publicar na Play Store):** gere uma keystore e configure
`android/key.properties` + `android/app/build.gradle` conforme
https://docs.flutter.dev/deployment/android#signing-the-app . Para uso pessoal
(instalar direto), o APG release já funciona com a chave de debug/temporária.

## iOS (iPhone / iPad) — exige um Mac

O código iOS está pronto, mas **compilar e instalar num iPhone/iPad exige um
Mac com Xcode** (a Apple não permite build de iOS no Windows). Num Mac:
```bash
flutter pub get
cd ios && pod install && cd ..
open ios/Runner.xcworkspace     # abrir no Xcode
```
No Xcode: selecione o time de desenvolvimento (Signing & Capabilities), conecte
o aparelho e clique em Run. Para uma conta Apple gratuita dá para instalar no
próprio aparelho (o app expira em 7 dias e precisa ser reinstalado). Com conta
paga do Apple Developer (US$99/ano) dá para instalar sem expirar e publicar na
App Store.

Via linha de comando (no Mac):
```bash
flutter build ios --release            # build
flutter build ipa                      # empacota .ipa para distribuir
```

## Windows (para testar no PC)
```bash
flutter run -d windows
flutter build windows --release
```

## Verificação antes de publicar
```bash
flutter analyze        # sem erros
flutter test           # testes passando
```

## Observações
- **Offline-first:** todo o conteúdo (perguntas, palavras, bandeiras, fotos,
  sons) está embutido; o app funciona sem internet.
- **Privacidade (RNF05):** nenhum dado sai do aparelho; sem analytics de
  terceiros. Nada a declarar de coleta de dados na loja além do óbvio.
- **Créditos de imagens:** ver `CREDITOS-IMAGENS.md` (fotos de animais em
  licenças Creative Commons; bandeiras em domínio público).
