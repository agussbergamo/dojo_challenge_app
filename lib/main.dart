import 'package:dojo_challenge_app/popular_movies.dart';

import 'api_service.dart';
import 'database_service.dart';
import 'movie_repository.dart';
import 'movies_bloc.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = await DatabaseService.getInstance();
  ApiService apiService = ApiService();
  MovieRepository movieRepository = MovieRepository(
    apiService: apiService,
    databaseService: databaseService,
  );
  MoviesBloc moviesBloc = MoviesBloc(movieRepository: movieRepository);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dojo Challenge App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/popular-movies':
            (BuildContext context) => PopularMovies(moviesBloc: moviesBloc),
      },
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Movies app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Wanna see some popular movies?'),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/popular-movies');
              },
              child: Text('Take me there!'),
            ),
          ],
        ),
      ),
    );
  }
}
