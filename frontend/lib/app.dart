import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schedule_management_frontend/ui/di/di_config.dart';
import 'package:schedule_management_frontend/ui/router/app_router.dart';
import 'package:schedule_management_frontend/ui/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Interna',
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: InternaCrystal.darkTheme,
      routerConfig: appRouter.config(),
    );
  }
}
