import 'package:material_ui/material_ui.dart';

import 'routes.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_service.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    // Sessão salva (US04): se já está logado, abre direto na tela principal.
    final isSignedIn = authService.currentUser != null;

    return MaterialApp(
      title: 'App Etapas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: isSignedIn
          ? HomeScreen(authService: authService)
          : LoginScreen(authService: authService),
      routes: {
        AppRoutes.login: (_) => LoginScreen(authService: authService),
        AppRoutes.register: (_) => RegisterScreen(authService: authService),
        AppRoutes.home: (_) => HomeScreen(authService: authService),
      },
    );
  }
}
