import 'package:dojo_challenge_app/data/repositories/movies_repository.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/domain/usecases/implementations/movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_usecase_test.mocks.dart';

@GenerateMocks([MoviesRepository])
void main() {
  late MoviesUseCase moviesUseCase;
  late MockMoviesRepository mockMoviesRepository;

  final Movie mockMovie = Movie.fromJson({
    "adult": false,
    "id": 1197306,
    "original_language": "en",
    "original_title": "A Working Man",
    "overview":
        "Levon Cade left behind a decorated military career in the black ops to live a simple life working construction. But when his boss's daughter, who is like family to him, is taken by human traffickers, his search to bring her home uncovers a world of corruption far greater than he ever could have imagined.",
    "popularity": 633.0389,
    "release_date": "2025-03-26",
    "title": "A Working Man",
    "video": false,
    "vote_average": 6.4,
    "vote_count": 477,
  });

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    moviesUseCase = MoviesUseCase(moviesRepository: mockMoviesRepository);
  });

  test('should get popular movies from repository', () async {
    when(
      mockMoviesRepository.getPopularMovies(),
    ).thenAnswer((_) async => [mockMovie]);

    final result = await moviesUseCase.call();

    expect(result, [mockMovie]);
    verify(mockMoviesRepository.getPopularMovies()).called(1);
    verifyNoMoreInteractions(mockMoviesRepository);
  });
}
