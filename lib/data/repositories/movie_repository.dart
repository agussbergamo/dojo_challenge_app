import '../datasource/remote/api_service.dart';
import '../datasource/local/database_service.dart';
import '../../domain/entities/movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieRepository {
  final ApiService apiService;
  final DatabaseService databaseService;
  final Connectivity connectivity;

  MovieRepository({
    required this.apiService,
    required this.databaseService,
    connectivityPlugin,
  }) : connectivity = connectivityPlugin ?? Connectivity();

  Future<List<Movie>> getPopularMovies() async {
    final connectivityResult = await connectivity.checkConnectivity();
    try {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return await databaseService.getMovies();
      } else {
        final movies = await apiService.getPopularMovies();
        for (var movie in movies) {
          await databaseService.insertMovie(movie);
        }
        return movies;
      }
    } catch (error) {
      throw Exception('Error fetching data');
    }
  }
}
