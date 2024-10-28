import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchMovies() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/peliculas'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load movies');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://swtfclileswocqlkridr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN3dGZjbGlsZXN3b2NxbGtyaWRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0OTE4MzIsImV4cCI6MjA0NDA2NzgzMn0.57l_SskUVP27-FHPsz4FXbTRn7lOfRb_gt7lOB4Qs5I',
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titulo',
      home: LoginPage(),
    );
  }
}
