import 'package:dojo_challenge_app/data/datasource/remote/api_service.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  final Map<String, Object> mockJson = {
    "page": 1,
    "results": [
      {
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
      },
    ],
    "total_pages": 49999,
    "total_results": 999971,
  };

  setUp(() {
    mockClient = MockClient();
  });
  test(
    'getPopularMovies returns list of movies if the HTTP call is successful',
    () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final apiService = ApiService(client: mockClient);
      final movies = await apiService.getPopularMovies();

      expect(movies, isA<List<Movie>>());
      expect(movies.first.title, equals('A Working Man'));
    },
  );

  test('getPopularMovies throws an Exception if the HTTP call fails', () async {
    when(
      mockClient.get(any),
    ).thenAnswer((_) async => http.Response('Not Found', 404));

    final apiService = ApiService(client: mockClient);

    expect(
      () async => await apiService.getPopularMovies(),
      throwsA(isA<Exception>()),
    );
  });
}
