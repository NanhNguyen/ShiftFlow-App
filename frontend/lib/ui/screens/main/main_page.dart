import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/constant/enums.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import '../../theme/app_theme.dart';
import '../home/home_page.dart';
import '../schedule/schedule_page.dart';
import '../status/status_page.dart';
import '../profile/profile_page.dart';
import '../manager/manager_request_page.dart';
import '../notifications/notification_page.dart';
import '../meal/meal_page.dart';
import '../announcements/announcement_page.dart';
import '../schedule/cubit/schedule_cubit.dart';
import 'cubit/main_cubit.dart';
import 'cubit/main_state.dart';
import '../home/cubit/home_cubit.dart';
import '../notifications/cubit/notification_cubit.dart';
import '../notifications/cubit/notification_state.dart';
import 'widget/in_app_notification_banner.dart';
import '../../../resource/app_strings.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final HomeCubit _homeCubit;
  late final MainCubit _mainCubit;
  late final NotificationCubit _notifCubit;

  late final UserRole _userRole;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final authService = getIt<AuthService>();
    _userRole = authService.currentUser?.role ?? UserRole.INTERN;

    _mainCubit = getIt<MainCubit>()..setIndex(0);
    _homeCubit = getIt<HomeCubit>()..loadData();
    _notifCubit = getIt<NotificationCubit>()..loadNotifications();

    _pages = _getPagesForRole(_userRole);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _mainCubit),
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _notifCubit),
      ],
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, notifState) {
          return BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
              final unreadNotifications = notifState.notifications
                  .where((n) => !n.isRead)
                  .toList();

              final isWideScreen = MediaQuery.of(context).size.width >= 800;
              final currentNavItems = _userRole == UserRole.MANAGER
                  ? _getManagerNavItemsWithBadge(
                      context,
                      unreadNotifications.length,
                    )
                  : _getNavItemsWithBadge(unreadNotifications.length);

              return InAppNotificationOverlay(
                notifications: notifState.notifications,
                unreadCount: unreadNotifications.length,
                child: Scaffold(
                  backgroundColor: InternaCrystal.bgDeep,
                  body: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isWideScreen)
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: InternaCrystal.bgSidebar,
                            border: Border(
                              right: BorderSide(
                                color: InternaCrystal.borderSubtle,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                child: Row(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          InternaCrystal.brandGradient.createShader(bounds),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppStrings.appName,
                                      style: GoogleFonts.inter(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: InternaCrystal.textPrimary,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: InternaCrystal.borderSubtle,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  itemCount: currentNavItems.length,
                                  itemBuilder: (context, index) {
                                    final item = currentNavItems[index];
                                    final isSelected =
                                        _getNavIndexFromPage(
                                          state.currentIndex,
                                        ) ==
                                        index;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 2,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: () {
                                            final pageIndex = _getPageIndexFromNav(index);
                                            _mainCubit.setIndex(pageIndex);
                                            if (_isScheduleIndex(pageIndex)) {
                                              getIt<ScheduleCubit>().loadSchedules(_userRole);
                                              getIt<ScheduleCubit>().resetDate();
                                            }
                                            if (pageIndex == _getNotificationIndex(_userRole)) {
                                              _notifCubit.markAllAsRead();
                                              getIt<HomeCubit>().loadData();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: isSelected
                                                ? BoxDecoration(
                                                    color: InternaCrystal.accentPurple.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: InternaCrystal.accentPurple.withOpacity(0.2),
                                                    ),
                                                  )
                                                : null,
                                            child: Row(
                                              children: [
                                                isSelected
                                                    ? item.activeIcon
                                                    : item.icon,
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    item.label ?? '',
                                                    style: GoogleFonts.inter(
                                                      fontWeight: isSelected
                                                          ? FontWeight.bold
                                                          : FontWeight.w500,
                                                      color: isSelected
                                                          ? InternaCrystal.textPrimary
                                                          : InternaCrystal.textSecondary,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isWideScreen)
                        const SizedBox.shrink(),
                      Expanded(
                        child: IndexedStack(
                          index: state.currentIndex,
                          children: _pages,
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: isWideScreen
                      ? null
                      : Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: InternaCrystal.bgSidebar.withOpacity(0.85),
                                  border: Border.all(
                                    color: InternaCrystal.borderSubtle,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: BottomNavigationBar(
                                  currentIndex: _getNavIndexFromPage(
                                    state.currentIndex,
                                  ),
                                  onTap: (index) {
                                    final pageIndex = _getPageIndexFromNav(index);
                                    _mainCubit.setIndex(pageIndex);
                                    if (_isScheduleIndex(pageIndex)) {
                                      getIt<ScheduleCubit>().loadSchedules(_userRole);
                                      getIt<ScheduleCubit>().resetDate();
                                    }
                                    if (pageIndex == _getNotificationIndex(_userRole)) {
                                      _notifCubit.markAllAsRead();
                                      getIt<HomeCubit>().loadData();
                                    }
                                  },
                                  backgroundColor: Colors.transparent,
                                  type: BottomNavigationBarType.fixed,
                                  selectedItemColor: InternaCrystal.accentPurple,
                                  unselectedItemColor: InternaCrystal.textSecondary,
                                  showSelectedLabels: false,
                                  showUnselectedLabels: false,
                                  elevation: 0,
                                  iconSize: 26,
                                  items: currentNavItems,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _getManagerNavItemsWithBadge(
    BuildContext context,
    int unreadNotifCount,
  ) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: AppStrings.home,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month_outlined),
        activeIcon: Icon(Icons.calendar_month),
        label: AppStrings.schedule,
      ),
      BottomNavigationBarItem(
        icon: _withBadge(Icons.notifications_outlined, unreadNotifCount, active: false),
        activeIcon: _withBadge(Icons.notifications, unreadNotifCount, active: true),
        label: AppStrings.notifications,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: AppStrings.profile,
      ),
    ];
  }

  Widget _withBadge(IconData iconData, int count, {required bool active}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(iconData),
        if (count > 0)
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: InternaCrystal.accentRed,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: InternaCrystal.bgSidebar, width: 1.2),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _getPagesForRole(UserRole role) {
    switch (role) {
      case UserRole.MANAGER:
        return [
          const HomePage(),
          const ManagerRequestPage(),
          const SchedulePage(),
          const NotificationPage(),
          const ProfilePage(),
        ];
      case UserRole.HR:
        return [
          const HomePage(),
          const MealPage(),
          const SchedulePage(),
          const AnnouncementPage(),
          const NotificationPage(),
          const ProfilePage(),
        ];
      case UserRole.INTERN:
      case UserRole.EMPLOYEE:
        return [
          const HomePage(),
          const MealPage(),
          const SchedulePage(),
          const StatusPage(),
          const AnnouncementPage(),
          const NotificationPage(),
          const ProfilePage(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsWithBadge(int unreadCount) {
    switch (_userRole) {
      case UserRole.MANAGER:
        return _getManagerNavItemsWithBadge(context, unreadCount);
      default:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: AppStrings.schedule,
          ),
          BottomNavigationBarItem(
            icon: _withBadge(Icons.notifications_outlined, unreadCount, active: false),
            activeIcon: _withBadge(Icons.notifications, unreadCount, active: true),
            label: AppStrings.notifications,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ];
    }
  }

  int _getPageIndexFromNav(int navIndex) {
    if (navIndex == 0) return 0;
    if (navIndex == 1) return 2;
    if (_userRole == UserRole.MANAGER) {
      if (navIndex == 2) return 3;
      if (navIndex == 3) return 4;
    } else if (_userRole == UserRole.HR) {
      if (navIndex == 2) return 4;
      if (navIndex == 3) return 5;
    } else {
      if (navIndex == 2) return 5;
      if (navIndex == 3) return 6;
    }
    return 0;
  }

  int _getNavIndexFromPage(int pageIndex) {
    if (pageIndex == 0) return 0;
    if (pageIndex == 2) return 1;
    if (_userRole == UserRole.MANAGER) {
      if (pageIndex == 3) return 2;
      if (pageIndex == 4) return 3;
    } else if (_userRole == UserRole.HR) {
      if (pageIndex == 4) return 2;
      if (pageIndex == 5) return 3;
    } else {
      if (pageIndex == 5) return 2;
      if (pageIndex == 6) return 3;
    }
    return 0;
  }

  bool _isScheduleIndex(int index) => index == 2;

  int _getNotificationIndex([UserRole? role]) {
    final r = role ?? _userRole;
    if (r == UserRole.MANAGER) return 3;
    if (r == UserRole.HR) return 4;
    return 5;
  }
}
