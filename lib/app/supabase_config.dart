import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://omyqqhehnljechencobm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9teXFxaGVobmxqZWNoZW5jb2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzNjczMTgsImV4cCI6MjA0Nzk0MzMxOH0.PYYP1D1MXfv-JEPL1qpdOAajAy8KauA9FGFvAb2_vyU',
  );
}
