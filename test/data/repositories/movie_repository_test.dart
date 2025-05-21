import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:dojo_challenge_app/data/repositories/movie_repository.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'movie_repository_test.mocks.dart';

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
  late MovieRepository movieRepository;

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
    mockApiDataSource = MockApiDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockFirestoreDataSource = MockFirestoreDataSource();
    mockConnectivity = MockConnectivity();
    movieRepository = MovieRepository(
      apiDataSource: mockApiDataSource,
      databaseDataSource: mockDatabaseDataSource,
      firestoreDataSource: mockFirestoreDataSource,
      connectivityPlugin: mockConnectivity,
    );
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    "getPopularMovies method returns a List of Movies when the datasource is not specified, the internet connection is enabled and the API call is successful",
    () async {
      when(
        mockApiDataSource.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await movieRepository.getPopularMovies();
      expect(result, isA<List<Movie>>());
      verify(mockApiDataSource.getPopularMovies()).called(1);
      verifyNever(mockDatabaseDataSource.getPopularMovies());
      verifyNever(mockFirestoreDataSource.getPopularMovies());
    },
  );

  test(
    "getPopularMovies method returns a List of Movies when the specified source is Firestore",
    () async {
      when(
        mockFirestoreDataSource.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);

      final result = await movieRepository.getPopularMovies(
        dataSource: DataSource.firestore,
      );
      expect(result, isA<List<Movie>>());
      verify(mockFirestoreDataSource.getPopularMovies()).called(1);
      verifyNever(mockDatabaseDataSource.getPopularMovies());
      verifyNever(mockApiDataSource.getPopularMovies());
    },
  );

  test(
    "getPopularMovies method returns a List of Movies when the specified source is Local",
    () async {
      when(
        mockDatabaseDataSource.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);

      final result = await movieRepository.getPopularMovies(
        dataSource: DataSource.local,
      );
      expect(result, isA<List<Movie>>());
      verify(mockDatabaseDataSource.getPopularMovies()).called(1);
      verifyNever(mockFirestoreDataSource.getPopularMovies());
      verifyNever(mockApiDataSource.getPopularMovies());
    },
  );

  test(
    "getPopularMovies method returns a List of Movies when the internet connection is disabled",
    () async {
      when(
        mockApiDataSource.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      when(
        mockDatabaseDataSource.getPopularMovies(),
      ).thenAnswer((_) async => <Movie>[]);

      final result = await movieRepository.getPopularMovies();
      expect(result, isA<List<Movie>>());
      verify(mockDatabaseDataSource.getPopularMovies()).called(1);
      verifyNever(mockApiDataSource.getPopularMovies());
      verifyNever(mockFirestoreDataSource.getPopularMovies());
    },
  );

  test(
    "getPopularMovies method catches an Exception when the API call fails",
    () async {
      when(
        mockApiDataSource.getPopularMovies(),
      ).thenAnswer((_) => throw Exception('Error fetching data'));
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      expect(
        () => movieRepository.getPopularMovies(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
