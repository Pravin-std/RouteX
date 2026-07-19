import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/core/theme/app_colors.dart';

class EmailTextfield extends StatelessWidget {
  const EmailTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
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
