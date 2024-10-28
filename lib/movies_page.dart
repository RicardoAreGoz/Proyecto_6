import 'package:flutter/material.dart';
import 'api_service.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final ApiService apiService = ApiService();
  List<dynamic> peliculas = [];

  @override
  void initState() {
    super.initState();
    obtenerPeliculas();
  }

  Future<void> obtenerPeliculas() async {
    try {
      final peliculasList = await apiService.obtenerPeliculas();
      setState(() {
        peliculas = peliculasList;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> agregarPelicula() async {
    try {
      Map<String, dynamic> nuevaPelicula = {
        "titulo": "Nueva Película",
        "director": "Director Desconocido",
        "año": 2024,
      };
      await apiService.agregarPelicula(nuevaPelicula);
      obtenerPeliculas();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> eliminarPelicula(int id) async {
    try {
      await apiService.eliminarPelicula(id);
      obtenerPeliculas();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: agregarPelicula,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          final pelicula = peliculas[index];
          return ListTile(
            title: Text(pelicula['titulo']),
            subtitle: Text('${pelicula['director']} (${pelicula['año']})'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => eliminarPelicula(pelicula['id']),
            ),
          );
        },
      ),
    );
  }
}
