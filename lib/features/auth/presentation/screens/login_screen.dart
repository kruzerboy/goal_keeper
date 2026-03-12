import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';
import 'package:goal_keeper_app/core/di/service_locator.dart';
import 'package:goal_keeper_app/core/router/app_router.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/core/widgets/inputs/app_text_field.dart';
import 'package:goal_keeper_app/core/widgets/buttons/app_button.dart';
import 'package:goal_keeper_app/features/auth/presentation/controllers/auth_controller.dart';

/// LoginScreen is intentionally thin:
/// - Owns UI structure and TextEditingControllers (UI concerns)
/// - Delegates ALL logic to [AuthController]
/// - Never imports use cases or repositories directly
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController _controller;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.authController()
      ..addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _controller.state is ScreenLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              _Header(),
              const SizedBox(height: 40),
              AppTextField(
                label: 'Email',
                hint: 'name@email.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                errorText: _controller.emailError,
                onChanged: (_) => _controller.clearErrors(),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Password',
                hint: 'Enter password',
                controller: _passwordCtrl,
                obscureText: _controller.obscurePassword,
                errorText: _controller.passwordError,
                onChanged: (_) => _controller.clearErrors(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _controller.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: _controller.togglePasswordVisibility,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Sign In',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => _controller.signIn(
                          email: _emailCtrl.text,
                          password: _passwordCtrl.text,
                          onSuccess: () => context.go(AppRoutes.dashboard),
                        ),
              ),
              const SizedBox(height: 20),
              _Divider(),
              const SizedBox(height: 20),
              AppButton(
                label: 'Continue with Google',
                variant: AppButtonVariant.outlined,
                leadingIcon: _GoogleIcon(),
                onPressed: isLoading
                    ? null
                    : () => _controller.signInWithGoogle(
                          onSuccess: () => context.go(AppRoutes.dashboard),
                        ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.signup),
                    child: Text('Create Account',
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text('Goal Keeper',
              style: AppTypography.titleMedium
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Text('Welcome back', style: AppTypography.displayMedium),
          const SizedBox(height: 8),
          Text('Stay on track with your goals.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('or',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      );
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 20,
        height: 20,
        decoration:
            BoxDecoration(color: Colors.blue[600], shape: BoxShape.circle),
        child: const Center(
          child: Text('G',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
      );
}

