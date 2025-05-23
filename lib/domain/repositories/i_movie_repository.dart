import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getPopularMovies({DataSource? dataSource});
}
