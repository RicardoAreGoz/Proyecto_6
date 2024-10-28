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
  List<Comentario> comentarios = [];
  List<String> categorias = [
    'Acción',
    'Aventura',
    'Catástrofe',
    'Ciencia Ficción',
    'Comedia',
    'Documental',
    'Drama',
    'Fantasía',
    'Musical',
    'Suspenso',
    'Terror',
    'Romance',
  ];

  int? selectedRating;
  final TextEditingController _commentController = TextEditingController(); // Controlador para el comentario

  @override
  void initState() {
    super.initState();
    fetchPeliculas();
    fetchCategorias();
    fetchComentarios();
  }

  Future<void> fetchPeliculas() async {
    try {
      final response = await _supabase.from('peliculas').select();
      if (response is List) {
        setState(() {
          peliculas = response;
        });
      } 
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  Future<void> fetchCategorias() async {
    try {
      final response = await _supabase.from('peliculas').select('categoria').single();
      if (response != null) {
        final List<dynamic> data = response as List<dynamic>;
        setState(() {
          categorias = data.map((e) => e['categoria'] as String).toSet().toList();
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchComentarios() async {
    try {
      final response = await _supabase
      .from('comentarios')
      .select()
      .order('created_at', ascending: false);
      if (response is List) {
        setState(() {
          comentarios = response.map((e) => Comentario.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> addComentario(String peliculaId, String comentario, int calificacion) async {
    final userId = Supabase.instance.client.auth.currentUser ?.id;
    if (userId != null) {
      try {
        await _supabase.from('comentarios').insert({
          'pelicula_id': peliculaId,
          'usuario_id': userId,
          'comentario': comentario,
          'calificacion': calificacion,
        });
        fetchComentarios();
      } catch (e) {
        print('Error añadiendo comentario: $e');
      }
    }
  }

  void clearFilters() {
    setState(() {
      selectedCategory = null;
      yearFilter = null;
    });
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
            ],
          ),
          SizedBox(height: 8), // Espacio entre los filtros
          // Filtro por año y botón para limpiar
          Row(
            children: [
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
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: clearFilters, // Llama a la función para limpiar filtros
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final data = peliculas[index];
                
                if (data['categoria'] == null || data['año'] == null) {
                  return Container(); // Si no tiene las propiedades necesarias, no mostrar nada
                }

                // Aplicar filtros
                if ((selectedCategory != null && data['categoria'] != selectedCategory) ||
                    (yearFilter != null && data['año'].toString() != yearFilter)) {
                  return Container(); // Si no coincide con los filtros, no mostrar nada
                }

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['titulo'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Actores Principales: ${data['actores']}'),
                        Text('País de Origen: ${data['pais']}'),
                        Text('Año de publicación: ${data['año']}'),
                        Text('Categoría: ${data['categoria']}'),
                        Text('Idioma Original: ${data['idioma']}'),
                        const SizedBox(height: 30),
                        // Sección de comentarios
                        const Text('Comentarios:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...comentarios
                            .where((comentario) => comentario.peliculaId == data['id'].toString())
                            .map((comentario) => ListTile(
                                  title: Text(comentario.comentario),
                                  subtitle: Text('Calificación: ${comentario.calificacion}'),
                                )),
                        TextField(
                          controller: _commentController, // Asignar el controlador al campo de texto
                          decoration: const InputDecoration(
                            labelText: 'Agregar un comentario',
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: selectedRating,
                              hint: const Text('Selecciona una calificación'),
                              items: List.generate(5, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedRating = value;
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedRating != null) {
                                  addComentario(data['id'].toString(), _commentController.text, selectedRating!); // Aquí se utiliza el operador de nulabilidad !
                                  _commentController.clear(); // Limpiar el campo de texto después de enviar el comentario
                                } else {
                                  // Mostrar un mensaje de error si no se seleccionó una calificación
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor, selecciona una calificación'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Enviar Comentario'),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class Comentario {
  final String id;
  final String peliculaId;
  final String usuarioId;
  final String comentario;
  final int calificacion;

  Comentario({
    required this.id,
    required this.peliculaId,
    required this.usuarioId,
    required this.comentario,
    required this.calificacion,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'].toString(),
      peliculaId: json['pelicula_id'].toString(),
      usuarioId: json['usuario_id'].toString(),
      comentario: json['comentario'],
      calificacion: json['calificacion'],
    );
  }
}