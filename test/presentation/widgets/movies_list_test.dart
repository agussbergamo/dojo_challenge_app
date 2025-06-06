import 'dart:async';

import 'package:dojo_challenge_app/core/auth/auth_state.dart';
import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/movie_card.dart';
import 'package:dojo_challenge_app/presentation/widgets/movies_list.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_list_test.mocks.dart';

@GenerateMocks([MoviesBloc, AuthState])
void main() {
  late MockMoviesBloc mockMoviesBloc;
  late MockAuthState mockAuthState;
  late GoRouter router;
  late StreamController<List<Movie>> controller;

  final endpoint = Endpoint.popular;

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
  }, endpoint);

  final testRouterProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold()),
        GoRoute(
          path: '/movies',
          builder:
              (_, __) =>
                  MoviesList(endpoint: endpoint, dataSource: DataSource.local),
        ),
        GoRoute(path: '/sign-in', builder: (_, __) => const Text('Mock Login')),
      ],
    );
  });

  setUp(() {
    mockMoviesBloc = MockMoviesBloc();
    mockAuthState = MockAuthState();
    controller = StreamController<List<Movie>>();
  });

  tearDown(() async {
    await controller.close();
  });

  void setupMockBloc() {
    when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
    when(
      mockMoviesBloc.getMovies(
        endpoint: endpoint,
        dataSource: DataSource.local,
      ),
    ).thenAnswer((_) async {});
    when(mockMoviesBloc.moviesStream).thenAnswer((_) => controller.stream);
    when(mockAuthState.loggedIn).thenReturn(true);
    when(mockAuthState.currentUser).thenReturn(null);
  }

  Future<void> pumpMoviesList(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          moviesBlocProvider.overrideWithValue(mockMoviesBloc),
          authStateProvider.overrideWith((ref) => mockAuthState),
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

    router.go('/movies');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('MoviesList shows loading state', (tester) async {
    setupMockBloc();
    await pumpMoviesList(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MoviesList shows error message when stream fails', (
    tester,
  ) async {
    setupMockBloc();
    await pumpMoviesList(tester);
    controller.addError('Something went wrong');
    await tester.pump();

    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('MoviesList shows message when list is empty', (tester) async {
    setupMockBloc();
    await pumpMoviesList(tester);
    controller.add([]);
    await tester.pump();

    expect(find.text('No movies found'), findsOneWidget);
  });

  testWidgets('MoviesList shows list of movies', (tester) async {
    setupMockBloc();
    await pumpMoviesList(tester);
    controller.add([mockMovie, mockMovie]);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('${endpoint.value} Movies'), findsOneWidget);
  });
}
