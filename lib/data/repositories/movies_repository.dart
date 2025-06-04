import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:dojo_challenge_app/domain/repositories/i_movie_repository.dart';

import '../datasources/remote/api_data_source.dart';
import '../datasources/local/database_data_source.dart';
import '../../domain/entities/movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MoviesRepository implements IMoviesRepository {
  final ApiDataSource apiDataSource;
  final DatabaseDataSource databaseDataSource;
  final FirestoreDataSource firestoreDataSource;
  final Connectivity connectivity;

  MoviesRepository({
    required this.apiDataSource,
    required this.databaseDataSource,
    required this.firestoreDataSource,
    connectivityPlugin,
  }) : connectivity = connectivityPlugin ?? Connectivity();

  @override
  Future<List<Movie>> getMovies({
    required Endpoint endpoint,
    DataSource? dataSource,
    int? movieId,
  }) async {
    final resolvedSource = dataSource ?? await _resolveDataSource();

    switch (resolvedSource) {
      case DataSource.api:
        final movies = await apiDataSource.getMovies(
          endpoint: endpoint,
          movieId: movieId,
        );
        await _cacheMovies(
          movies: movies,
          endpoint: endpoint,
          baseMovieId: movieId,
        );
        return movies;

      case DataSource.firestore:
        return await firestoreDataSource.getMovies(
          endpoint: endpoint,
          movieId: movieId,
        );

      case DataSource.local:
        return await databaseDataSource.getMovies(
          endpoint: endpoint,
          movieId: movieId,
        );
    }
  }

  Future<DataSource> _resolveDataSource() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none)
        ? DataSource.local
        : DataSource.api;
  }

  Future<void> _cacheMovies({
    required List<Movie> movies,
    required Endpoint endpoint,
    int? baseMovieId,
  }) async {
    if (endpoint != Endpoint.recommendations) {
      await databaseDataSource.deleteRecommendationsByMovieType(endpoint.value);
      await firestoreDataSource.deleteRecommendationsByMovieType(
        endpoint.value,
      );
      await databaseDataSource.deleteMoviesByType(endpoint.value);
      await firestoreDataSource.deleteMoviesByType(endpoint.value);
    }

    for (int i = 0; i < movies.length; i++) {
      final movie = movies[i];
      await databaseDataSource.insertMovie(movie);
      await firestoreDataSource.insertMovie(movie);

      if (endpoint == Endpoint.recommendations && baseMovieId != null) {
        await databaseDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: movie,
          order: i,
        );
        await firestoreDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: movie,
          order: i,
        );
      }
    }
  }
}
