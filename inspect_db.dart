import 'package:supabase/supabase.dart';

Future<void> main() async {
  final supabase = SupabaseClient(
    'https://schzkkbdqtuaqahrpcdz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaHpra2JkcXR1YXFhaHJwY2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ3NzM0MzcsImV4cCI6MjEwMDM0OTQzN30.RofE2IHd7NbXz9V1rIFTbB0lhN6VgPnUS5RyRoXJ19g'
  );

  final tables = ['tickets', 'profiles', 'buses'];

  for (final table in tables) {
    try {
      final res = await supabase.from(table).select().limit(1);
      print('Table $table: OK. Columns: ${res.isNotEmpty ? res.first.keys : 'empty'}');
    } catch (e) {
      print('Table $table error: $e');
    }
  }
}
