import 'dart:async';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movie_detail_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/movie_detail.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late GoRouter router;
  late StreamController<List<Movie>> controller;

  final Movie mockMovie = Movie.fromJson({
    "adult": false,
    "backdrop_path": "/fTrQsdMS2MUw00RnzH0r3JWHhts.jpg",
    "id": 1197306,
    "original_language": "en",
    "original_title": "A Working Man",
    "overview":
        "Levon Cade left behind a decorated military career in the black ops to live a simple life working construction...",
    "popularity": 633.0389,
    "poster_path": "/6FRFIogh3zFnVWn7Z6zcYnIbRcX.jpg",
    "release_date": "2025-03-26",
    "title": "A Working Man",
    "video": false,
    "vote_average": 6.4,
    "vote_count": 477,
  }, Endpoint.popular);

  final Movie mockRecommendedMovie = Movie.fromJson({
    "backdrop_path": "/7rKyFSg6SdLoCRCVoWLjL5k658k.jpg",
    "id": 668489,
    "title": "Havoc",
    "original_title": "Havoc",
    "overview":
        "When a drug heist swerves lethally out of control, a jaded cop fights his way through a corrupt city's criminal underworld to save a politician's son.",
    "poster_path": "/ubP2OsF3GlfqYPvXyLw9d78djGX.jpg",
    "media_type": "movie",
    "adult": false,
    "original_language": "en",
    "genre_ids": [28, 80, 53],
    "popularity": 76.9398,
    "release_date": "2025-04-25",
    "video": false,
    "vote_average": 6.511,
    "vote_count": 774,
  }, Endpoint.recommendations);

  final testRouterProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold()),
        GoRoute(
          path: '/movie-detail',
          builder:
              (_, __) => MovieDetail(
                movie: mockMovie,
                endpoint: Endpoint.popular,
                dataSource: DataSource.local,
              ),
        ),
      ],
    );
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    controller = StreamController<List<Movie>>();
  });

  tearDown(() async {
    await controller.close();
  });

  void setupMockBloc() {
    when(mockMovieDetailBloc.initialize()).thenAnswer((_) async {});
    when(
      mockMovieDetailBloc.getRecommendedMovies(
        movieId: 1197306,
        endpoint: Endpoint.recommendations,
      ),
    ).thenAnswer((_) async {});
    when(mockMovieDetailBloc.moviesStream).thenAnswer((_) => controller.stream);
  }

  Future<void> pumpMovieDetail(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieDetailBlocProvider.overrideWithValue(mockMovieDetailBloc),
          goRouterProvider.overrideWith((ref) => ref.watch(testRouterProvider)),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            router = ref.watch(testRouterProvider);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );

    router.go('/movie-detail');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('MovieDetail shows movie info', (tester) async {
    setupMockBloc();
    await pumpMovieDetail(tester);

    expect(find.byKey(const Key('backdropImage')), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.text('Play Trailer'), findsOneWidget);
    expect(find.text('Still in the mood? Try these!'), findsOneWidget);
  });

  testWidgets('MovieDetail shows spinner while loading recommendations', (
    tester,
  ) async {
    setupMockBloc();
    await pumpMovieDetail(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MovieDetail shows error message when stream fails', (
    tester,
  ) async {
    setupMockBloc();
    await pumpMovieDetail(tester);
    controller.addError('Something went wrong');
    await tester.pump();

    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('MovieDetail shows message when list is empty', (tester) async {
    setupMockBloc();
    await pumpMovieDetail(tester);
    controller.add([]);
    await tester.pump();

    expect(find.text('No movies found'), findsOneWidget);
  });

  testWidgets('MovieDetail shows recommendations for movie', (tester) async {
    setupMockBloc();
    await pumpMovieDetail(tester);
    controller.add([mockRecommendedMovie]);
    await tester.pump();

    expect(find.byType(ListView), findsNWidgets(1));
  });
}
