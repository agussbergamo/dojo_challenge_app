import 'dart:async';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/usecases/interfaces/i_usecase.dart';
import 'package:dojo_challenge_app/presentation/bloc/i_movie_detail_bloc.dart';

import '../../domain/entities/movie.dart';

class MovieDetailBloc implements IMovieDetailBloc {
  final StreamController<List<Movie>> _streamController =
      StreamController<List<Movie>>.broadcast();
  final IUseCase moviesUsecase;

  MovieDetailBloc({required this.moviesUsecase});

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Future<void> getRecommendedMovies({
    required Endpoint endpoint,
    required int movieId,
    DataSource? dataSource,
  }) async {
    List<Movie> movies = await moviesUsecase.call(
      endpoint: endpoint,
      movieId: movieId, 
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
