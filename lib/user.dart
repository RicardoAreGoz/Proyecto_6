import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class UserPage extends StatefulWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _movies = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final response = await widget._supabase
        .from('movies')
        .select()
        .ilike('title', '%$_searchQuery%');
    setState(() {
      _movies = response;
    });
  }

  Future<void> _recommendMovie(int movieId) async {
    await widget._supabase
        .from('movies')
        .update({'recommendations': Supabase.instance.rpc('increment', params: {'id': movieId})})
        .eq('id', movieId);
    _fetchMovies();
  }

  Future<void> _addComment(int movieId, String comment) async {
    await widget._supabase.from('comments').insert({
      'movie_id': movieId,
      'user_id': widget._supabase.auth.currentUser!.id,
      'comment': comment,
    });
    _fetchMovies();
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
              await widget._supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar películas...',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _fetchMovies();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text('Recomendaciones: ${movie['recommendations']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => _recommendMovie(movie['id']),
                  ),
                  onTap: () => _showCommentsDialog(movie['id']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(int movieId) {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comentarios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Escribe un comentario...',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _addComment(movieId, _commentController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Comentar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
