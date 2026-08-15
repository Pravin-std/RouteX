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
  
  print('Fetching OpenAPI schema from: $url/rest/v1/');
  
  try {
    final response = await http.get(
      Uri.parse('$url/rest/v1/'),
      headers: {
        'apikey': key,
        'Authorization': 'Bearer $key',
      }
    );
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final paths = json['paths'] as Map<String, dynamic>;
      
      print('\n=== LIVE SUPABASE TABLES ===\n');
      final tables = paths.keys.map((k) => k.substring(1)).where((t) => t.isNotEmpty && t != 'rpc').toSet().toList();
      tables.sort();
      
      for (final table in tables) {
        print('TABLE: $table');
        
        final definitions = json['definitions'] as Map<String, dynamic>;
        if (definitions.containsKey(table)) {
          final props = definitions[table]['properties'] as Map<String, dynamic>;
          print('COLUMNS:');
          props.forEach((colName, colDetails) {
            final type = colDetails['type'] ?? colDetails['format'] ?? 'unknown';
            final desc = colDetails['description'] ?? '';
            print('  - $colName ($type) $desc');
          });
        }
        print('---------------------------');
      }
    } else {
      print('Error fetching schema: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
