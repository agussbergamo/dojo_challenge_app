import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  final Map<String, Object> mockJson = {
    "page": 1,
    "results": [
      {
        "adult": false,
        "backdrop_path": "/fTrQsdMS2MUw00RnzH0r3JWHhts.jpg",
        "genre_ids": [28, 80, 53],
        "id": 1197306,
        "original_language": "en",
        "original_title": "A Working Man",
        "overview":
            "Levon Cade left behind a decorated military career in the black ops to live a simple life working construction. But when his boss's daughter, who is like family to him, is taken by human traffickers, his search to bring her home uncovers a world of corruption far greater than he ever could have imagined.",
        "popularity": 308.2204,
        "poster_path": "/6FRFIogh3zFnVWn7Z6zcYnIbRcX.jpg",
        "release_date": "2025-03-26",
        "title": "A Working Man",
        "video": false,
        "vote_average": 6.65,
        "vote_count": 908,
      },
    ],
    "total_pages": 49999,
    "total_results": 999971,
  };

  setUp(() {
    mockClient = MockClient();
  });
  test(
    'getMovies returns a List of Movie if the HTTP call is successful and the endpoint is popular',
    () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final apiDataSource = ApiDataSource(client: mockClient);
      final movies = await apiDataSource.getMovies(endpoint: Endpoint.popular);

      expect(movies, isA<List<Movie>>());
      expect(movies.first.title, equals('A Working Man'));
    },
  );

  test(
    'getMovies returns a List of Movie if the HTTP call is successful and the endpoint is recommendations',
    () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final apiDataSource = ApiDataSource(client: mockClient);
      final movies = await apiDataSource.getMovies(
        endpoint: Endpoint.recommendations,
        movieId: 1197306,
      );

      expect(movies, isA<List<Movie>>());
      expect(movies.first.title, equals('A Working Man'));
    },
  );

  test('getMovies throws an Exception if the HTTP call fails', () async {
    when(
      mockClient.get(any),
    ).thenAnswer((_) async => http.Response('Not Found', 404));

    final apiDataSource = ApiDataSource(client: mockClient);

    expect(
      () async => await apiDataSource.getMovies(endpoint: Endpoint.topRated),
      throwsA(isA<Exception>()),
    );
  });
}
