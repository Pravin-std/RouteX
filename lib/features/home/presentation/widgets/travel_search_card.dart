import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelSearchCard extends StatefulWidget {
  const TravelSearchCard({super.key});

  @override
  State<TravelSearchCard> createState() => _TravelSearchCardState();
}

class _TravelSearchCardState extends State<TravelSearchCard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Row(children: [_buildTab(0, 'Search Bus'), _buildTab(1, 'Bus Pass')]),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Input Fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildInputBox(
                            'From',
                            'Salem, Tamil Nadu',
                            Icons.location_on,
                            const Color(0xFF1E4DB7),
                          ),
                          SizedBox(height: 12.h),
                          _buildInputBox(
                            'To',
                            'Coimbatore, Tamil Nadu',
                            Icons.location_on,
                            const Color(0xFFFF8A00),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Swap Button
                    Column(
                      children: [
                        SizedBox(height: 30.h),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.grey.shade600,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInputBox(
                  'Journey Date',
                  '24 May 2025, Saturday',
                  Icons.calendar_today,
                  Colors.grey.shade600,
                  showDropdown: true,
                ),
                SizedBox(height: 20.h),
                // Gradient Search Button
                Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E4DB7), Color(0xFFFF8A00)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Search Bus',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFFFF8A00)
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF1E293B)
                  : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(
    String label,
    String value,
    IconData icon,
    Color iconColor, {
    bool showDropdown = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          if (showDropdown)
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
