import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() async {
  // Read .env file for URL and Key
  final envFile = File('.env');
  if (!await envFile.exists()) {
    print('No .env file found');
    return;
  }
  
  String url = '';
  String key = '';
  
  final lines = await envFile.readAsLines();
  for (final line in lines) {
    if (line.startsWith('SUPABASE_URL=')) url = line.substring(13);
    if (line.startsWith('SUPABASE_ANON_KEY=')) key = line.substring(18);
  }
  
  if (url.isEmpty || key.isEmpty) {
    print('Missing credentials in .env');
    return;
  }
  
  print('Probing live Supabase tables at: $url\n');
  
  final tablesToProbe = [
    'bus_routes',
    'stops',
    'buses',
    'schedules',
    'profiles',
    'tickets',
    'bookings',
    'user_roles',
    'payments',
    'routes'
  ];
  
  for (final table in tablesToProbe) {
    print('--- Probing table: $table ---');
    try {
      final response = await http.get(
        Uri.parse('$url/rest/v1/$table?limit=1'),
        headers: {
          'apikey': key,
          'Authorization': 'Bearer $key',
        }
      );
      
      print('Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('Result: Table exists and is accessible to anon role.');
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          print('Columns detected from sample row:');
          final row = data.first as Map<String, dynamic>;
          row.forEach((col, val) {
            print('  - $col (${val.runtimeType})');
          });
        } else {
          print('Result: Table is empty or no rows match RLS policy for anon. Cannot determine columns via GET.');
        }
      } else {
        final body = response.body;
        if (body.contains('42P01') || body.contains('PGRST205')) {
          print('Result: Table DOES NOT EXIST or anon has no SELECT grant.');
        } else {
          print('Result: $body');
        }
      }
    } catch (e) {
      print('Exception: $e');
    }
    print('');
  }
}
