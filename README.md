
# Reconhecimento de Voz Flutter

Projeto Flutter para reconhecer comandos de voz em português.

## Comandos reconhecidos
- cima
- baixo
- esquerdo
- direito
- ligado
- desligado

## Bibliotecas utilizadas
- [flutter/material.dart](https://api.flutter.dev/flutter/material/material-library.html) — Interface gráfica
- [speech_to_text](https://pub.dev/packages/speech_to_text) — Reconhecimento de voz

## Como rodar o projeto

1. **Pré-requisitos:**
	- Flutter instalado ([guia oficial](https://docs.flutter.dev/get-started/install))
	- Dispositivo físico ou emulador configurado

2. **Clone o repositório:**
	```sh
	git clone <url-do-seu-repositorio>
	cd comando_de_voz
	```

3. **Instale as dependências:**
	```sh
	flutter pub get
	```

4. **Execute o app:**
	```sh
	flutter run
	```

5. **Como usar:**
	- Pressione o botão do microfone na tela.
	- Fale um dos comandos reconhecidos.
	- O comando reconhecido será exibido na tela.

## Observações
- Para melhor funcionamento, teste em um dispositivo físico.
- O reconhecimento depende da clareza da fala e do microfone.

## Adicionar imagens dos comandos ✅
Para que a interface mostre uma imagem ao reconhecer um comando, crie a pasta `assets/images` na raiz do projeto e adicione imagens com os nomes abaixo (pode ser PNG ou JPG):

- `assets/images/cima.png`
- `assets/images/baixo.png`
- `assets/images/esquerda.png`
- `assets/images/direita.png`
- `assets/images/ligado.png`
- `assets/images/desligado.png`
- `assets/images/idle.png` (imagem padrão)
- `assets/images/unknown.png` (quando não reconhecer)

Depois rode:
```sh
flutter pub get
flutter run
```

---
