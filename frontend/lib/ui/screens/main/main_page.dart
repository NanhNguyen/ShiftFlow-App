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

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthService>();
    final userRole = authService.currentUser?.role ?? UserRole.INTERN;

    return BlocProvider(
      create: (context) => getIt<MainCubit>(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final pages = _getPagesForRole(userRole);
          final navItems = _getNavItemsForRole(userRole);

          return Scaffold(
            body: IndexedStack(index: state.currentIndex, children: pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<MainCubit>().setIndex(index);
                // Auto-refresh schedule when switching to Schedule tab
                if ((userRole == UserRole.INTERN && index == 1) ||
                    (userRole == UserRole.MANAGER && index == 2) ||
                    (userRole == UserRole.HR && index == 2)) {
                  getIt<ScheduleCubit>().loadSchedules(userRole);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _getColorForRole(userRole),
              unselectedItemColor: Colors.grey,
              items: navItems,
            ),
          );
        },
      ),
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
        return const [
          HomePage(),
          ManagerRequestPage(), // HR can view all but not approve
          SchedulePage(),
          ProfilePage(),
        ];
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case UserRole.HR:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility_outlined),
            activeIcon: Icon(Icons.visibility),
            label: 'View All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case UserRole.INTERN:
      case UserRole.EMPLOYEE:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
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
