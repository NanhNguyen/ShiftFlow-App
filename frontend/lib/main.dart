import 'package:flutter/material.dart';
import 'data/service/auth_service.dart';
import 'ui/di/di_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  configureDependencies();

  // Attempt to restore user session before running the app
  await getIt<AuthService>().initialize();

  runApp(const App());
}
