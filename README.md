<h1>Movie Recomendation Application</h1>
<h3>Salinas Guardado Alexis Noe <br> Arellano González Ricardo <br> Course: Mobile Applications 2 <br> 10/24/2024 <br> Iriarte Martínez Carlos Alberto</h3>
<br>
<table>
  <tr> <th>Table of Contents</th> </tr>
  <tr> <th>Introduction</th> </tr>
  <tr> <th>Application Objective</th> </tr>
  <tr> <th>System Requirement</th> </tr>
  <tr> <th>Application Description</th> </tr>
  <tr> <th>Source Code</th> </tr>
  <tr> <th>Evidence Screenshots</th> </tr>
  <tr> <th>Results and Conclusion</th> </tr>
</table>
<br>
<h2>Introduction</h2>
<p>The present project aims to develop a movie recommendation application designed to offer users an easy and enriching browsing experience. The application will feature two distinct roles, each with specific functionalities tailored to the users' roles. To carry out this development, tools such as Supabase, Flutter, and GitHub have been utilized, facilitating data management, the creation of attractive interfaces, and version control of the project. Through this application, we seek to create a simplified movie search experience and provide recommendations that enhance the user's overall experience.</p>
<br>
<h2>Application Objective</h2>
<p>The main goal of this app is to help users find movies they enjoy by offering personalized recommendations based on their tastes. It aims to make discovering new movies fun and effortless.</p>
<br>
<h2>System Requirements</h2>
<ul>
  <li>Flutter Version: 3.0.0 or higher</li>
  <li>Dependecies: http, provider, sher_preferences, supabase_auth, supabase_core, supabase_flutter</li>
  <li>Tools: VS Code, Supabase, Git for version control</li>
</ul>

<h2>Application Description</h2>
<p>The movie recommendation app is designed to help users deiscover new films based on their preferences. By analyzing usr behavior, such as movie ratings and favorites, the app generates personalized reommendations tailored to each user's unique tastes. With an intuitive interface, users can easily search for movies, view detailed information, rate and review films, and save theit favorites for later. <br> The app leverages a modern and dynamic design, unsuring a smooth and engagin user experiences. It integrates Supabse for user authentication and data sotrage, ensuring secure access to personalized movie suggestions across devices.</p>
<br>
<h2>Source Code</h2>
<h3>main.dart</h3>

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
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titulo',
      home: LoginPage(),
    );
  }
}
```
<h3>Login.dart</h3>

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'registro.dart';
import 'administrator.dart';
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
      .from('')
      .select('')
      .eq('id', userId)
      .single();

      final role = profile['role'];

      if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserPage()),
        );
      } else if (role == 'administrator') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdministratorPage()),
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
          height: 250,
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
<h3>registro.dart</h3>

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
  final _roleController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            TextField(
              controller: _roleController,
              decoration:
                  const InputDecoration(labelText: 'Rol (Usuario o Administrador)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
```
<h3>administrador.dart</h3>

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class AdministratorPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  const AdministratorPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión dentro del onPressed
              await _supabase.auth.signOut();
              // Redirigir al login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', _supabase.auth.currentUser!.id)
            .single(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data as Map<String, dynamic>;
          return Center(
            child: Text('Bienvenido, ${userData['full_name']}',
                style: const TextStyle(fontSize: 24)),
          );
        },
      ),
    );
  }
}
```
<h3>user.dart</h3>

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class UserPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  const UserPage({super.key});


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
      body: FutureBuilder(
        future: _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', _supabase.auth.currentUser!.id)
            .single(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data as Map<String, dynamic>;
          return Center(
            child: Text('Bienvenido, ${userData['full_name']}',
                style: const TextStyle(fontSize: 24)),
          );
        },
      ),
    );
  }
}
```
