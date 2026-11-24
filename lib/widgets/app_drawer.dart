import 'package:material_ui/material_ui.dart';

import '../routes.dart';
import '../services/auth_service.dart';

/// Menu lateral (drawer navigation) com os dados do usuário logado.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.authService});

  final AuthService authService;

  Future<void> _signOut(BuildContext context) async {
    // Guarda o Navigator antes do await para não usar o context depois.
    final navigator = Navigator.of(context);
    await authService.signOut();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    final name = user?.displayName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(initial, style: const TextStyle(fontSize: 28)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Início'),
            selected: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.of(context).pop();
              showAboutDialog(
                context: context,
                applicationName: 'App Etapas',
                applicationVersion: '1.0.0',
                children: const [
                  Text('Aplicativo com cadastro e login construído por etapas.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
