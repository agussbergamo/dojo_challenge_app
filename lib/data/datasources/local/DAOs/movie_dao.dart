import '../../../../domain/entities/movie.dart';
import 'package:floor/floor.dart';

@dao
abstract class MovieDao {
  @Query(
    'SELECT * FROM movies WHERE movieType = "Popular" ORDER BY popularity DESC LIMIT 20',
  )
  Future<List<Movie>> getPopularMovies();

  @Query(
    'SELECT * FROM movies WHERE movieType = "Top Rated" ORDER BY voteAverage DESC LIMIT 20',
  )
  Future<List<Movie>> getTopRatedMovies();

  @Query('SELECT * FROM movies WHERE id = :id')
  Future<Movie?> getMovieById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovie(Movie movie);

  @Query('DELETE FROM movies WHERE movieType = :type')
  Future<void> deleteMoviesByType(String type);
}
