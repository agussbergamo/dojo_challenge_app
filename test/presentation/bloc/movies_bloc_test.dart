import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/domain/usecases/implementations/movies_usecase.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_bloc_test.mocks.dart';

@GenerateMocks([MoviesUseCase])
void main() {
  late MoviesBloc bloc;
  late MockMoviesUseCase mockMoviesUseCase;

  final Movie mockMovie = Movie.fromJson({
    "adult": false,
    "backdrop_path": "/fTrQsdMS2MUw00RnzH0r3JWHhts.jpg",
    "id": 1197306,
    "original_language": "en",
    "original_title": "A Working Man",
    "overview":
        "Levon Cade left behind a decorated military career in the black ops to live a simple life working construction. But when his boss's daughter, who is like family to him, is taken by human traffickers, his search to bring her home uncovers a world of corruption far greater than he ever could have imagined.",
    "popularity": 633.0389,
    "poster_path": "/6FRFIogh3zFnVWn7Z6zcYnIbRcX.jpg",
    "release_date": "2025-03-26",
    "title": "A Working Man",
    "video": false,
    "vote_average": 6.4,
    "vote_count": 477,
  });

  setUp(() {
    mockMoviesUseCase = MockMoviesUseCase();
    bloc = MoviesBloc(moviesUsecase: mockMoviesUseCase);
  });

  tearDown(() {
    bloc.dispose();
  });

  test('The method initialize() should emit an empty movie list', () async {
    final result = expectLater(bloc.moviesStream, emitsInOrder([[]]));
    await bloc.initialize();
    await result;
  });

  test('getPopularMovies() should emit movies from usecase', () async {
    when(mockMoviesUseCase.call()).thenAnswer((_) async => [mockMovie]);

    final result = expectLater(
      bloc.moviesStream,
      emitsInOrder([
        [mockMovie],
      ]),
    );

    await bloc.getPopularMovies();
    await result;
  });
}
