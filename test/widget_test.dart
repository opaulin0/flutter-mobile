import 'package:app_etapas/app.dart';
import 'package:app_etapas/services/auth_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('cadastro leva à tela principal com drawer', (tester) async {
    final auth = await AuthService.create();
    await tester.pumpWidget(App(authService: auth));

    // Sem sessão: abre no login.
    expect(find.text('Acesse com seu e-mail e senha'), findsOneWidget);

    await tester.tap(find.text('Não tem conta? Cadastre-se'));
    await tester.pumpAndSettle();
    expect(find.text('Crie sua conta'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ana');
    await tester.enterText(fields.at(1), 'ana@email.com');
    await tester.enterText(fields.at(2), '123456');
    await tester.enterText(fields.at(3), '123456');
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    // Tela principal em branco, com o menu lateral.
    expect(find.widgetWithText(AppBar, 'Início'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('ana@email.com'), findsOneWidget);

    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.text('Acesse com seu e-mail e senha'), findsOneWidget);
  });
}
