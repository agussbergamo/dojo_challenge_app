import 'dart:async';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/usecases/interfaces/i_usecase.dart';

import 'i_movies_bloc.dart';
import '../../domain/entities/movie.dart';

class MoviesBloc implements IMoviesBloc {
  final StreamController<List<Movie>> _streamController =
      StreamController<List<Movie>>.broadcast();
  final IUseCase moviesUsecase;

  MoviesBloc({required this.moviesUsecase});

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Future<void> getMovies({
    required Endpoint endpoint,
    DataSource? dataSource,
  }) async {
    List<Movie> movies = await moviesUsecase.call(
      endpoint: endpoint,
      dataSource: dataSource,
    );
    _streamController.sink.add(movies);
  }

  @override
  Future<void> initialize() async {
    _streamController.sink.add(<Movie>[]);
  }

  @override
  Stream<List<Movie>> get moviesStream => _streamController.stream;
}
