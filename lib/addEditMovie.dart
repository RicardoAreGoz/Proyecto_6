import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esto para usar los inputFormatters
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditMoviePage extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const AddEditMoviePage({super.key, this.movieData});

  @override
  _AddEditMoviePagePageState createState() => _AddEditMoviePagePageState();
}

class _AddEditMoviePagePageState extends State<AddEditMoviePage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _yearController = TextEditingController();
  final _actorsController = TextEditingController();
  String? _selectedCategory; // Cambiar a String para el dropdown
  final _languageController = TextEditingController();

  // Lista de categorías predefinidas
  final List<String> _categories = [
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

  @override
  void initState() {
    super.initState();
    if (widget.movieData != null) {
      _nameController.text = widget.movieData!['titulo'] ?? '';
      _countryController.text = widget.movieData!['pais'] ?? '';
      _yearController.text = widget.movieData!['año']?.toString() ?? '';
      _actorsController.text = widget.movieData!['actores'] ?? '';

      String? category = widget.movieData!['categoria'];
      if (_categories.contains(category)) {
        _selectedCategory = category;
      } else {
        _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
      }

      _languageController.text = widget.movieData!['idioma'] ?? '';
    }
  }

  Future<void> _saveMovie() async {
    final movieName = _nameController.text;
    final country = _countryController.text;
    final year = int.tryParse(_yearController.text);
    final actors = _actorsController.text;
    final category = _selectedCategory; // Usar variable para el dropdown
    final language = _languageController.text;

    if (widget.movieData != null) {
      final id = widget.movieData!['id'];
      final response = await _supabase.from('peliculas').update({
        'titulo': movieName,
        'pais': country,
        'año': year,
        'actores': actors,
        'categoria': category,
        'idioma': language,
      }).eq('id', id);

      if (response.error != null) {
        // Manejar error aquí
      }
    } else {
      final response = await _supabase.from('peliculas').insert({
        'titulo': movieName,
        'pais': country,
        'año': year,
        'actores': actors,
        'categoria': category,
        'idioma': language,
      });

      if (response.error != null) {
        // Manejar error aquí
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieData == null ? 'Agregar Pelicula' : 'Editar Pelicula'),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 600,
          decoration: BoxDecoration(
            color: const Color.fromARGB(199, 230, 234, 236),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Titulo de la Pelicula'),
              ),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Pais de origen'),
              ),
              TextField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Año de estreno'),
                keyboardType: TextInputType.number, // Teclado numérico
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly // Solo permite dígitos
                ],
              ),
              TextField(
                controller: _actorsController,
                decoration: const InputDecoration(labelText: 'Actores Principales'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              TextField(
                controller: _languageController,
                decoration: const InputDecoration(labelText: 'Idioma'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: _saveMovie,
                child: const Text('Guardar Pelicula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}