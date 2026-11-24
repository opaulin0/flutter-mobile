import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  // Necessário antes de usar plugins (SharedPreferences) no main.
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.create();
  runApp(App(authService: authService));
}
