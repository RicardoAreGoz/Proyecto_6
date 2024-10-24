import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esto para usar los inputFormatters
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditMoviePage extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const AddEditMoviePage({Key? key, this.movieData}) : super(key: key);

  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _yearController = TextEditingController();
  final _actorsController = TextEditingController();
  final _categoryController = TextEditingController();
  final _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.movieData != null) {
      _nameController.text = widget.movieData!['Titulo de la Pelicula'] ?? '';
      _countryController.text = widget.movieData!['Pais de origen'] ?? '';
      _yearController.text = (widget.movieData!['Año de estreno']?.toString() ?? '');
      _actorsController.text = widget.movieData!['Actores Principales'] ?? '';
      _categoryController.text = widget.movieData!['Categoria'] ?? '';
      _languageController.text = widget.movieData!['Idioma'] ?? '';
    }
  }

  Future<void> _saveMovie() async {
    final movieName = _nameController.text;
    final country = _countryController.text;
    final year = double.tryParse(_yearController.text) ?? 0; // Proporcionar un valor predeterminado
    final actors = _actorsController.text;
    final category = _categoryController.text;
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar: ${response.error!.message}'),
        ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al agregar: ${response.error!.message}'),
        ));
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: _actorsController,
              decoration: const InputDecoration(labelText: 'Actores Principales'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Categoria'),
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