import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/peliculas';

  // Obtener la lista de películas
  Future<List<dynamic>> obtenerPeliculas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener las películas');
    }
  }

  // Agregar una nueva película
  Future<void> agregarPelicula(Map<String, dynamic> pelicula) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(pelicula),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al agregar la película');
    }
  }

  // Eliminar una película
  Future<void> eliminarPelicula(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la película');
    }
  }
}
