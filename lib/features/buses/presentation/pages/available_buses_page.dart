import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AvailableBusesPage extends StatelessWidget {
  final String from;
  final String to;

  const AvailableBusesPage({super.key, required this.from, required this.to});

  Future<void> _saveRoute(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favsJson = prefs.getString('favorites');
      List<Map<String, dynamic>> favorites = [];

      if (favsJson != null) {
        final List<dynamic> decoded = jsonDecode(favsJson);
        favorites = decoded.map((e) => e as Map<String, dynamic>).toList();
      }

      // Check if already exists
      final exists = favorites.any((r) => r['from'] == from && r['to'] == to);
      if (!exists) {
        favorites.add({'from': from, 'to': to});
        await prefs.setString('favorites', jsonEncode(favorites));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Route saved to Favorites!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Route is already in Favorites')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final buses = [
      {
        'busNumber': 'TN 30 AB 1234',
        'routeName': '$from -> $to (Express)',
        'departureTime': '10:00 AM',
        'arrivalTime': '01:30 PM',
        'duration': '3h 30m',
        'fare': '₹150',
        'status': 'On Time',
        'busType': 'Non-AC Seater',
      },
      {
        'busNumber': 'TN 45 CD 5678',
        'routeName': '$from -> $to (Deluxe)',
        'departureTime': '11:15 AM',
        'arrivalTime': '02:45 PM',
        'duration': '3h 30m',
        'fare': '₹200',
        'status': 'Delayed',
        'busType': 'AC Seater',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Buses',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${buses.length} Buses Found',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return _buildBusCard(context, bus);
        },
      ),
    );
  }

  Widget _buildBusCard(BuildContext context, Map<String, String> bus) {
    final isDelayed = bus['status'] == 'Delayed';
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  bus['busNumber']!,
                  style: TextStyle(
                    color: const Color(0xFF1E4DB7),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDelayed ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  bus['status']!,
                  style: TextStyle(
                    color: isDelayed ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            bus['routeName']!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeWidget(bus['departureTime']!, 'Departure'),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.grey.shade400,
                size: 24.sp,
              ),
              _buildTimeWidget(bus['arrivalTime']!, 'Arrival'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    bus['fare']!,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E4DB7),
                    ),
                  ),
                  Text(
                    bus['duration']!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Type: ${bus['busType']}',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _saveRoute(context),
                  icon: const Icon(Icons.bookmark_border, size: 18),
                  label: const Text('Save Route'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E4DB7),
                    side: const BorderSide(color: Color(0xFF1E4DB7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/bus_details', extra: bus);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Travel Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWidget(String time, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
