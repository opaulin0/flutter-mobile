/// Erro de autenticação. Usa os mesmos códigos do FirebaseAuthException.
class AuthException implements Exception {
  const AuthException(this.code);

  final String code;

  String get message => switch (code) {
        'invalid-email' => 'O e-mail informado é inválido.',
        'weak-password' => 'A senha deve ter pelo menos 6 caracteres.',
        'invalid-credential' => 'E-mail ou senha incorretos.',
        _ => 'Ocorreu um erro inesperado. Tente novamente.',
      };

  @override
  String toString() => 'AuthException($code): $message';
}
