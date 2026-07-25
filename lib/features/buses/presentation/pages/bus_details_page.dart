import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BusDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bus;

  const BusDetailsPage({super.key, required this.bus});

  @override
  State<BusDetailsPage> createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  bool _isBooking = false;

  Future<void> _confirmBooking() async {
    setState(() => _isBooking = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Fetch user profile for name
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      final String passengerName = profile['full_name'] ?? 'Guest User';
      final String ticketNumber =
          'RX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      final ticketData = {
        'user_id': user.id,
        'ticket_number': ticketNumber,
        'passenger_name': passengerName,
        'route': widget.bus['routeName'],
        'bus_number': widget.bus['busNumber'],
        'fare': widget.bus['fare'],
        'travel_date': DateTime.now().toIso8601String().split('T')[0],
        'status': 'Valid',
      };

      // Try inserting. If table doesn't exist, we will just proceed anyway
      // to not block the UI if backend schema is missing 'tickets' table.
      try {
        await Supabase.instance.client.from('tickets').insert(ticketData);
      } catch (dbError) {
        debugPrint(
          'Warning: Tickets table might not exist or permission denied. $dbError',
        );
      }

      if (mounted) {
        setState(() => _isBooking = false);
        context.push('/digital_ticket', extra: ticketData);
      }
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      if (mounted) {
        setState(() => _isBooking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate ticket')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Bus Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Bus Info Card
            Container(
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
                  Text(
                    widget.bus['routeName'] ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bus Number: ${widget.bus['busNumber']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'Operator: SETC',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn('Fare', widget.bus['fare'] ?? ''),
                      _buildInfoColumn('ETA', widget.bus['arrivalTime'] ?? ''),
                      _buildInfoColumn(
                        'Journey Time',
                        widget.bus['duration'] ?? '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Stops timeline
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Map',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildStopRow(
                    widget.bus['departureTime'] ?? '',
                    'Departure Stop',
                    true,
                  ),
                  _buildStopRow('...', 'Intermediate Stops', false),
                  _buildStopRow(
                    widget.bus['arrivalTime'] ?? '',
                    'Destination Stop',
                    true,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isBooking ? null : _confirmBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E4DB7),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: _isBooking
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Travel Now - Confirm Boarding',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildStopRow(
    String time,
    String stopName,
    bool isImportant, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60.w,
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              color: isImportant
                  ? const Color(0xFF1E293B)
                  : Colors.grey.shade500,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isImportant
                    ? const Color(0xFFFF9800)
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(width: 2.w, height: 30.h, color: Colors.grey.shade300),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            stopName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              color: isImportant
                  ? const Color(0xFF1E293B)
                  : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
