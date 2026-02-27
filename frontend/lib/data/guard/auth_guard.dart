import 'package:auto_route/auto_route.dart';
import 'package:schedule_management_frontend/data/service/auth_service.dart';
import 'package:schedule_management_frontend/ui/di/di_config.dart';
import 'package:schedule_management_frontend/ui/router/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = getIt<AuthService>();
    if (authService.isAuthenticated) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
