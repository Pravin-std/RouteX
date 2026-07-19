import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/core/theme/app_colors.dart';

class PasswordTextfield extends StatelessWidget {
  const PasswordTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
        suffixIcon: Icon(
          Icons.visibility_outlined,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
      ),
    );
  }
}
