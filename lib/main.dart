import 'dart:convert' as convert;
import 'database.dart';
import 'movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<List<Movie>> getPopularMovies() async {
    const String endpoint = 'https://api.themoviedb.org/3/movie/popular';
    const String apiKey = '?api_key=';
    const String apiKeyValue = '025aa98c350d497beb053d9b5e169637';

    final connectivityResult = await (Connectivity().checkConnectivity());
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      final dbMovies = await database.movieDao.getMovies();
      if (dbMovies.isNotEmpty) {
        return dbMovies;
      }
      return <Movie>[];
    } else {
      final url = Uri.parse('$endpoint$apiKey$apiKeyValue');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var results = jsonResponse['results'];
        if (results != null) {
          final jsonMovies = List<Movie>.from(
            results.map((movie) => Movie.fromJson(movie)),
          );
          for (var movie in jsonMovies) {
            database.movieDao.insertMovie(movie);
          }
          return jsonMovies;
        } else {
          return <Movie>[];
        }
      } else {
        return <Movie>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: getPopularMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies found'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(snapshot.data![index].title));
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
