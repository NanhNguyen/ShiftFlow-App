import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/constant/enums.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import '../home/home_page.dart';
import '../schedule/schedule_page.dart';
import '../status/status_page.dart';
import '../profile/profile_page.dart';
import '../manager/manager_request_page.dart';
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
  late final List<BottomNavigationBarItem> _navItems;
  late final Color _selectedColor;

  @override
  void initState() {
    super.initState();
    final authService = getIt<AuthService>();
    _userRole = authService.currentUser?.role ?? UserRole.INTERN;

    _mainCubit = getIt<MainCubit>()..setIndex(0); // always start at Home tab
    _homeCubit = getIt<HomeCubit>()..loadData();
    _notifCubit = getIt<NotificationCubit>()..loadNotifications();

    _pages = _getPagesForRole(_userRole);
    _navItems = _getNavItemsForRole(_userRole);
    _selectedColor = _getColorForRole(_userRole);
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
                  ? _getManagerNavItemsWithBadge(context)
                  : _navItems;

              return InAppNotificationOverlay(
                notifications: notifState.notifications,
                unreadCount: unreadNotifications.length,
                child: Scaffold(
                  body: Row(
                    children: [
                      if (isWideScreen)
                        NavigationRail(
                          selectedIndex: state.currentIndex,
                          onDestinationSelected: (index) {
                            _mainCubit.setIndex(index);
                            if ((_userRole == UserRole.INTERN && index == 1) ||
                                (_userRole == UserRole.MANAGER && index == 2) ||
                                (_userRole == UserRole.HR && index == 1)) {
                              getIt<ScheduleCubit>().loadSchedules(_userRole);
                            }
                          },
                          labelType: NavigationRailLabelType.all,
                          selectedIconTheme: IconThemeData(
                            color: _selectedColor,
                            size: 30,
                          ),
                          unselectedIconTheme: const IconThemeData(
                            color: Colors.grey,
                            size: 30,
                          ),
                          selectedLabelTextStyle: TextStyle(
                            color: _selectedColor,
                            fontWeight: FontWeight.bold,
                          ),
                          destinations: currentNavItems
                              .map(
                                (item) => NavigationRailDestination(
                                  icon: item.icon,
                                  selectedIcon: item.activeIcon,
                                  label: Text(item.label ?? ''),
                                ),
                              )
                              .toList(),
                        ),
                      if (isWideScreen)
                        const VerticalDivider(thickness: 1, width: 1),
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
                      : BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) {
                            _mainCubit.setIndex(index);
                            if ((_userRole == UserRole.INTERN && index == 1) ||
                                (_userRole == UserRole.MANAGER && index == 2) ||
                                (_userRole == UserRole.HR && index == 1)) {
                              getIt<ScheduleCubit>().loadSchedules(_userRole);
                            }
                          },
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: _selectedColor,
                          unselectedItemColor: Colors.grey,
                          iconSize: 30,
                          selectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(fontSize: 13),
                          items: currentNavItems,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Build manager nav items with live pending-request badge on tab 1.
  List<BottomNavigationBarItem> _getManagerNavItemsWithBadge(
    BuildContext context,
  ) {
    final pendingCount = context.watch<HomeCubit>().state.pendingCount;
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: AppStrings.home,
      ),
      BottomNavigationBarItem(
        icon: _withBadge(
          Icons.admin_panel_settings_outlined,
          pendingCount,
          active: false,
        ),
        activeIcon: _withBadge(
          Icons.admin_panel_settings,
          pendingCount,
          active: true,
        ),
        label: AppStrings.manage,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month_outlined),
        activeIcon: Icon(Icons.calendar_month),
        label: AppStrings.schedule,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: AppStrings.profile,
      ),
    ];
  }

  /// Overlay a red badge on top-right of an icon.
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
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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
        return const [
          HomePage(),
          ManagerRequestPage(),
          SchedulePage(),
          ProfilePage(),
        ];
      case UserRole.HR:
        return const [HomePage(), SchedulePage(), ProfilePage()];
      case UserRole.INTERN:
      case UserRole.EMPLOYEE:
        return const [HomePage(), SchedulePage(), StatusPage(), ProfilePage()];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsForRole(UserRole role) {
    switch (role) {
      case UserRole.MANAGER:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: AppStrings.manage,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: AppStrings.schedule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ];
      case UserRole.HR:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: AppStrings.schedule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ];
      case UserRole.INTERN:
      case UserRole.EMPLOYEE:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: AppStrings.schedule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: AppStrings.status,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ];
    }
  }

  Color _getColorForRole(UserRole role) {
    switch (role) {
      case UserRole.MANAGER:
        return Colors.deepPurple;
      case UserRole.HR:
        return Colors.teal;
      case UserRole.INTERN:
      case UserRole.EMPLOYEE:
        return Colors.blue.shade700;
    }
  }
}
