import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'google_signin_button.dart';
import 'divider_with_text.dart';
import 'email_textfield.dart';
import 'password_textfield.dart';
import 'login_button.dart';
import 'security_card.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          GoogleSigninButton(
            onPressed: () {
              // TODO: Implement Google Sign In
            },
          ),
          SizedBox(height: 24.h),
          const DividerWithText(),
          SizedBox(height: 24.h),
          const EmailTextfield(),
          SizedBox(height: 16.h),
          const PasswordTextfield(),
          SizedBox(height: 24.h),
          LoginButton(
            onPressed: () {
              // TODO: Implement Email Sign In
            },
          ),
          SizedBox(height: 24.h),
          const SecurityCard(),
        ],
      ),
    );
  }
}
