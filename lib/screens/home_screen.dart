import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import '../widgets/app_drawer.dart';

/// Tela principal. Fica em branco por enquanto; o conteúdo vem nas
/// próximas etapas. A navegação é pelo drawer (menu lateral).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: AppDrawer(authService: authService),
      body: const SizedBox.expand(),
    );
  }
}
