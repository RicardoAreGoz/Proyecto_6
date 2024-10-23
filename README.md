<h1>Aplicacion de recomendacion de peliculas</h1>
<h3>Salinas Guardado Alexis Noe <br> Arellano González Ricardo <br> Course: Mobile Applications 2 <br> 10/24/2024 <br> Iriarte Martínez Carlos Alberto</h3>
<br>
<table>
  <tr>
    <th>Table of Contents</th>
  </tr>
  <tr>
    <th>Introduction</th>
  </tr>
  <tr>
    <th>Application Objective</th>
  </tr>
  <tr>
    <th>System Requirement</th>
  </tr>
  <tr>
    <th>Application Description</th>
  </tr>
  <tr>
    <th>Source Code</th>
  </tr>
  <tr>
    <th>Evidence Screenshots</th>
  </tr>
  <tr>
    <th>Results and Conclusion</th>
  </tr>
</table>
<br>
<h2>Introduction</h2>
<p>Mobile apps are a key part of modern life, and this project focuses on improving how users discover movies they'll love. By working on this app, we explore essential skills in mobile development, from intuitive design to delivering personalized experiences.</p>
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
```
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
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titulo',
      home: LoginPage(),
    );
  }
}

```
