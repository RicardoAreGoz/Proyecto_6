import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esto para usar los inputFormatters
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditMoviePage extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const AddEditMoviePage({Key? key, this.movieData}) : super(key: key);

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
    'Comedia',
    'Drama',
    'Terror',
    'Ciencia Ficción',
    'Romance',
    'Documental',
    // Agrega más categorías según sea necesario
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
    if (category != null && _categories.contains(category)) {
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
    final year = double.tryParse(_yearController.text);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMovie,
              child: const Text('Guardar Pelicula'),
            ),
          ],
        ),
      ),
    );
  }
}