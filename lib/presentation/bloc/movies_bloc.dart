import 'dart:async';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';

import 'i_movies_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../data/repositories/movie_repository.dart';

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
  Future<void> getPopularMovies(DataSource? dataSource) async {
    List<Movie> popularMovies = await movieRepository.getPopularMovies(dataSource: dataSource);
    _streamController.sink.add(popularMovies);
  }

  @override
  Future<void> initialize() async {
    _streamController.sink.add(<Movie>[]);
  }

  @override
  Stream<List<Movie>> get moviesStream => _streamController.stream;
}
