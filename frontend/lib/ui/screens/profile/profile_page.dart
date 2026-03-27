import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../di/di_config.dart';
import '../../router/app_router.gr.dart';
import '../../theme/app_theme.dart';
import '../../../data/constant/enums.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import '../../../data/api/api_client.dart';
import '../../../resource/app_strings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == BaseStatus.success) {
            if (state.user == null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Thành công'),
                  content: const Text(
                    'Thông tin đã được cập nhật. Vui lòng đăng nhập lại để áp dụng thay đổi.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.router.replaceAll([const LoginRoute()]);
                      },
                      child: const Text('Đăng nhập'),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(AppStrings.actionSuccessful),
                  backgroundColor: InternaCrystal.accentGreen,
                ),
              );
            }
          } else if (state.status == BaseStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? AppStrings.anErrorOccurred),
                backgroundColor: InternaCrystal.accentRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final user = state.user;
          final avatarUrl = user?.avatarUrl;
          final fullAvatarUrl = avatarUrl != null
              ? '${ApiClient.baseUrl}$avatarUrl'
              : null;

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
                AppStrings.myProfile,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: state.status == BaseStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            // ── Avatar ──
                            _buildAvatarSection(context, fullAvatarUrl, user),
                            const SizedBox(height: 24),
                            // ── Name ──
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user?.name ?? 'User Name',
                                  style: GoogleFonts.inter(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: InternaCrystal.textPrimary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: InternaCrystal.accentPurple,
                                  ),
                                  onPressed: () => _showEditNameDialog(
                                    context,
                                    user?.name ?? '',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'email@example.com',
                              style: GoogleFonts.inter(
                                color: InternaCrystal.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // ── Role badge ──
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    InternaCrystal.accentPurple.withOpacity(0.2),
                                    InternaCrystal.accentBlue.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: InternaCrystal.accentPurple.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                user?.role.displayName ?? 'Role',
                                style: GoogleFonts.inter(
                                  color: InternaCrystal.accentPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // ── Options ──
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: InternaCrystal.glassCard(),
                                  child: Column(
                                    children: [
                                      _buildOptionTile(
                                        context,
                                        icon: Icons.lock_outline,
                                        title: AppStrings.changePassword,
                                        onTap: () => _showChangePasswordDialog(context),
                                      ),
                                      Divider(
                                        height: 1,
                                        color: InternaCrystal.borderSubtle,
                                        indent: 56,
                                      ),
                                      _buildOptionTile(
                                        context,
                                        icon: Icons.logout_rounded,
                                        title: AppStrings.logout,
                                        isDestructive: true,
                                        onTap: () => _showLogoutConfirmation(context),
                                      ),
                                    ],
                                  ),
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
    );
  }

  Widget _buildAvatarSection(BuildContext context, String? avatarUrl, user) {
    final initial = (user?.name ?? 'U').isNotEmpty
        ? (user?.name ?? 'U').trim()[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: InternaCrystal.brandGradient,
      ),
      child: CircleAvatar(
        radius: 56,
        backgroundColor: InternaCrystal.bgCard,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null
            ? Text(
                initial,
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: InternaCrystal.textPrimary,
                ),
              )
            : null,
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final nameController = TextEditingController(text: currentName);
    final cubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi tên hiển thị'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Họ và tên'),
          autofocus: true,
          style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.pop(context);
              cubit.updateProfile(name: nameController.text.trim());
            },
            child: const Text(AppStrings.update),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    final confirmController = TextEditingController();
    final cubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
              decoration: const InputDecoration(
                labelText: AppStrings.currentPassword,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
              decoration: const InputDecoration(
                labelText: AppStrings.newPassword,
                hintText: 'Tối thiểu 6 ký tự',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
              decoration: const InputDecoration(
                labelText: AppStrings.confirmPassword,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (oldPasswordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập mật khẩu hiện tại'),
                  ),
                );
                return;
              }
              if (passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.passwordTooShort)),
                );
                return;
              }
              if (passwordController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.passwordsDoNotMatch)),
                );
                return;
              }
              Navigator.pop(context);
              cubit.changePassword(
                oldPassword: oldPasswordController.text,
                newPassword: passwordController.text,
              );
            },
            child: const Text(AppStrings.update),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? InternaCrystal.accentRed : InternaCrystal.accentPurple;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isDestructive ? InternaCrystal.accentRed : InternaCrystal.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: InternaCrystal.textMuted,
        size: 22,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: InternaCrystal.accentRed,
            ),
            child: Text(
              AppStrings.logout,
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
