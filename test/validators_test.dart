import 'package:app_etapas/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('e-mail', () {
    expect(Validators.email(''), 'Informe o e-mail.');
    expect(Validators.email('ana@'), 'E-mail inválido.');
    expect(Validators.email('ana@email.com'), isNull);
  });

  test('senha do cadastro exige 6 caracteres', () {
    expect(Validators.newPassword(''), 'Informe a senha.');
    expect(Validators.newPassword('12345'), isNotNull);
    expect(Validators.newPassword('123456'), isNull);
  });

  test('confirmação precisa ser igual à senha', () {
    final validator = Validators.confirmPassword(() => '123456');
    expect(validator('654321'), 'As senhas não coincidem.');
    expect(validator('123456'), isNull);
  });

  test('nome', () {
    expect(Validators.name(' '), 'Informe o nome.');
    expect(Validators.name('Ana'), isNull);
  });
}
