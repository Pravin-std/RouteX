import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 340.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -60.w,
            top: 40.h,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            right: -40.w,
            bottom: 40.h,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_bus, color: Colors.white, size: 40.sp),
                      SizedBox(width: 8.w),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                          children: const [
                            TextSpan(text: 'Route', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'X', style: TextStyle(color: AppColors.accent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Smart Bus Management Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureItem(Icons.location_on, AppColors.accent, 'Find'),
                      _buildDot(),
                      _buildFeatureItem(Icons.confirmation_num, AppColors.secondary, 'Book'),
                      _buildDot(),
                      _buildFeatureItem(Icons.directions_bus, AppColors.accent, 'Travel'),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Welcome Back 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Sign in to continue your journey',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, Color iconColor, String text) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 4.w,
        height: 4.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
