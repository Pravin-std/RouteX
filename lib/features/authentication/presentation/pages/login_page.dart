import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routex/features/authentication/presentation/widgets/login_header.dart';
import 'package:routex/features/authentication/presentation/widgets/login_card.dart';
import 'package:routex/features/authentication/presentation/widgets/version_footer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  const LoginHeader(),
                  Padding(
                    padding: EdgeInsets.only(top: 240.h, left: 24.w, right: 24.w),
                    child: const LoginCard(),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              const VersionFooter(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
