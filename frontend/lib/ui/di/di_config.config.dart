// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:schedule_management_frontend/data/api/api_client.dart' as _i514;
import 'package:schedule_management_frontend/data/api/auth_api.dart' as _i161;
import 'package:schedule_management_frontend/data/api/notification_api.dart'
    as _i450;
import 'package:schedule_management_frontend/data/repo/auth_repo.dart'
    as _i1072;
import 'package:schedule_management_frontend/data/repo/auth_repo_impl.dart'
    as _i211;
import 'package:schedule_management_frontend/data/repo/notification_repo.dart'
    as _i479;
import 'package:schedule_management_frontend/data/repo/notification_repo_impl.dart'
    as _i262;
import 'package:schedule_management_frontend/data/repo/schedule_repo_impl.dart'
    as _i168;
import 'package:schedule_management_frontend/data/repo/schedule_request_repo.dart'
    as _i611;
import 'package:schedule_management_frontend/data/service/auth_service.dart'
    as _i258;
import 'package:schedule_management_frontend/foundation/storage/token_storage.dart'
    as _i220;
import 'package:schedule_management_frontend/ui/router/app_router.dart'
    as _i951;
import 'package:schedule_management_frontend/ui/screens/home/cubit/home_cubit.dart'
    as _i360;
import 'package:schedule_management_frontend/ui/screens/login/cubit/login_cubit.dart'
    as _i458;
import 'package:schedule_management_frontend/ui/screens/main/cubit/main_cubit.dart'
    as _i771;
import 'package:schedule_management_frontend/ui/screens/manager/cubit/manager_requests_cubit.dart'
    as _i359;
import 'package:schedule_management_frontend/ui/screens/notifications/cubit/notification_cubit.dart'
    as _i343;
import 'package:schedule_management_frontend/ui/screens/profile/cubit/profile_cubit.dart'
    as _i158;
import 'package:schedule_management_frontend/ui/screens/schedule/cubit/schedule_cubit.dart'
    as _i674;
import 'package:schedule_management_frontend/ui/screens/schedule_form/cubit/schedule_form_cubit.dart'
    as _i500;
import 'package:schedule_management_frontend/ui/screens/status/cubit/status_cubit.dart'
    as _i262;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i771.MainCubit>(() => _i771.MainCubit());
    gh.lazySingleton<_i220.TokenStorage>(() => _i220.TokenStorage());
    gh.lazySingleton<_i951.AppRouter>(() => _i951.AppRouter());
    gh.lazySingleton<_i514.ApiClient>(
      () => _i514.ApiClient(gh<_i220.TokenStorage>()),
    );
    gh.lazySingleton<_i161.AuthApi>(() => _i161.AuthApi(gh<_i514.ApiClient>()));
    gh.lazySingleton<_i450.NotificationApi>(
      () => _i450.NotificationApi(gh<_i514.ApiClient>()),
    );
    gh.lazySingleton<_i611.ScheduleRequestRepo>(
      () => _i168.ScheduleRepoImpl(gh<_i514.ApiClient>()),
    );
    gh.lazySingleton<_i479.NotificationRepo>(
      () => _i262.NotificationRepoImpl(gh<_i450.NotificationApi>()),
    );
    gh.factory<_i343.NotificationCubit>(
      () => _i343.NotificationCubit(gh<_i479.NotificationRepo>()),
    );
    gh.lazySingleton<_i1072.AuthRepo>(
      () => _i211.AuthRepoImpl(gh<_i161.AuthApi>(), gh<_i220.TokenStorage>()),
    );
    gh.lazySingleton<_i258.AuthService>(
      () => _i258.AuthService(gh<_i1072.AuthRepo>(), gh<_i220.TokenStorage>()),
    );
    gh.factory<_i674.ScheduleCubit>(
      () => _i674.ScheduleCubit(gh<_i611.ScheduleRequestRepo>()),
    );
    gh.factory<_i262.StatusCubit>(
      () => _i262.StatusCubit(gh<_i611.ScheduleRequestRepo>()),
    );
    gh.factory<_i500.ScheduleFormCubit>(
      () => _i500.ScheduleFormCubit(gh<_i611.ScheduleRequestRepo>()),
    );
    gh.factory<_i359.ManagerRequestsCubit>(
      () => _i359.ManagerRequestsCubit(gh<_i611.ScheduleRequestRepo>()),
    );
    gh.factory<_i158.ProfileCubit>(
      () => _i158.ProfileCubit(gh<_i258.AuthService>()),
    );
    gh.factory<_i458.LoginCubit>(
      () => _i458.LoginCubit(gh<_i258.AuthService>()),
    );
    gh.factory<_i360.HomeCubit>(
      () => _i360.HomeCubit(
        gh<_i258.AuthService>(),
        gh<_i611.ScheduleRequestRepo>(),
        gh<_i479.NotificationRepo>(),
      ),
    );
    return this;
  }
}
