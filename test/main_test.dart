import 'package:dojo_challenge_app/data/datasource/local/database_service.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/main.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/screens/popular_movies.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'main_test.mocks.dart';

@GenerateMocks([MoviesBloc, DatabaseService])
void main() {
  late MockDatabaseService mockDatabaseService;
  late MockMoviesBloc mockMoviesBloc;

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
    mockDatabaseService = MockDatabaseService();
    mockMoviesBloc = MockMoviesBloc();
  });

  testWidgets('Home screen renders and navigates to popular movies screen', (
    WidgetTester tester,
  ) async {
    when(
      mockMoviesBloc.moviesStream,
    ).thenAnswer((_) => Stream.value([mockMovie]));
    when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
    when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseServiceProvider.overrideWithValue(mockDatabaseService),
          moviesBlocProvider.overrideWithValue(mockMoviesBloc),
        ],
        child: MaterialApp(
          home: const MyHomePage(),
          routes: {'/popular-movies': (context) => PopularMovies()},
        ),
      ),
    );

    expect(find.text('Wanna see some popular movies?'), findsOneWidget);
    expect(find.text('Take me there!'), findsOneWidget);

    await tester.tap(find.text('Take me there!'));
    await tester.pumpAndSettle();
    expect(find.byType(PopularMovies), findsOneWidget);
  });
}
