import 'movie.dart';
import 'package:floor/floor.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM Movie')
  Future<List<Movie>> getMovies();

  @Query('SELECT * FROM Movie WHERE id = :id')
  Stream<Movie?> getMovieById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovie(Movie movie);
}
