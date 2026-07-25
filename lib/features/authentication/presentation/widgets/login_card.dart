import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:routex/core/theme/app_colors.dart';
import '../../../../backend/providers/auth_provider.dart';
import '../../../../backend/providers/auth_state.dart';
import 'package:routex/core/utils/validators.dart';
import 'package:routex/core/utils/snackbar_utils.dart';
import 'google_signin_button.dart';
import 'divider_with_text.dart';
import 'email_textfield.dart';
import 'password_textfield.dart';
import 'login_button.dart';
import 'security_card.dart';

class LoginCard extends ConsumerStatefulWidget {
  const LoginCard({super.key});

  @override
  ConsumerState<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends ConsumerState<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref
            .read(authStateProvider.notifier)
            .login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
        if (mounted) {
          context.go('/home'); // Ensure this route is available
        }
      } catch (e) {
        if (mounted) {
          SnackbarUtils.handleAuthError(context, e);
        }
      }
    }
  }

  void _handleGoogleLogin() async {
    try {
      await ref.read(authStateProvider.notifier).loginWithGoogle();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.handleAuthError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GoogleSigninButton(
              onPressed: isLoading ? () {} : _handleGoogleLogin,
            ),
            SizedBox(height: 24.h),
            const DividerWithText(),
            SizedBox(height: 24.h),
            EmailTextfield(
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            SizedBox(height: 16.h),
            PasswordTextfield(
              controller: _passwordController,
              validator: Validators.validatePassword,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.push('/forgot_password');
                      },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            isLoading
                ? const CircularProgressIndicator()
                : LoginButton(onPressed: _handleLogin),
            SizedBox(height: 24.h),
            const SecurityCard(),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      context.push('/signup');
                    },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                  children: [
                    TextSpan(
                      text: 'Create Account',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
