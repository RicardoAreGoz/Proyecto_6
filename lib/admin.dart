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
                MaterialPageRoute(builder: (context) => LoginPage()),
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
              return ListTile(
                title: Text(data['titulo']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Año de publicacion: ${data['año']}'),
                    Text('Actores principales: ${data['actores']}'),
                    Text('Categoria: ${data['categoria']}'),
                    Text('Idioma: ${data['idioma']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
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