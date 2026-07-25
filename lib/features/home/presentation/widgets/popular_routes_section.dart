import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularRoutesSection extends StatelessWidget {
  const PopularRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      {
        'from': 'Salem',
        'to': 'Erode',
        'fare': '₹120',
        'gradient': [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
      },
      {
        'from': 'Salem',
        'to': 'Coimbatore',
        'fare': '₹180',
        'gradient': [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
      },
      {
        'from': 'Salem',
        'to': 'Chennai',
        'fare': '₹450',
        'gradient': [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
      },
      {
        'from': 'Salem',
        'to': 'Bengaluru',
        'fare': '₹650',
        'gradient': [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Routes',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF1E4DB7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              final gradient = route['gradient'] as List<Color>;
              return Container(
                width: 140.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    // Content
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['from'] as String,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16.sp,
                            color: Colors.grey.shade700,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            route['to'] as String,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'From ${route['fare']}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bus Image at bottom
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: Image.asset(
                        'assets/images/isometric_bus.png',
                        width: 110.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
