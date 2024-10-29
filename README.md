<h4 id='image-1'>
<center>

<img src="images/README/upenlogo.jpg" alt="usercommented-screen" width="200"/>
<center> Image 1. University Logo </center>
</center>

# Movie Recommendation Application

**Students Names**: 
Alexis Noe Salinas Guardado  
Ricardo Arellano González  
**Subject**: Mobile Programming 2  
**Career**: Software Engineering    
**Group**: ISOFT-9  
**Teacher's Name**: Carlos Alberto Iriarte Martinez  
### Universidad Politécnica del Estado de Nayarit   

## Table of Contents
1. [Introduction](#introduction)
2. [Application Objective](#application-objective)
3. [System Requirements](#system-requirements)
4. [Application Description](#application-description)
5. [Source Code](#source-code)
6. [Evidence Screenshots](#evidence-screenshots)
7. [Results and Conclusions](#results-and-conclusions)
7. [APK](#apk)

## Introduction
The present project aims to develop a movie recommendation application designed to offer users an easy and enriching browsing experience. The application will feature two distinct roles, each with specific functionalities tailored to the users' roles. To carry out this development, tools such as Supabase, Flutter, and GitHub have been utilized, facilitating data management, the creation of attractive interfaces, and version control of the project. Through this application, we seek to create a simplified movie search experience and provide recommendations that enhance the user's overall experience.


## Application Objective
We aim to create a user-friendly application that has two roles within it, each capable of performing different tasks. The administrator role will be able to make changes, edit, and add new movies that can then be viewed by the user. On the other hand, on the user's page, it is necessary for them to be able to see the details of existing movies, make comments, and rate the movies they can watch.


## System Requirements

### Technical Requirements

- **Flutter Version:** 3.24.4 or higher  
- **Dart SDK Version:** >=3.3.4 < 4.0.0  
- **Dependencies:** provider, shared_preferences, supabase_auth, supabase_core, supabase_flutter.  
- **Tools:** Visual Studio Code, Supabase, GitHub and Git for version control.

### Functional Requirements
- Use of an external API to search for movie information.
- Authentication with Supabase.
    - User (view, recommend) and administrator (edit or delete recommendations).
- CRUD for movies.
    - The movie must have a title, country, release year, main actors, category, and language.
- ListView to display recommendations.
- Filter by category or year.
- Rating and comments system for each movie.


## Application Description
This application features a simple and easy-to-understand design. It connects to Supabase to perform various actions, starting with user login and registration. Upon opening the application, the login screen is presented, where an existing user can enter their credentials. A query is made to Supabase, and if the user exists, they will be redirected to their corresponding page (User  or Administrator). If the user is not yet registered, they can access the registration section and enter their information. Subsequently, an email will be sent to verify their account, allowing them to log in.  
On the user page, there is a list view that allows users to see the number of movies available in the database. At the top of the screen, two filters are presented: one for movie categories and another for year. The user can select one or both filters, and the application will automatically perform the search. Once they find their movie, they can clear the results using the button next to the filters. Additionally, on this page, users have the option to leave comments and rate a movie to recommend it; these comments will be displayed immediately below the movie's description.  
On the other hand, on the administrator page, although there is also a list view showing the movies, the functions differ. The administrator can edit movie details, delete movies directly from the database, or add new movies.


## Source Code

### main

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://swtfclileswocqlkridr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN3dGZjbGlsZXN3b2NxbGtyaWRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0OTE4MzIsImV4cCI6MjA0NDA2NzgzMn0.57l_SskUVP27-FHPsz4FXbTRn7lOfRb_gt7lOB4Qs5I',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ReelSelect',
      home: LoginPage(),
    );
  }
}
```

### Login.dart

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'registro.dart';
import 'admin.dart';
import 'user.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = response.user!.id;
      final profile = await _supabase
      .from('profiles')
      .select('role')
      .eq('id', userId)
      .single();

    final role = profile['role'];

      if (role == 'usuario') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        throw 'Rol no reconocido';
      }
        } catch (error) {
      print('Error de autenticación: $error');
    }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: Container(
          width: 400,
          height: 420,
          decoration: BoxDecoration(
            color:const Color.fromARGB(199, 230, 234, 236),
            borderRadius: BorderRadius.circular(16),
            ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 25,),
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
                    fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: _login,
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 6,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  foregroundColor: const Color.fromARGB(255, 42, 45, 71),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Registrarse'),)
            ],
          ),
        ),
      ),
    );
  }
}
```

### registro.dart

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  var _roleController;

  Future<void> _register() async {
    final fullname = _fullNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    const role = "usuario";

    try {
      // Crear usuario en Supabase auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;

      if (userId != null) {
        // Insertar el rol en la tabla de perfiles
        await _supabase.from('profiles').insert({
          'id': userId,
          'role': role,
          'pass': password,
        });

        print('Usuario registrado exitosamente con rol: $role');
      }
    } catch (error) {
      print('Error al registrar usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Center(
        child: Container(
          width: 400,
          height: 420,
          decoration: BoxDecoration(
            color: const Color.fromARGB(199, 230, 234, 236),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
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
                onPressed: _register,
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  foregroundColor: const Color.fromARGB(255, 42, 45, 71),     
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Volver a la pagina de inicio de sesión
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### admin.dart

```dart
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
```

### addEditMovie.dart

```dart 
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
```

### user.dart

```dart
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

  Map<String, int?> selectedRatings = {};
  Map<String, TextEditingController> commentControllers = {};

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
  void dispose() {
    // Limpiar los controladores al salir de la página
    commentControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
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

                if (!commentControllers.containsKey(data['id'].toString())) {
                    commentControllers[data['id'].toString()] = TextEditingController();
                }

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
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Categoría: ${data['categoria']}',
                            style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 42, 45, 71),
                           ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          'Actores Principales: ${data['actores']}',
                            style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 96, 98, 100),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          'País de Origen: ${data['pais']}',
                            style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 96, 98, 100),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          'Año de publicación: ${data['año']}',
                            style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 96, 98, 100),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text('Idioma Original: ${data['idioma']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 96, 98, 100),
                            ),
                          ),
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
                          controller: commentControllers[data['id'].toString()], // Asignar el controlador único
                          decoration: const InputDecoration(
                            labelText: 'Agregar un comentario',
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: selectedRatings[data['id'].toString()],
                              hint: const Text('Selecciona una calificación'),
                              items: List.generate(5, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedRatings[data['id'].toString()] = value; // Guarda la calificación en el mapa
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedRatings[data['id'].toString()] != null) {
                                  addComentario(data['id'].toString(), commentControllers[data['id'].toString()]!.text, selectedRatings[data['id'].toString()]!);
                                  commentControllers[data['id'].toString()]!.clear(); // Limpiar el campo de texto después de enviar el comentario
                                } else {
                                  // Mostrar un mensaje de error si no se seleccionó una calificación
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor, selecciona una calificación'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Comentar'),
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
```

## Evidence Screenshots

<h4 id='image-2'>
<center>

<img src="images/README/login.jpg" alt="login-screen" width="200"/>
<center> Image 2. LogIn Screen </center>
</center>

<h4 id='image-3'>
<center>

<img src="images/README/signup.jpg" alt="signup-screen" width="200"/>
<center> Image 3. SignUp Screen </center>
</center>

<h4 id='image-4'>
<center>

<img src="images/README/adminlistview.jpg" alt="adminlistview-screen" width="200"/>
<center> Image 4. Admin ListView </center>
</center>

<h4 id='image-5'>
<center>

<img src="images/README/addingamovie.jpg" alt="addingmovie-screen" width="200"/>
<center> Image 5. Admin Adding New Movie </center>
</center>

<h4 id='image-6'>
<center>

<img src="images/README/editingamovie.jpg" alt="editingmovie-screen" width="200"/>
<center> Image 6. Admin Editing Movie </center>
</center>

<h4 id='image-7'>
<center>

<img src="images/README/userlistview.jpg" alt="userlistview-screen" width="200"/>
<center> Image 7. User ListView </center>
</center>

<h4 id='image-8'>
<center>

<img src="images/README/userfiltering.jpg" alt="userfiltering-screen" width="200"/>
<center> Image 8. User Filtering </center>
</center>

<h4 id='image-9'>
<center>

<img src="images/README/usercommenting.jpg" alt="usercommenting-screen" width="200"/>
<center> Image 9. User Commenting </center>
</center>

<h4 id='image-10'>
<center>

<img src="images/README/usercommented.jpg" alt="usercommented-screen" width="200"/>
<center> Image 10. User Commented </center>
</center>

## Results and Conclusions
Working on this application was complicated. Using GitHub in a new way proved challenging, and the different versions of Flutter we were using caused delays in development. Resolving compatibility issues and adapting to this new way of working took time.
Regarding the other tools, the experience was smoother, as we had already covered most of them in the course.
The final result is satisfactory for us, as it seems we have met most of the requirements and achieved this appropriately, from user login and registration to movie comments and ratings.
From this experience, we concluded that implementing a version control service under the right conditions can be a decisive factor in achieving an efficient impact when working on a project. The advantages offered by version control enhance communication within the team, transforming it into a high-performance group. Additionally, it allows for an independent workspace while collaborating with colleagues, making the act of working simpler and even more interesting when implementing new technologies.

## APK
https://drive.google.com/drive/folders/1brzrYgpIkB98jTdCXMjcPRlCUvHKUl9t?usp=sharing 

**Admin Profile**: admin@gmail.com  
**Password**: 123456