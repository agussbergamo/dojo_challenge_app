import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/data/datasource/remote/firestore_service.dart';

import '../datasource/remote/api_service.dart';
import '../datasource/local/database_service.dart';
import '../../domain/entities/movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieRepository {
  final ApiService apiService;
  final DatabaseService databaseService;
  final FirestoreService firestoreService;
  final Connectivity connectivity;

  MovieRepository({
    required this.apiService,
    required this.databaseService,
    required this.firestoreService,
    connectivityPlugin,
  }) : connectivity = connectivityPlugin ?? Connectivity();

  Future<List<Movie>> getPopularMovies({DataSource? dataSource}) async {
    final resolvedSource = dataSource ?? await _resolveDataSource();

    switch (resolvedSource) {
      case DataSource.api:
        final movies = await apiService.getPopularMovies();
        await _cacheMovies(movies);
        return movies;

      case DataSource.firestore:
        return await firestoreService.getMovies();

      case DataSource.local:
        return await databaseService.getMovies();
    }
  }

  Future<DataSource> _resolveDataSource() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none)
        ? DataSource.local
        : DataSource.api;
  }

  Future<void> _cacheMovies(List<Movie> movies) async {
    for (var movie in movies) {
      await databaseService.insertMovie(movie);
      await firestoreService.saveMovie(movie);
    }
  }
}
