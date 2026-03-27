import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../di/di_config.dart';
import '../../theme/app_theme.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../../data/service/auth_service.dart';
import 'cubit/status_cubit.dart';
import 'cubit/status_state.dart';
import 'widget/request_item.dart';
import '../../../resource/app_strings.dart';
import '../main/cubit/main_cubit.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StatusCubit>()..loadRequests(),
      child: DefaultTabController(
        length: 3,
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
            elevation: 0,
            title: Text(
              AppStrings.myRequestStatus,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.read<MainCubit>().setIndex(0),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: AppStrings.pending.toUpperCase()),
                Tab(text: AppStrings.approved.toUpperCase()),
                Tab(text: AppStrings.rejected.toUpperCase()),
              ],
            ),
          ),
          body: BlocBuilder<StatusCubit, StatusState>(
            builder: (context, state) {
              final pendingRequests = state.requests
                  .where((r) => r.status == RequestStatus.PENDING)
                  .toList();
              final approvedRequests = state.requests
                  .where((r) => r.status == RequestStatus.APPROVED)
                  .toList();
              final rejectedRequests = state.requests
                  .where((r) => r.status == RequestStatus.REJECTED)
                  .toList();

              return TabBarView(
                children: [
                  _buildRequestList(context, state, pendingRequests),
                  _buildRequestList(context, state, approvedRequests),
                  _buildRequestList(context, state, rejectedRequests),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(
    BuildContext context,
    StatusState state,
    List<ScheduleRequestModel> requests,
  ) {
    if (requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<StatusCubit>().loadRequests(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: InternaCrystal.textMuted),
                const SizedBox(height: 12),
                Text(
                  AppStrings.noRequestsFound,
                  style: GoogleFonts.inter(color: InternaCrystal.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final items = requests.groupByGroupId();

    return RefreshIndicator(
      onRefresh: () => context.read<StatusCubit>().loadRequests(),
      color: InternaCrystal.accentPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return const SizedBox.shrink();
          final item = items[index - 1];
          if (item is List<ScheduleRequestModel>) {
            return _buildGroupedItem(context, item);
          } else {
            final req = item as ScheduleRequestModel;
            return RequestItem(
              request: req,
              onDelete: req.status == RequestStatus.PENDING
                  ? () => _confirmDelete(context, () {
                      context.read<StatusCubit>().deleteRequest(req.id);
                    })
                  : null,
            );
          }
        },
      ),
    );
  }

  Widget _buildGroupedItem(
    BuildContext context,
    List<ScheduleRequestModel> group,
  ) {
    final first = group.first;
    final isPending = first.status == RequestStatus.PENDING;
    final color = first.status == RequestStatus.PENDING
        ? InternaCrystal.accentOrange
        : (first.status == RequestStatus.APPROVED
            ? InternaCrystal.accentGreen
            : InternaCrystal.accentRed);

    final role = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    final isIntern = role == UserRole.INTERN || role == UserRole.EMPLOYEE;
    final subtitle = isIntern
        ? first.status.displayName
        : '${group.length} ${AppStrings.itemsCount} • ${first.status.displayName}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: InternaCrystal.bgCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: InternaCrystal.textMuted,
          iconColor: InternaCrystal.accentPurple,
          title: Text(
            first.description ?? AppStrings.batchRequest,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: InternaCrystal.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: InternaCrystal.accentPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              first.isRecurring ? Icons.repeat : Icons.event_note,
              color: InternaCrystal.accentPurple,
              size: 22,
            ),
          ),
          trailing: isPending
              ? IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: InternaCrystal.accentRed,
                    size: 22,
                  ),
                  onPressed: () => _confirmDelete(context, () {
                    context.read<StatusCubit>().deleteBatchRequests(
                      first.groupId!,
                    );
                  }),
                )
              : null,
          children: group
              .map(
                (req) => RequestItem(
                  request: req,
                  onDelete: isPending
                      ? () => _confirmDelete(context, () {
                          context.read<StatusCubit>().deleteRequest(req.id);
                        })
                      : null,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: const Text(AppStrings.deleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: InternaCrystal.accentRed,
            ),
            child: Text(
              AppStrings.delete,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
