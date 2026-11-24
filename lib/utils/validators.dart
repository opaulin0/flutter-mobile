/// Validações dos formulários (usadas no `validator:` dos TextFormField).
/// Cada função devolve a mensagem de erro, ou null se o valor está ok.
class Validators {
  Validators._();

  /// Mínimo exigido pelo Firebase Auth.
  static const minPasswordLength = 6;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) => _emailRegex.hasMatch(value.trim());

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe o nome.';
    if (v.length < 2) return 'Nome muito curto.';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe o e-mail.';
    if (!isValidEmail(v)) return 'E-mail inválido.';
    return null;
  }

  /// Senha no cadastro: obrigatória e com tamanho mínimo.
  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Informe a senha.';
    if (v.length < minPasswordLength) {
      return 'A senha deve ter pelo menos $minPasswordLength caracteres.';
    }
    return null;
  }

  /// Senha no login: só precisa estar preenchida.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha.';
    return null;
  }

  /// Confirmação: compara com o valor atual do campo de senha.
  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Confirme a senha.';
      if (value != original()) return 'As senhas não coincidem.';
      return null;
    };
  }
}
