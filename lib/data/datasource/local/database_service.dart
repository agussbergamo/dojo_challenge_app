import 'database.dart';
import '../../../domain/entities/movie.dart';

class DatabaseService {
  static DatabaseService? _instance;
  final AppDatabase database;

  DatabaseService._(this.database);

  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      _instance = DatabaseService._(database);
    }
    return _instance!;
  }

  Future<List<Movie>> getMovies() async {
    return await database.movieDao.getMovies();
  }

  Future<void> insertMovie(Movie movie) async {
    await database.movieDao.insertMovie(movie);
  }
}
