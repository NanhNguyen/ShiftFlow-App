import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/constant/enums.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import '../../theme/app_theme.dart';
import '../main/cubit/main_cubit.dart';
import '../schedule_form/schedule_form_modal.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import '../../../resource/app_strings.dart';
import '../accounts/create_account_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
        final isManagerOrHR = role == UserRole.MANAGER || role == UserRole.HR;

        return Scaffold(
          backgroundColor: InternaCrystal.bgDeep,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: InternaCrystal.brandGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            title: Text(
              AppStrings.scheduleOverview,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadData(),
            color: InternaCrystal.accentPurple,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        state.user?.name ?? 'User',
                        isWide: isWide,
                        isManagerOrHR: isManagerOrHR,
                      ),
                      if (isWide)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildQuickActions(
                                      context,
                                      state,
                                      isWide: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildQuickStats(state),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        AppStrings.recentUpdates,
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: InternaCrystal.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(50),
                                        child: Text(
                                          AppStrings.noRecentUpdates,
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            color: InternaCrystal.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuickActions(context, state, isWide: false),
                            _buildQuickStats(state),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              child: Text(
                                AppStrings.recentUpdates,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: InternaCrystal.textPrimary,
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Text(
                                  AppStrings.noRecentUpdates,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: InternaCrystal.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: () {
            if (role == UserRole.INTERN || role == UserRole.EMPLOYEE) {
              return FloatingActionButton.extended(
                onPressed: () {
                  showScheduleFormModal(context, isInitialRecurring: false);
                },
                backgroundColor: InternaCrystal.accentPurple,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: Text(
                  AppStrings.registerLeave,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              );
            }
            return null;
          }(),
        );
      },
    );
  }

  Widget _buildHeader(
    String name, {
    bool isWide = false,
    bool isManagerOrHR = false,
  }) {
    if (isWide) {
      return Container(
        padding: const EdgeInsets.fromLTRB(40, 32, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.welcomeBack}, $name!',
              style: GoogleFonts.inter(
                color: InternaCrystal.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isManagerOrHR
                  ? 'Đây là tổng quan các yêu cầu và lịch trình cần quản lý.'
                  : 'Đây là tổng quan lịch trình và công việc của bạn.',
              style: GoogleFonts.inter(
                color: InternaCrystal.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: InternaCrystal.accentPurple.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
        gradient: InternaCrystal.brandGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.welcomeBack,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(HomeState state) {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    final isManagerOrHR = role == UserRole.MANAGER || role == UserRole.HR;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.quickStats,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: InternaCrystal.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: isManagerOrHR ? 'Yêu cầu chờ duyệt' : 'Đang chờ duyệt',
                  value: state.pendingCount.toString(),
                  color: InternaCrystal.accentOrange,
                  icon: Icons.pending_actions_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  label: AppStrings.mealStatus,
                  value: isManagerOrHR
                      ? '${state.mealCountToday} suất'
                      : (state.isMealRegisteredToday ? 'Đã đăng ký' : 'Chưa đăng ký'),
                  color: InternaCrystal.accentGreen,
                  icon: Icons.restaurant_rounded,
                  smallerValue: !isManagerOrHR,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    bool smallerValue = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: InternaCrystal.bgCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: InternaCrystal.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: InternaCrystal.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: smallerValue ? 15 : 22,
                  fontWeight: FontWeight.bold,
                  color: InternaCrystal.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    HomeState state, {
    bool isWide = false,
  }) {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;

    List<Widget> actions;
    if (role == UserRole.MANAGER) {
      actions = [
        _buildActionItem(context, AppStrings.requests, Icons.pending_actions, InternaCrystal.accentOrange, tabIndex: 1, badgeCount: state.pendingCount),
        _buildActionItem(context, AppStrings.schedule, Icons.calendar_month, InternaCrystal.accentPurple, tabIndex: 2),
        _buildActionItem(context, AppStrings.notifications, Icons.notifications, InternaCrystal.accentBlue, tabIndex: 3),
        _buildActionItem(context, AppStrings.profile, Icons.person, InternaCrystal.accentGreen, tabIndex: 4),
      ];
    } else if (role == UserRole.HR) {
      actions = [
        _buildActionItem(context, 'Thống kê cơm', Icons.rice_bowl, const Color(0xFFF97316), tabIndex: 1),
        _buildActionItem(context, AppStrings.schedule, Icons.calendar_month, InternaCrystal.accentPurple, tabIndex: 2),
        _buildActionItem(context, AppStrings.accounts, Icons.people, const Color(0xFFA855F7), onTap: () => showCreateAccountModal(context)),
        _buildActionItem(context, 'Bản tin HR', Icons.campaign, InternaCrystal.accentBlue, tabIndex: 4),
        _buildActionItem(context, AppStrings.notifications, Icons.notifications, const Color(0xFF14B8A6), tabIndex: 5),
        _buildActionItem(context, AppStrings.profile, Icons.person, InternaCrystal.accentGreen, tabIndex: 6),
      ];
    } else {
      actions = [
        _buildActionItem(context, 'Đặt cơm', Icons.rice_bowl, const Color(0xFFF97316), tabIndex: 1),
        _buildActionItem(context, AppStrings.status, Icons.assignment, const Color(0xFF14B8A6), tabIndex: 3),
        _buildActionItem(context, AppStrings.announcements, Icons.campaign, InternaCrystal.accentBlue, tabIndex: 4),
        _buildActionItem(context, 'Đăng ký nghỉ', Icons.event_note, InternaCrystal.accentOrange, onTap: () => showScheduleFormModal(context, isInitialRecurring: false)),
        _buildActionItem(context, AppStrings.notifications, Icons.notifications, InternaCrystal.accentPurple, tabIndex: 5),
        _buildActionItem(context, AppStrings.profile, Icons.person, InternaCrystal.accentGreen, tabIndex: 6),
      ];
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(isWide ? 0 : 20, 24, isWide ? 0 : 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.quickActions,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: InternaCrystal.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: actions,
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
    VoidCallback? onTap,
    int badgeCount = 0,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onTap ??
                  () {
                    if (tabIndex != null) {
                      context.read<MainCubit>().setIndex(tabIndex);
                    }
                  },
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color.withOpacity(0.15)),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: InternaCrystal.accentRed,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: InternaCrystal.bgDeep, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: InternaCrystal.accentRed.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: InternaCrystal.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
