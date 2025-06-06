import 'package:dojo_challenge_app/core/auth/auth_state.dart';
import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/home_page.dart';
import 'package:dojo_challenge_app/presentation/widgets/movies_list.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_test.mocks.dart';

class TestApp extends ConsumerWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(routerConfig: goRouter);
  }
}

@GenerateMocks([MoviesBloc, DatabaseDataSource, AuthState])
void main() {
  late MockDatabaseDataSource mockDatabaseDataSource;
  late MockMoviesBloc mockMoviesBloc;
  late MockAuthState mockAuthState;

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

  final testRouterProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(),
          routes: [
            GoRoute(
              path: 'sign-in',
              builder:
                  (context, state) => Scaffold(
                    appBar: AppBar(),
                    body: Text('Mock Login Screen'),
                  ),
            ),
          ],
        ),
        GoRoute(
          path: '/movies',
          builder: (context, state) {
            return MoviesList(
              endpoint: Endpoint.popular,
              dataSource: DataSource.local,
            );
          },
        ),
      ],
    );
  });

  setUpAll(() async {
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockMoviesBloc = MockMoviesBloc();
    mockAuthState = MockAuthState();
  });

  testWidgets(
    'Home screen renders correctly and navigates to MoviesList screen when the user is loggedIn',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream.value([mockMovie]));
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(
        mockMoviesBloc.getMovies(endpoint: Endpoint.popular),
      ).thenAnswer((_) async {});
      when(mockAuthState.loggedIn).thenReturn(true);
      when(mockAuthState.currentUser).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseDataSourceProvider.overrideWithValue(
              mockDatabaseDataSource,
            ),
            moviesBlocProvider.overrideWithValue(mockMoviesBloc),
            authStateProvider.overrideWith((ref) => mockAuthState),
            goRouterProvider.overrideWith(
              (ref) => ref.watch(testRouterProvider),
            ),
          ],
          child: TestApp(),
        ),
      );

      expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(
        find.textContaining('Looking for the hottest movies right now'),
        findsOneWidget,
      );
      expect(
        find.text(
          "You've come to the right place!\nJust pick two quick options and let the magic happen.",
        ),
        findsOneWidget,
      );
      expect(
        find.text("Which movie bunch speaks to your soul?"),
        findsOneWidget,
      );
      expect(
        find.text(
          "Let us show off a bit. We've got your movies stored in 3 different places, turn on your dev mode and pick your favorite!",
        ),
        findsOneWidget,
      );
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('API'), findsOneWidget);

      final navigationButton = find.text('Take me there!');
      await tester.ensureVisible(navigationButton);
      await tester.tap(navigationButton);
      await tester.pumpAndSettle();
      expect(find.byType(MoviesList), findsOneWidget);
    },
  );

  testWidgets(
    'Home screen renders correctly and navigates to login screen when the user is NOT loggedIn',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream.value([mockMovie]));
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(
        mockMoviesBloc.getMovies(endpoint: Endpoint.popular),
      ).thenAnswer((_) async {});
      when(mockAuthState.loggedIn).thenReturn(false);
      when(mockAuthState.currentUser).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseDataSourceProvider.overrideWithValue(
              mockDatabaseDataSource,
            ),
            moviesBlocProvider.overrideWithValue(mockMoviesBloc),
            authStateProvider.overrideWith((ref) => mockAuthState),
            goRouterProvider.overrideWith(
              (ref) => ref.watch(testRouterProvider),
            ),
          ],
          child: TestApp(),
        ),
      );

      expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(
        find.text("We tried… but nope, still don't know who you are!"),
        findsOneWidget,
      );
      expect(
        find.text(
          "Please log in to see all the awesome stuff we've got waiting!",
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.text('Mock Login Screen'), findsOneWidget);
    },
  );

  testWidgets('Dropdown menu items appear after tapping', (tester) async {
    when(mockAuthState.loggedIn).thenReturn(true);
    when(mockAuthState.currentUser).thenReturn(null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => mockAuthState),
          goRouterProvider.overrideWith((ref) => ref.watch(testRouterProvider)),
        ],
        child: const TestApp(),
      ),
    );

    await tester.tap(find.byKey(const Key('endpointDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Top Rated'), findsOneWidget);
    await tester.tap(find.text('Popular').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dataSourceDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Local DB'), findsOneWidget);
    expect(find.text('Firestore'), findsOneWidget);
    await tester.tap(find.text('Firestore').last);
  });
}
