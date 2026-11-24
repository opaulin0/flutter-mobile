import 'package:app_etapas/services/auth_exception.dart';
import 'package:app_etapas/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthService auth;

  setUp(() async {
    // SharedPreferences em memória, zerado a cada teste.
    SharedPreferences.setMockInitialValues({});
    auth = await AuthService.create();
  });

  Matcher throwsAuth(String code) => throwsA(
      isA<AuthException>().having((e) => e.code, 'code', code));

  test('cadastro cria o usuário e já deixa logado', () async {
    final user = await auth.createUserWithEmailAndPassword(
      displayName: 'Ana',
      email: ' Ana@Email.com ',
      password: '123456',
    );

    expect(user.email, 'ana@email.com');
    expect(user.uid, hasLength(28));
    expect(auth.currentUser?.uid, user.uid);
  });

  test('novo cadastro substitui o anterior', () async {
    await auth.createUserWithEmailAndPassword(
        displayName: 'Ana', email: 'ana@email.com', password: '123456');
    await auth.createUserWithEmailAndPassword(
        displayName: 'Bia', email: 'bia@email.com', password: 'abcdef');
    await auth.signOut();

    await expectLater(
      auth.signInWithEmailAndPassword(email: 'ana@email.com', password: '123456'),
      throwsAuth('invalid-credential'),
    );
    final user = await auth.signInWithEmailAndPassword(
        email: 'bia@email.com', password: 'abcdef');
    expect(user.displayName, 'Bia');
  });

  test('senha errada gera invalid-credential', () async {
    await auth.createUserWithEmailAndPassword(
        displayName: 'Ana', email: 'ana@email.com', password: '123456');
    await auth.signOut();

    await expectLater(
      auth.signInWithEmailAndPassword(email: 'ana@email.com', password: 'errada'),
      throwsAuth('invalid-credential'),
    );
  });

  test('e-mail inválido e senha fraca são recusados', () async {
    await expectLater(
      auth.createUserWithEmailAndPassword(
          displayName: 'Ana', email: 'ana', password: '123456'),
      throwsAuth('invalid-email'),
    );
    await expectLater(
      auth.createUserWithEmailAndPassword(
          displayName: 'Ana', email: 'ana@email.com', password: '123'),
      throwsAuth('weak-password'),
    );
  });

  test('sair mantém o cadastro e a sessão persiste entre aberturas', () async {
    await auth.createUserWithEmailAndPassword(
        displayName: 'Ana', email: 'ana@email.com', password: '123456');

    // "Reabrir o app": nova instância lendo o mesmo SharedPreferences.
    expect((await AuthService.create()).currentUser?.email, 'ana@email.com');

    await auth.signOut();
    expect((await AuthService.create()).currentUser, isNull);

    final user = await auth.signInWithEmailAndPassword(
        email: 'ana@email.com', password: '123456');
    expect(user.displayName, 'Ana');
  });

  test('a senha não fica salva em texto puro', () async {
    await auth.createUserWithEmailAndPassword(
        displayName: 'Ana', email: 'ana@email.com', password: 'segredo123');

    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      expect('${prefs.get(key)}', isNot(contains('segredo123')));
    }
  });
}
