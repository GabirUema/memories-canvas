# MemoriesCanvas

Um app de diário visual feito em Flutter pra guardar momentos, viagens e
eventos marcantes com foto, título, descrição e data.

A graça do projeto é que ele não usa banco de dados nem SharedPreferences.
A persistência é toda na mão: a lista de memórias é salva num arquivo
`memories.json` e as fotos são copiadas pra uma pasta dentro do próprio app.

## O que dá pra fazer

- Ver todas as memórias num feed com foto, título e data
- Cadastrar uma memória nova escolhendo a foto da galeria (com preview antes de salvar)
- Abrir uma memória pra ver a foto grande e a descrição completa
- Excluir uma memória (some do JSON e a foto também é apagada do aparelho)

Quando ainda não tem nada salvo, aparece uma mensagem simpática convidando
a criar a primeira memória.

## Organização das pastas

```
lib/
  main.dart                      -> tema (roxo lilás + verde) e início do app
  models/memory.dart             -> a classe Memory + toJson/fromJson
  services/memory_storage.dart   -> salva/lê o JSON e cuida das imagens
  screens/
    home_screen.dart             -> tela 1: feed
    add_memory_screen.dart       -> tela 2: cadastro
    memory_detail_screen.dart    -> tela 3: detalhes
  widgets/
    memory_card.dart             -> o card de cada item do feed
    empty_state.dart             -> mensagem de feed vazio
  utils/date_formatter.dart      -> formata as datas em português
```

## Como rodar

Esse repositório tem só o código (a pasta `lib/`, o `pubspec.yaml` e os
testes). As pastas `android/`, `ios/` etc. são geradas pelo Flutter, então
depois de baixar é só rodar:

```bash
flutter create .     # gera android/ios/web sem mexer no lib/
flutter pub get
flutter run
```

No iOS, pra galeria funcionar, adicione no `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>O app precisa acessar suas fotos pra criar as memórias.</string>
```

No Android as versões novas do image_picker não precisam de permissão extra.

## Testes

```bash
flutter test
```

## Pacotes usados

- image_picker — pegar foto da galeria
- path_provider — achar a pasta de documentos do app
- path — montar os caminhos dos arquivos
- intl — formatar as datas em pt-BR
