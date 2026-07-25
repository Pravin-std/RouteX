import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320.h,
      decoration: const BoxDecoration(
        color: Color(0xFF1E4DB7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/banner_bus.png'),
          fit: BoxFit.cover, // Will show our generated banner image nicely
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.white, size: 28.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'RouteX',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28.sp),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF8A00),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Greeting Texts
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        'Pravin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('👋', style: TextStyle(fontSize: 24.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Where would you like to go today?',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
