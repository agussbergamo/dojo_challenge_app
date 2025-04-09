import 'dart:async';
import 'i_movies_bloc.dart';
import 'movie.dart';
import 'movie_repository.dart';

class MoviesBloc implements IMoviesBloc {
  final StreamController<List<Movie>> _streamController =
      StreamController<List<Movie>>.broadcast();
  final MovieRepository movieRepository;

  MoviesBloc({required this.movieRepository});

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Future<void> getPopularMovies() async {
    List<Movie> popularMovies = await movieRepository.getPopularMovies();
    _streamController.sink.add(popularMovies);
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Stream<List<Movie>> get moviesStream => _streamController.stream;
}
