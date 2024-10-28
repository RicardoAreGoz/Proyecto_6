import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class AdministratorPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

   AdministratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión dentro del onPressed
              await _supabase.auth.signOut();
              // Redirigir al login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', _supabase.auth.currentUser!.id)
            .single(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data as Map<String, dynamic>;
          return Center(
            child: Text('Bienvenido, ${userData['full_name']}',
                style: const TextStyle(fontSize: 24)),
          );
        },
      ),
    );
  }
}
