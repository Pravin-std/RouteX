import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableBusesPage extends StatefulWidget {
  final String from;
  final String to;

  const AvailableBusesPage({super.key, required this.from, required this.to});

  @override
  State<AvailableBusesPage> createState() => _AvailableBusesPageState();
}

class _AvailableBusesPageState extends State<AvailableBusesPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _buses = [];

  @override
  void initState() {
    super.initState();
    _fetchBuses();
  }

  Future<void> _fetchBuses() async {
    try {
      final response = await Supabase.instance.client
          .from('bus_routes')
          .select()
          .ilike('from_id', '%${widget.from}%')
          .ilike('to_id', '%${widget.to}%');
          
      if (mounted) {
        setState(() {
          _buses = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching buses: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load buses. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

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
      final exists = favorites.any((r) => r['from'] == widget.from && r['to'] == widget.to);
      if (!exists) {
        favorites.add({'from': widget.from, 'to': widget.to});
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
            if (!_isLoading && _errorMessage == null)
              Text(
                '${_buses.length} Buses Found',
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1E4DB7)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(fontSize: 16.sp, color: Colors.red),
        ),
      );
    }

    if (_buses.isEmpty) {
      return Center(
        child: Text(
          'No buses available for this route.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _buses.length,
      itemBuilder: (context, index) {
        final bus = _buses[index];
        return _buildBusCard(context, bus);
      },
    );
  }

  Widget _buildBusCard(BuildContext context, Map<String, dynamic> bus) {
    // Map database fields safely based on bus_routes schema
    final String busNumber = bus['bus_number']?.toString() ?? 'N/A';
    final String routeName = bus['bus_name']?.toString() ?? '${widget.from} -> ${widget.to}';
    final String status = bus['status']?.toString() ?? 'On Time';
    final String departureTime = bus['departure']?.toString() ?? 'N/A';
    final String arrivalTime = bus['arrival']?.toString() ?? 'N/A';
    final String fare = (bus['price'] != null && bus['price'] != 0) ? '₹${bus['price']}' : 'Fare not available';
    final String duration = bus['duration_minutes'] != null ? '${bus['duration_minutes']} mins' : 'Direct';
    final String busType = bus['bus_type']?.toString() ?? 'ordinary';

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
                  busNumber,
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
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            routeName,
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
              _buildTimeWidget(departureTime, 'Departure'),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.grey.shade400,
                size: 24.sp,
              ),
              _buildTimeWidget(arrivalTime, 'Arrival'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fare,
                    style: TextStyle(
                      fontSize: (fare == 'Fare not available') ? 12.sp : 18.sp,
                      fontWeight: FontWeight.bold,
                      color: (fare == 'Fare not available') ? Colors.grey.shade500 : const Color(0xFF1E4DB7),
                    ),
                  ),
                  Text(
                    duration,
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
            'Type: $busType',
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
                    // Normalize bus object keys for BusDetailsPage compatibility
                    final normalizedBus = {
                      ...bus,
                      'busNumber': busNumber,
                      'routeName': routeName,
                      'departureTime': departureTime,
                      'arrivalTime': arrivalTime,
                      'fare': fare,
                      'duration': duration,
                      'busType': busType,
                      'intermediate_stops': bus['intermediate_stops'],
                      'from_id': bus['from_id'],
                      'to_id': bus['to_id']
                    };
                    context.push('/bus_details', extra: normalizedBus);
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
