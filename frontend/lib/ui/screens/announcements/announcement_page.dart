import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/constant/enums.dart';
import '../../../data/model/announcement_model.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import '../../theme/app_theme.dart';
import 'cubit/announcement_cubit.dart';
import 'cubit/announcement_state.dart';
import '../main/cubit/main_cubit.dart';

@RoutePage()
class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late final AnnouncementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AnnouncementCubit>()..loadAnnouncements();
  }

  bool get _isHR => getIt<AuthService>().currentUser?.role == UserRole.HR;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
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
          foregroundColor: Colors.white,
          title: Text(
            'Bản tin HR',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.read<MainCubit>().setIndex(0),
          ),
          centerTitle: true,
          actions: [
            if (_isHR)
              IconButton(
                icon: const Icon(Icons.edit_note, color: Colors.white),
                tooltip: 'Soạn thông báo',
                onPressed: () => _showComposeSheet(context),
              ),
          ],
        ),
        body: BlocConsumer<AnnouncementCubit, AnnouncementState>(
          listener: (context, state) {
            if (state.submitStatus == BaseStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage ?? 'Thành công!'),
                  backgroundColor: InternaCrystal.accentGreen,
                ),
              );
            } else if (state.submitStatus == BaseStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Lỗi không xác định'),
                  backgroundColor: InternaCrystal.accentRed,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == BaseStatus.loading &&
                state.announcements.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () => _cubit.loadAnnouncements(),
              color: InternaCrystal.accentPurple,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (_isHR)
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: InternaCrystal.brandGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: InternaCrystal.accentPurple.withOpacity(0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _showComposeSheet(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.campaign, color: Colors.white, size: 28),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Soạn thông báo mới',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Thông báo sẽ được gửi đến toàn bộ thực tập sinh',
                                              style: GoogleFonts.inter(
                                                color: Colors.white70,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (state.announcements.isEmpty)
                        SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                size: 64,
                                color: InternaCrystal.textMuted,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Chưa có thông báo nào',
                                style: GoogleFonts.inter(
                                  color: InternaCrystal.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildAnnouncementCard(
                              context,
                              state.announcements[index],
                            ),
                            childCount: state.announcements.length,
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: _isHR
            ? FloatingActionButton.extended(
                onPressed: () => _showComposeSheet(context),
                backgroundColor: InternaCrystal.accentPurple,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.campaign),
                label: Text(
                  'Đăng thông báo',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementModel announcement,
  ) {
    final dateFormat = DateFormat('HH:mm • dd/MM/yyyy');
    final authorLetter = announcement.authorName.isNotEmpty
        ? announcement.authorName[0].toUpperCase()
        : 'H';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: InternaCrystal.glassCard(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: InternaCrystal.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: InternaCrystal.bgCard,
                    child: Text(
                      authorLetter,
                      style: GoogleFonts.inter(
                        color: InternaCrystal.accentPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.authorName,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: InternaCrystal.textPrimary,
                        ),
                      ),
                      Text(
                        dateFormat.format(announcement.createdAt.toLocal()),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: InternaCrystal.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isHR)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDelete(context, announcement.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: InternaCrystal.accentRed),
                            const SizedBox(width: 8),
                            Text(
                              'Xóa thông báo',
                              style: TextStyle(color: InternaCrystal.accentRed),
                            ),
                          ],
                        ),
                      ),
                    ],
                    icon: Icon(Icons.more_vert, color: InternaCrystal.textMuted),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          InternaCrystal.accentPurple.withOpacity(0.2),
                          InternaCrystal.accentBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: InternaCrystal.accentPurple.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.campaign, size: 12, color: InternaCrystal.accentPurple),
                        const SizedBox(width: 4),
                        Text(
                          'HR',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: InternaCrystal.accentPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              announcement.title,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: InternaCrystal.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.content,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: InternaCrystal.textSecondary,
                height: 1.5,
              ),
            ),
            if (announcement.seenBy.isNotEmpty) ...[
              Divider(height: 20, color: InternaCrystal.borderSubtle),
              Row(
                children: [
                  Icon(Icons.visibility, size: 14, color: InternaCrystal.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${announcement.seenBy.length} người đã xem',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: InternaCrystal.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa thông báo'),
        content: const Text('Bạn có chắc chắn muốn xóa thông báo này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cubit.deleteAnnouncement(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: InternaCrystal.accentRed),
            child: Text(
              'Xóa',
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showComposeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BlocProvider.value(value: _cubit, child: const _ComposeSheet()),
    );
  }
}

class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet();

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: InternaCrystal.bgCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: InternaCrystal.borderLight),
            left: BorderSide(color: InternaCrystal.borderSubtle),
            right: BorderSide(color: InternaCrystal.borderSubtle),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: InternaCrystal.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => InternaCrystal.brandGradient.createShader(bounds),
                  child: const Icon(Icons.campaign, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  'Soạn thông báo HR',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: InternaCrystal.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
              decoration: InputDecoration(
                labelText: 'Tiêu đề thông báo',
                hintText: 'ví dụ: Lịch họp tháng 3...',
                prefixIcon: Icon(Icons.title, color: InternaCrystal.textMuted),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Nội dung',
                hintText: 'Nội dung chi tiết...',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            BlocBuilder<AnnouncementCubit, AnnouncementState>(
              buildWhen: (p, c) => p.submitStatus != c.submitStatus,
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: InternaCrystal.brandGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: InternaCrystal.accentPurple.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: state.submitStatus == BaseStatus.loading
                          ? null
                          : () => _submit(context),
                      icon: const Icon(Icons.send),
                      label: state.submitStatus == BaseStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Đăng thông báo',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề')),
      );
      return;
    }
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung')),
      );
      return;
    }

    context.read<AnnouncementCubit>().createAnnouncement(title, content).then((
      success,
    ) {
      if (success && mounted) {
        Navigator.pop(context);
      }
    });
  }
}
