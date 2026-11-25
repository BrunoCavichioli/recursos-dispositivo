# Recursos do Dispositivo — Aulas 14 e 15

Aplicativo Flutter das atividades práticas de **Geolocalização e GPS (Aula 14)** e **Câmera e Galeria de Mídia (Aula 15)**.

## Funcionalidades implementadas

### Aula 14 — Geolocalização e GPS
- Verifica se o serviço de localização está ativado.
- Solicita permissões e trata os estados negado e negado permanentemente.
- Captura latitude, longitude, altitude e precisão.
- Exibe indicador visual de precisão: verde (< 15 m), amarelo (15–50 m) e vermelho (> 50 m).
- Inicia e interrompe rastreamento contínuo com `getPositionStream()`.

### Aula 15 — Câmera e Galeria
- Captura foto com a câmera e seleciona imagem da galeria usando `image_picker`.
- Exibe imagem com `CircleAvatar` e avatar padrão.
- Permite remover a foto.
- Abre a imagem em tela cheia com transição Hero e zoom.
- Salva nome e caminho da imagem com `SharedPreferences`.

## Dependências
- `geolocator: ^11.0.0`
- `image_picker: ^1.1.0`
- `shared_preferences: ^2.2.3`

## Estrutura versionada
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
android/app/src/main/AndroidManifest.xml
ios/Runner/Info.plist.additions
```

## Como preparar e executar

**Importante:** este repositório versiona o código Dart, as dependências e as configurações de permissões. Os arquivos de plataforma gerados automaticamente pelo Flutter (Gradle, wrapper Android, projeto Xcode/iOS, ícones e classes nativas) ainda precisam ser criados pelo Flutter SDK no ambiente de desenvolvimento.

1. Instale o Flutter SDK e configure um emulador ou conecte um aparelho.
2. Na pasta clonada do repositório, gere os arquivos nativos do projeto:
   ```bash
   flutter create --platforms=android,ios .
   ```
3. Confira se o arquivo `android/app/src/main/AndroidManifest.xml` mantém as permissões `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` e `CAMERA`. O manifesto de referência está versionado neste repositório.
4. No iOS, adicione ao `ios/Runner/Info.plist` as chaves de privacidade contidas em `ios/Runner/Info.plist.additions`.
5. Instale as dependências e verifique o código:
   ```bash
   flutter pub get
   flutter analyze
   flutter run
   ```

## Testes manuais recomendados
- GPS desligado: confirmar a mensagem informativa.
- Permissão de localização negada: confirmar o tratamento da negativa.
- GPS ligado: capturar latitude, longitude, altitude e precisão.
- Rastreamento: iniciar, movimentar o aparelho e interromper.
- Câmera: tirar uma foto e conferir o avatar.
- Galeria: selecionar uma imagem.
- Remoção: remover a foto e conferir o avatar padrão.
- Persistência: fechar e reabrir o app e conferir se a foto e o nome continuam salvos.
- Tela cheia: tocar na foto e testar o zoom.

## Desafios escolhidos
- **Aula 14:** desafio básico — medidor de precisão por cores.
- **Aula 15:** desafios básico, intermediário e avançado — remoção/reset, visualização em tela cheia com zoom e persistência com SharedPreferences.

## Observações
- O GPS depende do serviço de localização e da autorização do usuário.
- O acesso à câmera e à galeria depende das permissões do sistema operacional.
- O caminho persistido aponta para um arquivo local do dispositivo; se o arquivo for removido pelo sistema, o app volta ao avatar padrão.
- Não afirmamos que os testes em dispositivo foram executados: eles devem ser realizados no ambiente com Flutter SDK e hardware/emulador disponível.
