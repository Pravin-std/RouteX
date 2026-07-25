import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favsJson = prefs.getString('favorites');
    if (favsJson != null) {
      final List<dynamic> decoded = jsonDecode(favsJson);
      setState(() {
        _favorites = decoded.map((e) => e as Map<String, dynamic>).toList();
      });
    } else {
      // Mock data if empty
      setState(() {
        _favorites = [
          {'from': 'Salem', 'to': 'Coimbatore'},
          {'from': 'Tiruchengode', 'to': 'Edappadi'},
        ];
      });
      _saveFavorites();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(_favorites));
  }

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Favorite Routes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final route = _favorites[index];
                return _buildFavoriteCard(route, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            'No favorites yet',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Save routes to find them easily',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> route, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus, color: Color(0xFFFF9800)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${route['from']} → ${route['to']}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Tap to search this route',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeFavorite(index),
          ),
        ],
      ),
    );
  }
}
