// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:schedule_management_frontend/ui/screens/login/login_page.dart'
    as _i1;
import 'package:schedule_management_frontend/ui/screens/main/main_page.dart'
    as _i2;
import 'package:schedule_management_frontend/ui/screens/manager/manager_request_page.dart'
    as _i3;
import 'package:schedule_management_frontend/ui/screens/notifications/notification_page.dart'
    as _i4;
import 'package:schedule_management_frontend/ui/screens/schedule_form/schedule_form_page.dart'
    as _i5;

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginPage();
    },
  );
}

/// generated route for
/// [_i2.MainPage]
class MainRoute extends _i6.PageRouteInfo<void> {
  const MainRoute({List<_i6.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.MainPage();
    },
  );
}

/// generated route for
/// [_i3.ManagerRequestPage]
class ManagerRequestRoute extends _i6.PageRouteInfo<void> {
  const ManagerRequestRoute({List<_i6.PageRouteInfo>? children})
    : super(ManagerRequestRoute.name, initialChildren: children);

  static const String name = 'ManagerRequestRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.ManagerRequestPage();
    },
  );
}

/// generated route for
/// [_i4.NotificationPage]
class NotificationRoute extends _i6.PageRouteInfo<void> {
  const NotificationRoute({List<_i6.PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.NotificationPage();
    },
  );
}

/// generated route for
/// [_i5.ScheduleFormPage]
class ScheduleFormRoute extends _i6.PageRouteInfo<void> {
  const ScheduleFormRoute({List<_i6.PageRouteInfo>? children})
    : super(ScheduleFormRoute.name, initialChildren: children);

  static const String name = 'ScheduleFormRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.ScheduleFormPage();
    },
  );
}
