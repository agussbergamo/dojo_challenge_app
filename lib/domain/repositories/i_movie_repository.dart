import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getMovies({DataSource? dataSource, required Endpoint endpoint});
}
