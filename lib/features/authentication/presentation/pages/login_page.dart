import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/core/theme/app_colors.dart';
import 'package:routex/features/authentication/presentation/widgets/login_header.dart';
import 'package:routex/features/authentication/presentation/widgets/login_card.dart';
import 'package:routex/features/authentication/presentation/widgets/version_footer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.h),
                    const LoginHeader(),
                    SizedBox(height: 32.h),
                    const LoginCard(),
                    const Spacer(),
                    SizedBox(height: 32.h),
                    _buildBottomBenefits(),
                    SizedBox(height: 24.h),
                    const VersionFooter(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBenefits() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBenefitItem(Icons.shield_outlined, 'Secure'),
        _buildDivider(),
        _buildBenefitItem(Icons.bolt, 'Fast'),
        _buildDivider(),
        _buildBenefitItem(Icons.verified_outlined, 'Reliable'),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 16.h,
      color: AppColors.border,
    );
  }
}
