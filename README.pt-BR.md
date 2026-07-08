# Flutter Shop

[Read in English](./README.md)

[![Licença: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE) ![Grátis](https://img.shields.io/badge/price-free-brightgreen)

O Flutter Shop é um template gratuito de e-commerce feito com Flutter 3.44 e Material 3. Ele implementa uma loja com fluxo de compra da vitrine até a confirmação do pedido em 9 telas: grid de produtos com busca e categorias, página de produto com seletores de tamanho e cor, carrinho com cupom, checkout com endereço e pagamento, confirmação, navegação por categorias, busca com filtros, favoritos e perfil com histórico de pedidos. Os dados vêm de uma camada de serviço mockada, então o app roda sem backend; as classes de repositório e serviço indicam onde uma API real se encaixa.

## Telas

9 telas. Cinco delas são abas dentro do `HomeShell` (uma `NavigationBar` do Material 3 com badge na aba do carrinho); as demais são rotas empilhadas do go_router:

- Loja (aba inicial): vitrine com campo de busca, atalhos de categoria e o grid de produtos.
- Produto (`/product/:id`): página de produto com seletores de tamanho e cor e barra fixa de adicionar ao carrinho.
- Carrinho (aba): itens, campo de cupom e resumo do pedido.
- Checkout (`/checkout`): formulário de endereço e pagamento.
- Confirmação (`/confirmation`): tela de pedido realizado.
- Categorias (aba): lista de categorias para navegar no catálogo.
- Busca (`/search`): busca com filtros.
- Favoritos (aba): produtos salvos.
- Perfil (aba): dados da conta e histórico de pedidos.

## Capturas de tela

A pasta `screenshots/` contém 18 PNGs: uma captura clara e uma escura de cada tela, geradas por `test/print_test.dart`. Uma amostra:

![Loja](screenshots/ecommerce.png)
![Produto](screenshots/ecommerce-2.png)
![Carrinho](screenshots/ecommerce-3.png)
![Checkout](screenshots/ecommerce-4.png)
![Confirmação](screenshots/ecommerce-5.png)
![Categorias](screenshots/ecommerce-6.png)

## Stack

| Pacote | Versão |
| --- | --- |
| Flutter | 3.44 (stable) |
| Dart SDK | `^3.12.2` |
| go_router | `^17.3.0` |
| provider | `^6.1.5+1` |
| http | `^1.6.0` |
| intl | `^0.20.3` |
| cupertino_icons | `^1.0.8` |
| flutter_lints (dev) | `^6.0.0` |

O Material 3 é habilitado via `useMaterial3: true` com esquema de cores baseado em seed.

## Requisitos

- Flutter SDK, canal stable. O template foi construído com Flutter 3.44; o `pubspec.lock` resolve com Flutter 3.38.0 ou mais novo e Dart `>=3.12.2 <4.0.0`.
- Sem backend, chaves de API ou variáveis de ambiente.
- As toolchains de cada plataforma que você for compilar: Android SDK para APKs, Xcode no macOS para iOS, Chrome para web, Visual Studio com o workload de C++ para Windows. O repositório inclui as pastas `android/`, `ios/`, `web/` e `windows/`.

## Como rodar

```bash
flutter pub get
flutter run
```

O `flutter run` usa o dispositivo conectado. Liste os alvos com `flutter devices` e escolha um com `-d`, por exemplo `flutter run -d chrome` para web ou `flutter run -d windows` para desktop.

## Builds

```bash
flutter build apk        # Android
flutter build ipa        # iOS (requer macOS e Xcode)
flutter build web        # saída web em build/web
flutter build windows    # desktop Windows
```

## Testes

`flutter test` executa os testes de widget em `test/widget_test.dart`. O `test/print_test.dart` (com utilitários em `test/golden_utils.dart`) renderiza cada tela nos dois temas e grava os PNGs em `screenshots/`.

## Estrutura do projeto

```
lib/
  main.dart                 # ponto de entrada
  app.dart                  # MaterialApp.router com temas claro e escuro
  core/
    router.dart             # tabela de rotas do go_router (shell + rotas empilhadas)
    theme.dart              # AppTheme: cor seed e temas de componentes
  data/
    models/                 # modelos de API com fromJson/toJson
    services/               # ShopApiService via http (mockado)
    repositories/           # ShopRepository consumido pelos view models
  domain/
    models/                 # Product, CartItem, Order, ShopCategory
  ui/
    core/widgets/           # widgets compartilhados
    features/home/          # HomeShell com a NavigationBar de 5 abas
    features/<feature>/
      views/                # uma tela por feature
      view_models/          # view models ChangeNotifier (MVVM)
```

## Arquitetura e gerenciamento de estado

O código segue arquitetura em camadas (data, domain, ui) com MVVM. Cada tela tem um view model `ChangeNotifier` injetado via `provider`; os view models chamam o `ShopRepository`, que converte os modelos de API da camada de serviço em modelos de domínio. A navegação é declarativa com go_router: `/` renderiza o `HomeShell` com as cinco abas, enquanto produto, busca, checkout e confirmação são empilhadas por cima.

## Tema e customização

O tema está centralizado em `lib/core/theme.dart`. As cores derivam de uma única cor seed (`AppTheme.seed`, `0xFFF2601A`); troque essa cor e o `ColorScheme.fromSeed` regenera as paletas clara e escura. O mesmo arquivo define a fonte (Roboto) e os temas de componentes de botões, inputs e cards. O app segue o brilho do sistema porque o `app.dart` passa `theme` e `darkTheme` ao `MaterialApp.router`. Os preços são formatados com `intl`.

## Mais templates

Este template faz parte do catálogo em https://template.dev.br, que lista os templates gratuitos e pagos com previews.

## Apoie o projeto

As doações mantêm os templates gratuitos atualizados e compatíveis com as novas versões do Flutter. Se este template foi útil para você, contribua com qualquer valor em https://template.dev.br/doar?template=flutter-ecommerce.

## Licença

MIT, veja [LICENSE](./LICENSE). Copyright 2026 Danilo Quinelato.
