import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/local/DAOs/movie_recommendation_dao.dart';
import 'package:dojo_challenge_app/data/datasources/local/database.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/local/DAOs/movie_dao.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/domain/entities/movie_recommendation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'database_data_source_test.mocks.dart';

@GenerateMocks([AppDatabase, MovieDao, MovieRecommendationDao])
void main() {
  late MockAppDatabase mockAppDatabase;
  late MockMovieDao mockMovieDao;
  late MockMovieRecommendationDao mockMovieRecommendationDao;
  late DatabaseDataSource databaseDataSource;

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
  }, Endpoint.popular);

  setUp(() {
    mockAppDatabase = MockAppDatabase();
    mockMovieDao = MockMovieDao();
    mockMovieRecommendationDao = MockMovieRecommendationDao();
    databaseDataSource = DatabaseDataSource.test(mockAppDatabase);
    when(mockAppDatabase.movieDao).thenReturn(mockMovieDao);
    when(
      mockAppDatabase.movieRecommendationDao,
    ).thenReturn(mockMovieRecommendationDao);
  });

  test('getMovies returns a List of Movie when endpoint is popular', () async {
    when(mockMovieDao.getPopularMovies()).thenAnswer((_) async => [mockMovie]);

    final result = await databaseDataSource.getMovies(
      endpoint: Endpoint.popular,
    );

    expect(result, isA<List<Movie>>());
    verify(mockAppDatabase.movieDao).called(1);
    verify(mockMovieDao.getPopularMovies()).called(1);
  });

  test('getMovies returns a List of Movie when endpoint is topRated', () async {
    when(mockMovieDao.getTopRatedMovies()).thenAnswer((_) async => [mockMovie]);

    final result = await databaseDataSource.getMovies(
      endpoint: Endpoint.topRated,
    );

    expect(result, [mockMovie]);
    verify(mockMovieDao.getTopRatedMovies()).called(1);
  });

  test(
    'getMovies returns recommendations for a movie when endpoint is recommendations',
    () async {
      when(
        mockMovieRecommendationDao.getRecommendedIds(123),
      ).thenAnswer((_) async => [1, 2]);
      when(mockMovieDao.getMovieById(1)).thenAnswer((_) async => mockMovie);
      when(mockMovieDao.getMovieById(2)).thenAnswer((_) async => null);

      final result = await databaseDataSource.getMovies(
        endpoint: Endpoint.recommendations,
        movieId: 123,
      );

      expect(result.length, 1);
      expect(result.first, mockMovie);
      verify(mockMovieRecommendationDao.getRecommendedIds(123)).called(1);
      verify(mockMovieDao.getMovieById(1)).called(1);
      verify(mockMovieDao.getMovieById(2)).called(1);
    },
  );

  test(
    'insertMovies inserts a mockMovie into the database, through the MovieDAO',
    () async {
      when(mockMovieDao.insertMovie(mockMovie)).thenAnswer((_) async {});

      final databaseDataSource = DatabaseDataSource.test(mockAppDatabase);

      await databaseDataSource.insertMovie(mockMovie);
      verify(mockMovieDao.insertMovie(mockMovie)).called(1);
    },
  );

  test('insertRecommendedMovie inserts movie and relation', () async {
    when(mockMovieDao.insertMovie(mockMovie)).thenAnswer((_) async {});
    when(
      mockMovieRecommendationDao.insertRecommendation(any),
    ).thenAnswer((_) async {});

    await databaseDataSource.insertRecommendedMovie(
      baseMovieId: 100,
      recommendedMovie: mockMovie,
      order: 1,
    );

    verify(mockMovieDao.insertMovie(mockMovie)).called(1);
    verify(
      mockMovieRecommendationDao.insertRecommendation(
        argThat(
          isA<MovieRecommendation>().having(
            (r) => r.baseMovieId,
            'baseMovieId',
            100,
          ),
        ),
      ),
    ).called(1);
  });

  test('deleteMoviesByType calls DAO with the correct type', () async {
    when(mockMovieDao.deleteMoviesByType('popular')).thenAnswer((_) async {});

    await databaseDataSource.deleteMoviesByType('popular');

    verify(mockMovieDao.deleteMoviesByType('popular')).called(1);
  });

  test(
    'deleteRecommendationsByMovieType calls DAO with the correct type',
    () async {
      when(
        mockAppDatabase.movieRecommendationDao,
      ).thenReturn(mockMovieRecommendationDao);
      when(
        mockMovieRecommendationDao.deleteRecommendationsByMovieType('popular'),
      ).thenAnswer((_) async {});

      await databaseDataSource.deleteRecommendationsByMovieType('popular');

      verify(
        mockMovieRecommendationDao.deleteRecommendationsByMovieType('popular'),
      ).called(1);
    },
  );
}
