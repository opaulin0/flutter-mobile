# App Etapas

Aplicativo Flutter com cadastro e login de usuários, construído por etapas.
A autenticação segue o modelo do **Firebase Auth (e-mail e senha)**; por enquanto os dados ficam no aparelho com **SharedPreferences**.

**Aluno:** Paulo Ricardo de Almeida — RA 60003496

📄 Requisitos e histórias de usuário: [Wiki do projeto](../../wiki/Historias-de-Usuario)

---

## Como executar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart 3.5 ou mais novo).

```bash
# 1. Gerar as pastas de plataforma (android, ios, web...). Arquivos existentes não são sobrescritos.
flutter create . --project-name app_etapas --platforms android,ios,web,windows

# 2. Baixar dependências
flutter pub get

# 3. Rodar
flutter run

# Testes e análise
flutter test
flutter analyze
```

## Estrutura

```
lib/
├── main.dart                  # inicializa o SharedPreferences e abre o app
├── app.dart                   # MaterialApp, tema e rotas; decide login ou home
├── routes.dart                # nomes das rotas
├── models/app_user.dart       # usuário com os campos do User do Firebase
├── services/
│   ├── auth_service.dart      # cadastro, login, logout (API igual ao FirebaseAuth)
│   └── auth_exception.dart    # erros com os códigos do Firebase
├── utils/validators.dart      # validações dos formulários
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── home_screen.dart       # tela principal (em branco)
└── widgets/app_drawer.dart    # menu lateral
test/                          # testes do serviço, validações e fluxo de telas
```

---

## Etapa 1 – Base do projeto, login e cadastro

**Tag:** `etapa-1`

### O que foi feito
- Projeto Flutter criado, com Material 3 e lints.
- Tela de **login** (e-mail e senha, mostrar/ocultar senha, link para cadastro).
- Tela de **cadastro** (nome, e-mail, senha e confirmação).
- Validações iguais às regras do Firebase Auth: e-mail válido e senha com no mínimo 6 caracteres.
- `AuthService` com os mesmos métodos do `FirebaseAuth` (`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `signOut`, `currentUser`) e erros com os mesmos códigos (`invalid-email`, `weak-password`, `invalid-credential`).
- Levantamento de requisitos e histórias de usuário (US01 a US06) na Wiki.

### Prints
| Login | Cadastro |
|---|---|
| ![Login](docs/prints/etapa1-login.png) | ![Cadastro](docs/prints/etapa1-cadastro.png) |

### Vídeo
▶️ _link do YouTube (não listado)_

### Declaração de uso de IA
> _Preencha com as suas palavras. Exemplo de estrutura:_
>
> - **Usei IA?** Sim / Não.
> - **Para quê?** …
> - **O que ela sugeriu?** …
> - **O que alterei ou aprendi?** …

---

## Etapa 2 – SharedPreferences e drawer navigation

**Tag:** `etapa-2`

### O que foi feito
- Dados do usuário salvos com **SharedPreferences** (em JSON). Como esse armazenamento é limitado, só existe **um** usuário: **cada cadastro substitui o anterior** (a tela de cadastro avisa isso).
- A senha **não** é salva: guardamos o hash SHA-256 com um salt aleatório.
- Sessão mantida: ao reabrir o app logado, ele abre direto na tela principal.
- **Drawer navigation** com nome, e-mail e inicial do usuário e os itens Início, Sobre e Sair.
- Tela principal **em branco**, pronta para as próximas etapas.
- Testes automatizados do serviço, das validações e do fluxo cadastro → home → sair.

### Prints
| Tela principal | Drawer |
|---|---|
| ![Home](docs/prints/etapa2-home.png) | ![Drawer](docs/prints/etapa2-drawer.png) |

### Vídeo
▶️ _link do YouTube (não listado)_

### Declaração de uso de IA
> - **Usei IA?** …
> - **Para quê?** …
> - **O que ela sugeriu?** …
> - **O que alterei ou aprendi?** …
