import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';

import '../../core/bloc/i_bloc.dart';
import '../../domain/entities/movie.dart';

abstract class IMoviesBloc implements IBloc {
  Stream<List<Movie>> get moviesStream;

  Future<void> getMovies({
    required Endpoint endpoint,
    DataSource dataSource,
  });
}
