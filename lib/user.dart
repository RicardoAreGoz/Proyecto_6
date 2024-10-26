import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? selectedCategory;
  String? yearFilter;
  List<dynamic> peliculas = [];
  List<String> categorias = [    
    'Acción',
    'Comedia',
    'Drama',
    'Terror',
    'Ciencia Ficción',
    'Romance',
    'Documental',]; // Lista para almacenar categorías

  @override
  void initState() {
    super.initState();
    fetchPeliculas();
    fetchCategorias();
  }

  Future<void> fetchPeliculas() async {
    try {
      final response = await _supabase.from('peliculas').select();
      if (response is List) {
        setState(() {
          peliculas = response;
        });
      } else {
        throw Exception('Error fetching movies: $response');
      }
    } catch (e) {
      print('Error fetching movies: $e');
      // Aquí puedes mostrar un mensaje de error en la UI si lo deseas
    }
  }

Future<void> fetchCategorias() async {
  try {
    final response = await _supabase
        .from('peliculas')
        .select('categoria')
        .single();

    if (response == null) {
      final List<dynamic> data = response as List<dynamic>;
      setState(() {
        categorias = data.map((e) => e['categoria'] as String).toSet().toList();
      });
    } else {
      
    }
  } catch (e) {
    print('Error fetching categories: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Usuario'),
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
      body: Column(
        children: [
          // Filtros
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: Text('Selecciona una categoría'),
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categorias.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Año de publicación',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      yearFilter = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final data = peliculas[index];

                // Verifica que los datos tengan las propiedades necesarias
                if (data['categoria'] == null || data['año'] == null) {
                  return Container(); // Si no tiene las propiedades necesarias, no mostrar nada
                }

                // Aplicar filtros
                if ((selectedCategory != null && data['categoria'] != selectedCategory) ||
                    (yearFilter != null && data['año'].toString() != yearFilter)) {
                  return Container(); // Si no coincide con los filtros, no mostrar nada
                }

                return ListTile(
                  title: Text(data['titulo']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Año de publicación: ${data['año']}'),
                      Text('Actores principales: ${data['actores']}'),
                      Text('Categoría: ${data['categoria']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}