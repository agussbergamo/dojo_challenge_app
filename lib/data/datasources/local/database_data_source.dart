import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie_recommendation.dart';

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
  Future<List<Movie>> getMovies({
    required Endpoint endpoint,
    int? movieId,
  }) async {
    switch (endpoint) {
      case Endpoint.popular:
        return _getPopularMovies();
      case Endpoint.topRated:
        return _getTopRatedMovies();
      case Endpoint.recommendations:
        return _getRecommendationsForMovie(movieId);
    }
  }

  Future<List<Movie>> _getPopularMovies() async {
    return await database.movieDao.getPopularMovies();
  }

  Future<List<Movie>> _getTopRatedMovies() async {
    return await database.movieDao.getTopRatedMovies();
  }

  Future<List<Movie>> _getRecommendationsForMovie(movieId) async {
    final recommendedIds = await database.movieRecommendationDao
        .getRecommendedIds(movieId);
    final movies = <Movie>[];
    for (final id in recommendedIds) {
      final movie = await database.movieDao.getMovieById(id);
      if (movie != null) {
        movies.add(movie);
      }
    }
    return movies;
  }

  Future<void> insertMovie(Movie movie) async {
    await database.movieDao.insertMovie(movie);
  }

  Future<void> insertRecommendedMovie({
    required int baseMovieId,
    required Movie recommendedMovie,
    required int order, 
  }) async {
    await database.movieDao.insertMovie(recommendedMovie);
    final relation = MovieRecommendation(baseMovieId, recommendedMovie.id, order);
    await database.movieRecommendationDao.insertRecommendation(relation);
  }

  Future<void> deleteMoviesByType(String movieType) async {
    await database.movieDao.deleteMoviesByType(movieType);
  }

  Future<void> deleteRecommendationsByMovieType(String movieType) async {
    await database.movieRecommendationDao.deleteRecommendationsByMovieType(
      movieType,
    );
  }
}
