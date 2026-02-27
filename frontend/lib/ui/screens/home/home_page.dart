import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../data/constant/enums.dart';
import '../../../data/model/schedule_request_model.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import '../../router/app_router.gr.dart';
import '../main/cubit/main_cubit.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import '../../../resource/app_strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.scheduleOverview),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () =>
                          context.pushRoute(const NotificationRoute()),
                    ),
                    if (state.unreadNotificationCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${state.unreadNotificationCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().loadData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(state.user?.name ?? 'User'),
                    _buildTodayStatus(state.todaySchedule),
                    _buildQuickActions(context),
                    _buildQuickStats(state),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        AppStrings.recentUpdates,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(AppStrings.noRecentUpdates),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: () {
              final role =
                  getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
              if (role == UserRole.INTERN || role == UserRole.EMPLOYEE) {
                return FloatingActionButton(
                  onPressed: () =>
                      context.router.push(const ScheduleFormRoute()),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                );
              }
              return null;
            }(),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.welcomeBack,
            style: TextStyle(
              color: Color(0xFF444444), // High contrast grey
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black, // Pure black for max contrast
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStatus(ScheduleRequestModel? todaySchedule) {
    if (todaySchedule == null) return const SizedBox.shrink();

    final isLeave = todaySchedule.type == ScheduleType.LEAVE;
    final color = isLeave ? Colors.red : Colors.green;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLeave ? Icons.beach_access : Icons.work,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLeave ? AppStrings.onLeaveToday : AppStrings.workingToday,
                    style: TextStyle(
                      color: color.shade700,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLeave
                        ? 'Personal Leave'
                        : 'Shift: ${todaySchedule.shift}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    final isManagerOrHR = role == UserRole.MANAGER || role == UserRole.HR;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.quickActions,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: isManagerOrHR
                ? [
                    _buildActionItem(
                      context,
                      AppStrings.requests,
                      Icons.pending_actions,
                      Colors.orange,
                      tabIndex: 1,
                    ),
                    _buildActionItem(
                      context,
                      AppStrings.schedule,
                      Icons.calendar_month,
                      Colors.blue,
                      tabIndex: 2,
                    ),
                    _buildActionItem(
                      context,
                      AppStrings.profile,
                      Icons.person,
                      Colors.green,
                      tabIndex: 3,
                    ),
                  ]
                : [
                    _buildActionItem(
                      context,
                      AppStrings.schedule,
                      Icons.calendar_today,
                      Colors.blue,
                      tabIndex: 1,
                    ),
                    _buildActionItem(
                      context,
                      AppStrings.absence,
                      Icons.event_busy,
                      Colors.red,
                      tabIndex: 1, // Also Schedule tab
                    ),
                    _buildActionItem(
                      context,
                      AppStrings.profile,
                      Icons.person,
                      Colors.green,
                      tabIndex: 3,
                    ),
                  ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String label,
    IconData icon,
    Color color, {
    int? tabIndex,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (tabIndex != null) {
              context.read<MainCubit>().setIndex(tabIndex);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildQuickStats(HomeState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStatCard(
            AppStrings.pendingRequests,
            state.pendingCount.toString(),
            Colors.orange,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            AppStrings.totalRequests,
            state.totalCount.toString(),
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
