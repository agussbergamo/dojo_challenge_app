import 'package:dojo_challenge_app/core/auth/auth_state.dart';
import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/home_page.dart';
import 'package:dojo_challenge_app/presentation/widgets/popular_movies.dart';
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
  });

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
          path: '/popular-movies',
          builder: (context, state) {
            final dataSource = state.extra as DataSource;
            return PopularMovies(dataSource: dataSource);
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
    'Home screen renders correctly and navigates to popular movies screen when the user is loggedIn',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream.value([mockMovie]));
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});
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

      expect(find.text('Great to see you around, user!'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Welcome to the tiniest Movies App!'), findsOneWidget);
      expect(
        find.text(
          "Looking for the hottest movies right now? You've come to the right place!",
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Please let us know where do you want us to get your movies from:',
        ),
        findsOneWidget,
      );
      expect(find.text('API'), findsOneWidget);
      expect(find.text('Local DB'), findsOneWidget);
      expect(find.text('Firestore'), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(5));

      // Navigates with API
      await tester.tap(find.text('API'));
      await tester.pumpAndSettle();
      expect(find.byType(PopularMovies), findsOneWidget);

      // Return to HomePage
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigates with Local DB
      await tester.tap(find.text('Local DB'));
      await tester.pumpAndSettle();
      expect(find.byType(PopularMovies), findsOneWidget);

      // Return to HomePage
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigates with Firestore
      await tester.tap(find.text('Firestore'));
      await tester.pumpAndSettle();
      expect(find.byType(PopularMovies), findsOneWidget);
    },
  );

  testWidgets(
    'Home screen renders correctly and navigates to login screen when the user is NOT loggedIn',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream.value([mockMovie]));
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});
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

      expect(
        find.text('You need to be logged in to see our awesome content!'),
        findsOneWidget,
      );
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome to the tiniest Movies App!'), findsOneWidget);
      expect(
        find.text(
          "Looking for the hottest movies right now? You've come to the right place!",
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Please let us know where do you want us to get your movies from:',
        ),
        findsOneWidget,
      );
      expect(find.text('API'), findsOneWidget);
      expect(find.text('Local DB'), findsOneWidget);
      expect(find.text('Firestore'), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(5));

      // Navigates with API
      await tester.tap(find.text('API'));
      await tester.pumpAndSettle();
      expect(find.text('Mock Login Screen'), findsOneWidget);

      // Return to HomePage
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigates with Local DB
      await tester.tap(find.text('Local DB'));
      await tester.pumpAndSettle();
      expect(find.text('Mock Login Screen'), findsOneWidget);

      // Return to HomePage
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigates with Firestore
      await tester.tap(find.text('Firestore'));
      await tester.pumpAndSettle();
      expect(find.text('Mock Login Screen'), findsOneWidget);
    },
  );
}
