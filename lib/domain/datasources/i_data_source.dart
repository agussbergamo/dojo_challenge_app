import 'package:dojo_challenge_app/domain/entities/movie.dart';

abstract class IDataSource {
  Future<List<Movie>> getPopularMovies(); 
}