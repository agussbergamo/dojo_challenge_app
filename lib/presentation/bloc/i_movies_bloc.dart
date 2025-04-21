import '../../core/bloc/i_bloc.dart';
import '../../domain/entities/movie.dart';

abstract class IMoviesBloc implements IBloc {

  Stream<List<Movie>> get moviesStream;

  Future<void> getPopularMovies(); 

}