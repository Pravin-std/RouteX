import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/core/theme/app_colors.dart';
import 'package:routex/core/constants/app_constants.dart';

class VersionFooter extends StatelessWidget {
  const VersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version ${AppConstants.appVersion}',
      style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
    );
  }
}
