import 'package:dojo_challenge_app/data/datasource/local/database_service.dart';
import 'package:dojo_challenge_app/data/datasource/remote/api_service.dart';
import 'package:dojo_challenge_app/data/repositories/movie_repository.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'movie_repository_test.mocks.dart';

@GenerateMocks([ApiService, DatabaseService, Connectivity])
void main() {
  late MockApiService mockApiService;
  late MockDatabaseService mockDatabaseService;
  late MockConnectivity mockConnectivity;

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
    mockApiService = MockApiService();
    mockDatabaseService = MockDatabaseService();
    mockConnectivity = MockConnectivity();
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    "getPopularMovies method returns a List of Movies when the service call is successful",
    () async {
      when(
        mockApiService.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final movieRepository = MovieRepository(
        apiService: mockApiService,
        databaseService: mockDatabaseService,
        connectivityPlugin: mockConnectivity,
      );
      final result = await movieRepository.getPopularMovies();
      expect(result, isA<List<Movie>>());
      verify(mockApiService.getPopularMovies()).called(1);
      verifyNever(mockDatabaseService.getMovies());
    },
  );

  test(
    "getPopularMovies method returns a List of Movies when the internet connection is disabled",
    () async {
      when(
        mockApiService.getPopularMovies(),
      ).thenAnswer((_) async => [mockMovie]);
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      when(mockDatabaseService.getMovies()).thenAnswer((_) async => <Movie>[]);

      final movieRepository = MovieRepository(
        apiService: mockApiService,
        databaseService: mockDatabaseService,
        connectivityPlugin: mockConnectivity,
      );

      final serviceResult = await movieRepository.getPopularMovies();
      expect(serviceResult, isA<List<Movie>>());
      verify(mockDatabaseService.getMovies()).called(1);
      verifyNever(mockApiService.getPopularMovies());
    },
  );

  test(
    "getPopularMovies method catches an Exception when the service call fails",
    () async {
      when(
        mockApiService.getPopularMovies(),
      ).thenAnswer((_) => throw Exception('Error fetching data'));
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final movieRepository = MovieRepository(
        apiService: mockApiService,
        databaseService: mockDatabaseService,
        connectivityPlugin: mockConnectivity,
      );

      expect(
        () => movieRepository.getPopularMovies(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
