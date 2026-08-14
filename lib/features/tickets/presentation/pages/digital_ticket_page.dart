import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DigitalTicketPage extends StatelessWidget {
  final Map<String, dynamic> bus;

  const DigitalTicketPage({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    final ticketNumber = bus['ticket_number']?.toString() ?? '';
    final passengerName = bus['passenger_name']?.toString() ?? '';
    final travelDate = bus['travel_date']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1E4DB7), // Blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Digital Ticket',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top section
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ticket No',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          Text(
                            ticketNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Passenger',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          Text(
                            passengerName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Dashed line
                Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 10.w,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E4DB7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => SizedBox(
                                width: 5.w,
                                height: 1.h,
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                      width: 10.w,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E4DB7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Middle section
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        bus['routeName'] ?? '',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetail(
                            'Bus No',
                            bus['bus_number'] ?? bus['busNumber'] ?? '',
                          ),
                          _buildDetail('Date', travelDate),
                          _buildDetail('Fare', bus['fare'] ?? ''),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      QrImageView(
                        data: ticketNumber,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          'Valid Ticket',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Download Ticket'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E4DB7),
                      side: const BorderSide(color: Color(0xFF1E4DB7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
