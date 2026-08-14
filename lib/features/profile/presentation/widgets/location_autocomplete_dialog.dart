import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationAutocompleteDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final List<String> Function(String query) getSuggestions;
  final ValueChanged<String> onSelected;

  const LocationAutocompleteDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.getSuggestions,
    required this.onSelected,
  });

  @override
  State<LocationAutocompleteDialog> createState() => _LocationAutocompleteDialogState();
}

class _LocationAutocompleteDialogState extends State<LocationAutocompleteDialog> {
  late TextEditingController _searchController;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialValue
    );
    _suggestions = widget.getSuggestions(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _suggestions = widget.getSuggestions(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using simple dialog with constrained height for better responsive behavior
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: _suggestions.isEmpty
                  ? Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            widget.onSelected(suggestion);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
