# Recursos do Dispositivo — Aulas 14 e 15

Aplicativo Flutter que reúne as atividades práticas de **Geolocalização e GPS (Aula 14)** e **Câmera e Galeria de Mídia (Aula 15)**.

## Funcionalidades

### Aula 14 — Geolocalização e GPS
- Verifica se o serviço de localização está ativado.
- Solicita e trata permissões de localização.
- Captura latitude, longitude, altitude e precisão.
- Exibe um indicador de precisão:
  - Verde: abaixo de 15 m.
  - Amarelo: de 15 m a 50 m.
  - Vermelho: acima de 50 m.
- Permite iniciar e parar o rastreamento contínuo com `getPositionStream()`.

### Aula 15 — Câmera e Galeria
- Captura uma foto com a câmera usando `image_picker`.
- Seleciona uma imagem da galeria.
- Exibe a foto em `CircleAvatar`.
- Permite remover a foto.
- Abre a imagem em tela cheia com animação `Hero` e zoom.
- Persiste o caminho da foto com `SharedPreferences`.

## Requisitos
- Flutter SDK instalado.
- Android Studio ou VS Code com extensão Flutter.
- Emulador Android com localização configurada ou aparelho físico.
- Para testar câmera, prefira um aparelho físico ou emulador com câmera virtual configurada.

## Como executar

1. Crie um projeto Flutter vazio:
   ```bash
   flutter create recursos_dispositivo
   ```
2. Copie para o projeto os arquivos e pastas deste repositório, substituindo `pubspec.yaml` e a pasta `lib`.
3. No `android/app/src/main/AndroidManifest.xml`, inclua as permissões mostradas em `android/app/src/main/AndroidManifest.xml.example` dentro da tag `<manifest>`. Preserve a estrutura gerada pelo Flutter.
4. No iOS, inclua as chaves de privacidade indicadas em `ios/Runner/Info.plist.additions` dentro do `<dict>` principal.
5. Execute:
   ```bash
   flutter pub get
   flutter run
   ```

## Estrutura

```text
lib/
  main.dart
  screens/
    home_screen.dart
    geolocalizacao_screen.dart
    perfil_screen.dart
  services/
    location_service.dart
    media_service.dart
```

## Dependências principais
- `geolocator: ^11.0.0`
- `image_picker: ^1.1.0`
- `shared_preferences: ^2.2.3`

## Observações
- A localização depende do GPS/serviço de localização do aparelho e da autorização do usuário.
- A câmera e a galeria dependem das permissões do sistema operacional.
- O caminho salvo por `SharedPreferences` aponta para um arquivo local do dispositivo. Se o arquivo deixar de existir, o aplicativo volta a exibir o avatar padrão.
- O projeto contém os fontes e os arquivos de configuração necessários para integrar ao esqueleto criado por `flutter create`; ele não inclui os arquivos nativos gerados automaticamente pelo Flutter.
