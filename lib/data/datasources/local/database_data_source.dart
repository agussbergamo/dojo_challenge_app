import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';

import 'database.dart';
import '../../../domain/entities/movie.dart';

class DatabaseDataSource implements IDataSource {
  static DatabaseDataSource? _instance;
  final AppDatabase database;

  DatabaseDataSource._(this.database);

  DatabaseDataSource.test(this.database);

  static Future<DatabaseDataSource> getInstance() async {
    if (_instance == null) {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      _instance = DatabaseDataSource._(database);
    }
    return _instance!;
  }

  @override
  Future<List<Movie>> getMovies({required Endpoint endpoint}) async {
    switch (endpoint) {
      case Endpoint.popular:
        return _getPopularMovies();
      case Endpoint.topRated:
        return _getTopRatedMovies();
    }
  }

  Future<List<Movie>> _getPopularMovies() async {
    return await database.movieDao.getPopularMovies();
  }

  Future<List<Movie>> _getTopRatedMovies() async {
    return await database.movieDao.getTopRatedMovies();
  }

  Future<void> insertMovie(Movie movie) async {
    await database.movieDao.insertMovie(movie);
  }
}
