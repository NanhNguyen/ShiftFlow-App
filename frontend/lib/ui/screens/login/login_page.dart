import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../di/di_config.dart';
import '../../router/app_router.gr.dart';
import '../../theme/app_theme.dart';
import '../../../data/constant/enums.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';
import '../../../resource/app_strings.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == BaseStatus.success) {
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              context.router.replace(const MainRoute());
            }
          });
        } else if (state.status == BaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.loginFailed),
              backgroundColor: InternaCrystal.accentRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: InternaCrystal.bgDeep,
        body: Stack(
          children: [
            // ── Animated background gradient orbs ──
            const Positioned.fill(
              child: RepaintBoundary(
                child: _BackgroundDecoration(),
              ),
            ),
            // ── Login form ──
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: InternaCrystal.bgCard.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: InternaCrystal.borderLight),
                            boxShadow: [
                              BoxShadow(
                                color: InternaCrystal.accentPurple.withOpacity(0.1),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Logo ──
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      InternaCrystal.accentPurple.withOpacity(0.2),
                                      InternaCrystal.accentBlue.withOpacity(0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: InternaCrystal.accentPurple.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => InternaCrystal.brandGradient.createShader(bounds),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // ── App name ──
                              ShaderMask(
                                shaderCallback: (bounds) => InternaCrystal.brandGradient.createShader(bounds),
                                child: Text(
                                  AppStrings.appName,
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Quản lý lịch trình thông minh',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: InternaCrystal.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 36),
                              // ── Email field ──
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
                                decoration: InputDecoration(
                                  labelText: AppStrings.email,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: InternaCrystal.textMuted,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // ── Password field ──
                              BlocBuilder<LoginCubit, LoginState>(
                                buildWhen: (prev, curr) => prev.obscurePassword != curr.obscurePassword,
                                builder: (context, state) {
                                  return TextField(
                                    controller: _passwordController,
                                    obscureText: state.obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _handleLogin(context),
                                    style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
                                    decoration: InputDecoration(
                                      labelText: AppStrings.password,
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: InternaCrystal.textMuted,
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          state.obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: InternaCrystal.textMuted,
                                          size: 20,
                                        ),
                                        onPressed: () => context
                                            .read<LoginCubit>()
                                            .togglePasswordVisibility(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              // ── Login button ──
                              BlocBuilder<LoginCubit, LoginState>(
                                buildWhen: (prev, curr) => prev.status != curr.status,
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: InternaCrystal.brandGradient,
                                        boxShadow: [
                                          BoxShadow(
                                            color: InternaCrystal.accentPurple.withOpacity(0.4),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: state.status == BaseStatus.loading
                                            ? null
                                            : () => _handleLogin(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: state.status == BaseStatus.loading
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                AppStrings.login,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    context.read<LoginCubit>().login(
      _emailController.text,
      _passwordController.text,
    );
  }
}

/// Static background decoration – wrapped in RepaintBoundary to avoid repaints
class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep base
        Container(color: InternaCrystal.bgDeep),
        // Purple orb top-right
        Positioned(
          top: -120,
          right: -80,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  InternaCrystal.accentPurple.withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Blue orb bottom-left
        Positioned(
          bottom: -100,
          left: -60,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  InternaCrystal.accentBlue.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
