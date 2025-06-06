import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:dojo_challenge_app/data/repositories/movies_repository.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'movies_repository_test.mocks.dart';

@GenerateMocks([
  ApiDataSource,
  DatabaseDataSource,
  FirestoreDataSource,
  Connectivity,
])
void main() {
  late MockApiDataSource mockApiDataSource;
  late MockDatabaseDataSource mockDatabaseDataSource;
  late MockFirestoreDataSource mockFirestoreDataSource;
  late MockConnectivity mockConnectivity;
  late MoviesRepository moviesRepository;

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
    mockApiDataSource = MockApiDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockFirestoreDataSource = MockFirestoreDataSource();
    mockConnectivity = MockConnectivity();
    moviesRepository = MoviesRepository(
      apiDataSource: mockApiDataSource,
      databaseDataSource: mockDatabaseDataSource,
      firestoreDataSource: mockFirestoreDataSource,
      connectivityPlugin: mockConnectivity,
    );
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    "getMovies returns a List of Movie when the datasource is not specified, the internet connection is enabled and the API call is successful",
    () async {
      when(
        mockApiDataSource.getMovies(endpoint: Endpoint.popular),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await moviesRepository.getMovies(
        endpoint: Endpoint.popular,
      );
      expect(result, isA<List<Movie>>());
      verify(mockApiDataSource.getMovies(endpoint: Endpoint.popular)).called(1);
      verifyNever(mockDatabaseDataSource.getMovies(endpoint: Endpoint.popular));
      verifyNever(
        mockFirestoreDataSource.getMovies(endpoint: Endpoint.popular),
      );
    },
  );

  test(
    "getMovies returns a List of Movie when the specified source is Firestore",
    () async {
      when(
        mockFirestoreDataSource.getMovies(endpoint: Endpoint.topRated),
      ).thenAnswer((_) async => [mockMovie]);

      final result = await moviesRepository.getMovies(
        dataSource: DataSource.firestore,
        endpoint: Endpoint.topRated,
      );
      expect(result, isA<List<Movie>>());
      verify(
        mockFirestoreDataSource.getMovies(endpoint: Endpoint.topRated),
      ).called(1);
      verifyNever(
        mockDatabaseDataSource.getMovies(endpoint: Endpoint.topRated),
      );
      verifyNever(mockApiDataSource.getMovies(endpoint: Endpoint.topRated));
    },
  );

  test(
    "getMovies returns a List of Movie when the specified source is Local",
    () async {
      when(
        mockDatabaseDataSource.getMovies(endpoint: Endpoint.popular),
      ).thenAnswer((_) async => [mockMovie]);

      final result = await moviesRepository.getMovies(
        dataSource: DataSource.local,
        endpoint: Endpoint.popular,
      );
      expect(result, isA<List<Movie>>());
      verify(
        mockDatabaseDataSource.getMovies(endpoint: Endpoint.popular),
      ).called(1);
      verifyNever(
        mockFirestoreDataSource.getMovies(endpoint: Endpoint.popular),
      );
      verifyNever(mockApiDataSource.getMovies(endpoint: Endpoint.popular));
    },
  );

  test(
    "getMovies method returns a List of Movie when the internet connection is disabled",
    () async {
      when(
        mockApiDataSource.getMovies(endpoint: Endpoint.topRated),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      when(
        mockDatabaseDataSource.getMovies(endpoint: Endpoint.topRated),
      ).thenAnswer((_) async => <Movie>[]);

      final result = await moviesRepository.getMovies(
        endpoint: Endpoint.topRated,
      );
      expect(result, isA<List<Movie>>());
      verify(
        mockDatabaseDataSource.getMovies(endpoint: Endpoint.topRated),
      ).called(1);
      verifyNever(mockApiDataSource.getMovies(endpoint: Endpoint.topRated));
      verifyNever(
        mockFirestoreDataSource.getMovies(endpoint: Endpoint.topRated),
      );
    },
  );

  test("getMovies catches an Exception when the API call fails", () async {
    when(
      mockApiDataSource.getMovies(endpoint: Endpoint.popular),
    ).thenAnswer((_) => throw Exception('Error fetching data'));
    when(
      mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    expect(
      () => moviesRepository.getMovies(endpoint: Endpoint.popular),
      throwsA(isA<Exception>()),
    );
  });

  test(
    "getMovies caches movies in local and Firestore when fetched from API and endpoint is not recommendations",
    () async {
      final movies = [mockMovie];

      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      when(
        mockApiDataSource.getMovies(endpoint: Endpoint.popular),
      ).thenAnswer((_) async => movies);

      when(
        mockDatabaseDataSource.deleteRecommendationsByMovieType(any),
      ).thenAnswer((_) async {});
      when(
        mockFirestoreDataSource.deleteRecommendationsByMovieType(any),
      ).thenAnswer((_) async {});
      when(
        mockDatabaseDataSource.deleteMoviesByType(any),
      ).thenAnswer((_) async {});
      when(
        mockFirestoreDataSource.deleteMoviesByType(any),
      ).thenAnswer((_) async {});

      when(mockDatabaseDataSource.insertMovie(any)).thenAnswer((_) async {});
      when(mockFirestoreDataSource.insertMovie(any)).thenAnswer((_) async {});

      final result = await moviesRepository.getMovies(
        endpoint: Endpoint.popular,
      );

      expect(result, movies);
      verify(
        mockDatabaseDataSource.deleteMoviesByType(Endpoint.popular.value),
      ).called(1);
      verify(
        mockFirestoreDataSource.deleteMoviesByType(Endpoint.popular.value),
      ).called(1);
      verify(mockDatabaseDataSource.insertMovie(mockMovie)).called(1);
      verify(mockFirestoreDataSource.insertMovie(mockMovie)).called(1);
    },
  );

  test(
    "getMovies caches recommended movies when endpoint is recommendations and baseMovieId is provided",
    () async {
      final movies = [mockMovie];
      const baseMovieId = 42;

      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      when(
        mockApiDataSource.getMovies(
          endpoint: Endpoint.recommendations,
          movieId: baseMovieId,
        ),
      ).thenAnswer((_) async => movies);

      when(mockDatabaseDataSource.insertMovie(any)).thenAnswer((_) async {});
      when(mockFirestoreDataSource.insertMovie(any)).thenAnswer((_) async {});
      when(
        mockDatabaseDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: anyNamed('recommendedMovie'),
          order: anyNamed('order'),
        ),
      ).thenAnswer((_) async {});
      when(
        mockFirestoreDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: anyNamed('recommendedMovie'),
          order: anyNamed('order'),
        ),
      ).thenAnswer((_) async {});

      final result = await moviesRepository.getMovies(
        endpoint: Endpoint.recommendations,
        movieId: baseMovieId,
      );

      expect(result, movies);
      verify(
        mockDatabaseDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: mockMovie,
          order: 0,
        ),
      ).called(1);
      verify(
        mockFirestoreDataSource.insertRecommendedMovie(
          baseMovieId: baseMovieId,
          recommendedMovie: mockMovie,
          order: 0,
        ),
      ).called(1);
    },
  );
}
