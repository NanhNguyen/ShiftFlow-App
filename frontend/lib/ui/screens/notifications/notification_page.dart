import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'cubit/notification_cubit.dart';
import 'cubit/notification_state.dart';
import '../../../../resource/app_strings.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/service/auth_service.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../../data/repo/schedule_request_repo.dart';
import '../../di/di_config.dart';
import '../../router/app_router.gr.dart';
import '../../theme/app_theme.dart';
import '../home/cubit/home_cubit.dart';
import '../main/cubit/main_cubit.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> _pendingGroups = [];
  bool _loadingPending = false;
  late final NotificationCubit _notifCubit;

  @override
  void initState() {
    super.initState();
    _notifCubit = getIt<NotificationCubit>()
      ..loadNotifications().then((_) {
        _notifCubit.markAllAsRead();
        getIt<HomeCubit>().loadData();
      });
    _loadPendingIfManager();
  }

  Future<void> _loadPendingIfManager() async {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    if (role != UserRole.MANAGER && role != UserRole.HR) return;

    setState(() => _loadingPending = true);
    try {
      final scheduleRepo = getIt<ScheduleRequestRepo>();
      final all = await scheduleRepo.getAllSchedules();
      final pending = all
          .where((r) => r.status == RequestStatus.PENDING)
          .toList();
      final groups = pending.groupByGroupId();
      if (mounted) {
        setState(() {
          _pendingGroups = groups;
          _loadingPending = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPending = false);
    }
  }

  Future<void> _onRefresh() async {
    await _loadPendingIfManager();
    _notifCubit.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    final isManagerOrHR = role == UserRole.MANAGER || role == UserRole.HR;

    return BlocProvider.value(
      value: _notifCubit,
      child: Scaffold(
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
          centerTitle: true,
          title: Text(
            AppStrings.notifications,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: InternaCrystal.accentPurple,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // ── MANAGER/HR: Pending request action cards ──
                      if (isManagerOrHR) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                            child: Row(
                              children: [
                                Text(
                                  'Yêu cầu chờ duyệt',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: InternaCrystal.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_pendingGroups.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: InternaCrystal.accentRed,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_pendingGroups.length}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_loadingPending)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          )
                        else if (_pendingGroups.isEmpty)
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: InternaCrystal.glassCard(),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: InternaCrystal.accentGreen,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppStrings.noPendingRequests,
                                    style: GoogleFonts.inter(
                                      color: InternaCrystal.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final item = _pendingGroups[index];
                              if (item is List<ScheduleRequestModel>) {
                                return _buildPendingGroupCard(context, item, role);
                              }
                              return _buildPendingSingleCard(
                                context,
                                item as ScheduleRequestModel,
                                role,
                              );
                            }, childCount: _pendingGroups.length),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              'Thông báo',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: InternaCrystal.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],

                      // ── For Interns: section header ──
                      if (!isManagerOrHR)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                            child: Text(
                              'Thông báo',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: InternaCrystal.textPrimary,
                              ),
                            ),
                          ),
                        ),

                      // ── Notifications list ──
                      if (state.status == BaseStatus.loading &&
                          state.notifications.isEmpty)
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      else if (state.notifications.isEmpty)
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(32),
                            decoration: InternaCrystal.glassCard(),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.notifications_none_rounded,
                                  size: 48,
                                  color: InternaCrystal.textMuted,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppStrings.noNotifications,
                                  style: GoogleFonts.inter(
                                    color: InternaCrystal.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final notif = state.notifications[index];
                            return _buildNotificationCard(context, notif);
                          }, childCount: state.notifications.length),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPendingGroupCard(
    BuildContext context,
    List<ScheduleRequestModel> group,
    UserRole role,
  ) {
    final first = group.first;
    final userName = first.userMetadata?['name'] ?? AppStrings.employee;
    final avatarLetter = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final isRecurring = first.isRecurring;
    final timeAgo = _formatTimeAgo(first.createdAt);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: InternaCrystal.glassCard(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToUserRequests(context, first, role),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: InternaCrystal.accentPurple.withOpacity(0.2),
                      child: Text(
                        avatarLetter,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: InternaCrystal.accentPurple,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: InternaCrystal.accentOrange,
                          shape: BoxShape.circle,
                          border: Border.all(color: InternaCrystal.bgCard, width: 2),
                        ),
                        child: const Icon(
                          Icons.pending_actions,
                          size: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: InternaCrystal.textPrimary,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: userName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: isRecurring
                                  ? ' đã gửi yêu cầu lịch định kỳ (${group.length} ngày)'
                                  : ' đã gửi yêu cầu nghỉ đột xuất cho ${group.length} ngày',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ca: ${first.shift}  •  $timeAgo',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: InternaCrystal.accentOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: InternaCrystal.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingSingleCard(
    BuildContext context,
    ScheduleRequestModel req,
    UserRole role,
  ) {
    final userName = req.userMetadata?['name'] ?? AppStrings.employee;
    final avatarLetter = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final timeAgo = _formatTimeAgo(req.createdAt);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: InternaCrystal.glassCard(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToUserRequests(context, req, role),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: InternaCrystal.accentPurple.withOpacity(0.2),
                      child: Text(
                        avatarLetter,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: InternaCrystal.accentPurple,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: InternaCrystal.accentOrange,
                          shape: BoxShape.circle,
                          border: Border.all(color: InternaCrystal.bgCard, width: 2),
                        ),
                        child: const Icon(
                          Icons.pending_actions,
                          size: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: InternaCrystal.textPrimary,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: userName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' đã gửi yêu cầu nghỉ'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ca: ${req.shift}  •  $timeAgo',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: InternaCrystal.accentOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: InternaCrystal.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic notification) {
    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    final isManagerOrHR = role == UserRole.MANAGER || role == UserRole.HR;
    final isUnread = !notification.isRead;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: isUnread
            ? InternaCrystal.accentPurple.withOpacity(0.08)
            : InternaCrystal.bgCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? InternaCrystal.accentPurple.withOpacity(0.2)
              : InternaCrystal.borderSubtle,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isUnread) {
              _notifCubit.markAsRead(notification.id);
              getIt<HomeCubit>().loadData();
            }

            if (notification.type == 'ANNOUNCEMENT') {
              final role =
                  getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
              if (role == UserRole.HR) {
                getIt<MainCubit>().setIndex(4);
              } else if (role == UserRole.MANAGER) {
                // Manager doesn't have announcement tab
              } else {
                getIt<MainCubit>().setIndex(4);
              }
            } else {
              if (isManagerOrHR) {
                context.router.push(const ManagerRequestRoute());
              } else {
                getIt<MainCubit>().setIndex(2);
                context.router.popUntilRoot();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _getIconColor(notification.type).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(notification.type),
                    color: _getIconColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.inter(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 15,
                          color: InternaCrystal.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: InternaCrystal.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTimeAgo(notification.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isUnread
                              ? InternaCrystal.accentPurple
                              : InternaCrystal.textMuted,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: InternaCrystal.accentPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToUserRequests(
    BuildContext context,
    ScheduleRequestModel req,
    UserRole role,
  ) {
    if (role == UserRole.MANAGER || role == UserRole.HR) {
      context.router.push(const ManagerRequestRoute());
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'REQUEST_CREATED':
        return Icons.add_circle_outline;
      case 'REQUEST_APPROVED':
        return Icons.check_circle_outline;
      case 'REQUEST_REJECTED':
        return Icons.cancel_outlined;
      case 'ANNOUNCEMENT':
        return Icons.campaign;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'REQUEST_CREATED':
        return InternaCrystal.accentPurple;
      case 'REQUEST_APPROVED':
        return InternaCrystal.accentGreen;
      case 'REQUEST_REJECTED':
        return InternaCrystal.accentRed;
      case 'ANNOUNCEMENT':
        return InternaCrystal.accentPurple;
      default:
        return InternaCrystal.textMuted;
    }
  }
}
