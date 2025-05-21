import 'package:dojo_challenge_app/data/datasources/local/database.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/local/DAOs/movie_dao.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'database_data_source_test.mocks.dart';

@GenerateMocks([AppDatabase, MovieDao])
void main() {
  late MockAppDatabase mockAppDatabase;
  late MockMovieDao mockMovieDao;

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
    mockAppDatabase = MockAppDatabase();
    mockMovieDao = MockMovieDao();
  });

  test('getMovies returns a list of movies', () async {
    when(mockAppDatabase.movieDao).thenReturn(mockMovieDao);
    when(mockMovieDao.getPopularMovies()).thenAnswer((_) async => <Movie>[]);

    final databaseDataSource = DatabaseDataSource.test(mockAppDatabase);

    final result = await databaseDataSource.getPopularMovies();

    expect(result, isA<List<Movie>>());
    verify(mockAppDatabase.movieDao).called(1);
    verify(mockMovieDao.getPopularMovies()).called(1);
  });

  test('insertMovies inserts a mockMovie into the database, through the MovieDAO', () async {
    when(mockAppDatabase.movieDao).thenReturn(mockMovieDao);
    when(mockMovieDao.insertMovie(mockMovie)).thenAnswer((_) async {});

    final databaseDataSource = DatabaseDataSource.test(mockAppDatabase);

    await databaseDataSource.insertMovie(mockMovie);
    verify(mockMovieDao.insertMovie(mockMovie)).called(1);
  });
}
