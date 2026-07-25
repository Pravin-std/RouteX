import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:routex/l10n/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../backend/providers/user_profile_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  List<Map<String, String>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final String? searchesJson = prefs.getString('recent_searches');
    if (searchesJson != null) {
      final List<dynamic> decoded = jsonDecode(searchesJson);
      setState(() {
        _recentSearches = decoded
            .map((e) => Map<String, String>.from(e))
            .toList();
      });
    }
  }

  Future<void> _saveRecentSearch(String from, String to) async {
    final search = {'from': from, 'to': to};
    setState(() {
      _recentSearches.removeWhere((s) => s['from'] == from && s['to'] == to);
      _recentSearches.insert(0, search);
      if (_recentSearches.length > 3) {
        _recentSearches.removeLast(); // Keep top 3
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('recent_searches', jsonEncode(_recentSearches));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapStops() {
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
  }

  void _searchBuses(AppLocalizations l10n) {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterBothStops)));
      return;
    }

    _saveRecentSearch(_fromController.text, _toController.text);

    context.push(
      '/available_buses',
      extra: {'from': _fromController.text, 'to': _toController.text},
    );
  }

  void _loadRecentSearch(String from, String to) {
    _fromController.text = from;
    _toController.text = to;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(l10n),
              SizedBox(height: 24.h),
              _buildGreeting(l10n),
              SizedBox(height: 24.h),
              _buildSearchCard(l10n),
              SizedBox(height: 24.h),
              _buildRecentSearches(l10n),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    final currentLocale = ref.watch(languageProvider);
    final isTamil = currentLocale.languageCode == 'ta';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_bus,
                color: const Color(0xFFFF9800),
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'RouteX',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ref.read(languageProvider.notifier).toggleLanguage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 16.sp,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isTamil ? 'English' : 'தமிழ்',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(AppLocalizations l10n) {
    final profileState = ref.watch(userProfileProvider);
    String displayName = '';

    profileState.when(
      data: (profile) {
        if (profile != null) {
          if (profile.fullName.isNotEmpty) {
            displayName = profile.fullName;
          } else if (profile.email.isNotEmpty) {
            displayName = profile.email;
          } else {
            displayName = 'User';
          }
        }
      },
      loading: () {},
      error: (e, st) {},
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayName.isEmpty ? l10n.helloGuest : l10n.helloUser(displayName),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.findBusSubtitle,
            style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputBox(l10n.enterDepartureStop, _fromController),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _swapStops,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.swap_vert_rounded,
                color: Colors.grey.shade600,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _buildInputBox(l10n.enterDestinationStop, _toController),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () => _searchBuses(l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4DB7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.findBuses,
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
    );
  }

  Widget _buildInputBox(String hint, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade400,
            size: 20.sp,
          ),
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 16.sp, color: Colors.grey.shade600),
              SizedBox(width: 8.w),
              Text(
                l10n.recentSearches,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (_recentSearches.isEmpty)
            Text(
              l10n.noRecentSearches,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp),
            )
          else
            ..._recentSearches.map(
              (search) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: GestureDetector(
                  onTap: () =>
                      _loadRecentSearch(search['from']!, search['to']!),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Text(
                      '${search['from']} → ${search['to']}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
