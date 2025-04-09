import 'i_bloc.dart';
import 'movie.dart';

abstract class IMoviesBloc implements IBloc {

  Stream<List<Movie>> get moviesStream;

  Future<void> getPopularMovies(); 

}