import '../datasource/remote/api_service.dart';
import '../datasource/local/database_service.dart';
import '../../domain/entities/movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieRepository {
  final ApiService apiService;
  final DatabaseService databaseService;

  MovieRepository({required this.apiService, required this.databaseService});

  Future<List<Movie>> getPopularMovies() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return await databaseService.getMovies();
    } else {
      final movies = await apiService.getPopularMovies();
      for (var movie in movies) {
        await databaseService.insertMovie(movie);
      }
      return movies;
    }
  }
}
