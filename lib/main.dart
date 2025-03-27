import 'dart:convert' as convert;

import 'package:dojo_challenge_app/movie.dart';
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

    final url = Uri.parse('$endpoint$apiKey$apiKeyValue');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var jsonMovies = jsonResponse['results'];
      if (jsonMovies != null) {
        return List<Movie>.from(
          jsonMovies.map((movie) => Movie.fromJson(movie)),
        );
      } else {
        return <Movie>[];
      }
    } else {
      return <Movie>[];
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
