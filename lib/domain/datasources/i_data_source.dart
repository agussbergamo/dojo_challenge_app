import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

abstract class IDataSource {
  Future<List<Movie>> getMovies({required Endpoint endpoint});
}
