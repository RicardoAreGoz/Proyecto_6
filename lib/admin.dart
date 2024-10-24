import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'addEditProperty.dart';

class AdminPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _future = Supabase.instance.client.from('peliculas').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Admin'),
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
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navegar a la página de agregar/editar propiedad
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
          // Navegar a la página de agregar propiedad
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
