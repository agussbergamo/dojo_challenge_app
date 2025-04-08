import 'api_service.dart';
import 'database_service.dart';
import 'movie_repository.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = await DatabaseService.getInstance();
  ApiService apiService = ApiService();
  MovieRepository movieRepository = MovieRepository(
    apiService: apiService,
    databaseService: databaseService,
  );

  runApp(
    MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: movieRepository.getPopularMovies(),
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
    ),
  );
}
