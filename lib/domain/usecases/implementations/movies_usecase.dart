import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/domain/repositories/i_movie_repository.dart';
import 'package:dojo_challenge_app/domain/usecases/interfaces/i_usecase.dart';

class MoviesUseCase implements IUseCase {
  MoviesUseCase({required this.moviesRepository});

  final IMoviesRepository moviesRepository;

  @override
  Future<List<Movie>> call({
    required Endpoint endpoint,
    DataSource? dataSource,
  }) {
    return moviesRepository.getMovies(
      endpoint: endpoint,
      dataSource: dataSource,
    );
  }
}
