import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:routex/core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import 'package:routex/core/utils/validators.dart';
import 'package:routex/core/utils/snackbar_utils.dart';
import '../widgets/email_textfield.dart';
import '../widgets/password_textfield.dart';
import '../widgets/login_header.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreedToTerms) {
        SnackbarUtils.showError(context, 'You must agree to the Terms & Privacy Policy');
        return;
      }
      try {
        await ref.read(authStateProvider.notifier).register(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              fullName: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
              gender: _selectedGender,
            );
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Account created successfully! Please sign in.');
          context.pop(); // Go back to login
        }
      } catch (e) {
        if (mounted) {
          SnackbarUtils.handleAuthError(context, e);
          
          // If the auth signup succeeded but profile creation failed, we should still 
          // consider the account created and return to login.
          if (e.toString().contains('Profile creation failed')) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.pop();
              }
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const LoginHeader(), // Reusing the header
                      Padding(
                        padding: EdgeInsets.only(top: 240.h, left: 24.w, right: 24.w, bottom: 40.h),
                        child: Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                TextFormField(
                                  controller: _nameController,
                                  validator: Validators.validateName,
                                  decoration: _inputDecoration('Full Name', Icons.person_outline),
                                ),
                                SizedBox(height: 16.h),
                                EmailTextfield(
                                  controller: _emailController,
                                  validator: Validators.validateEmail,
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: _phoneController,
                                  validator: Validators.validatePhone,
                                  keyboardType: TextInputType.phone,
                                  decoration: _inputDecoration('Phone Number', Icons.phone_outlined),
                                ),
                                SizedBox(height: 16.h),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedGender,
                                  items: ['Male', 'Female', 'Other']
                                      .map((label) => DropdownMenuItem(
                                            value: label,
                                            child: Text(label),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                  decoration: _inputDecoration('Gender (Optional)', Icons.wc_outlined),
                                ),
                                SizedBox(height: 16.h),
                                PasswordTextfield(
                                  controller: _passwordController,
                                  validator: Validators.validatePassword,
                                  hintText: 'Password',
                                ),
                                SizedBox(height: 16.h),
                                PasswordTextfield(
                                  controller: _confirmPasswordController,
                                  validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text),
                                  hintText: 'Confirm Password',
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _agreedToTerms,
                                      onChanged: (val) {
                                        setState(() {
                                          _agreedToTerms = val ?? false;
                                        });
                                      },
                                      activeColor: AppColors.primary,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'I agree to Terms & Privacy Policy',
                                        style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : Container(
                                        width: double.infinity,
                                        height: 56.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.r),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [AppColors.primary, AppColors.primaryDark],
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: _handleSignup,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                                          ),
                                          child: Text(
                                            'Create Account',
                                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 24.h),
                                Center(
                                  child: GestureDetector(
                                    onTap: isLoading ? null : () => context.pop(),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Already have an account? ',
                                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
                                        children: [
                                          TextSpan(
                                            text: 'Sign In',
                                            style: TextStyle(color: AppColors.primary, fontSize: 14.sp, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
      prefixIcon: Icon(icon, color: AppColors.textPrimary, size: 20.sp),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
    );
  }
}
