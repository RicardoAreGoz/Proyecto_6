import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'addEditProperty.dart';

class AdminPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase.from('peliculas').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final rawdata = snapshot.data!;
          return ListView.builder(
            itemCount: rawdata.length,
            itemBuilder: (context, index) {
              final data = rawdata[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                color: const Color.fromARGB(199, 230, 234, 236),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['titulo'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Año de publicación: ${data['año']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Actores principales: ${data['actores']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 96, 98, 100),
                        ),
                      ),
                      Text(
                        'Categoría: ${data['categoria']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 96, 98, 100),
                        ),
                      ),
                      Text(
                        'Idioma: ${data['idioma']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 96, 98, 100),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditMoviePage(movieData: data),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _eliminarPropiedad(data['id'], context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditMoviePage(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _eliminarPropiedad(int id, BuildContext context) async {
    final response = await _supabase.from('peliculas').delete().eq('id', id);

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Eliminada exitosamente'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar: ${response.error!.message}'),
      ));
    }
  }
}