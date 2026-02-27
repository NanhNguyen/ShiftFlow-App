import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/di_config.dart';
import '../../router/app_router.gr.dart';
import '../../../data/constant/enums.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.actionSuccessful),
                backgroundColor: Colors.green,
              ),
            );
            context.router.replace(const LoginRoute());
          } else if (state.status == BaseStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? AppStrings.anErrorOccurred),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.myProfile)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user?.name ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role.toString().split('.').last ?? 'Role',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildOptionTile(
                    context,
                    icon: Icons.lock_outline,
                    title: AppStrings.changePassword,
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  const Divider(),
                  _buildOptionTile(
                    context,
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    isDestructive: true,
                    onTap: () => context.read<ProfileCubit>().logout(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final cubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AppStrings.newPassword,
                hintText: 'Minimum 6 characters',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
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
              cubit.changePassword(passwordController.text);
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
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: EdgeInsets.zero,
    );
  }
}
