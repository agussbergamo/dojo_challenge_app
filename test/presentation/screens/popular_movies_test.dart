import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/screens/popular_movies.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_test.mocks.dart';

@GenerateMocks([MoviesBloc])
void main() {
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
    mockMoviesBloc = MockMoviesBloc();
  });

  testWidgets(
    'PopularMovies screen shows a CircularProgressIndicator when the StreamBuilder is waiting',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream<List<Movie>>.empty());
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [moviesBlocProvider.overrideWithValue(mockMoviesBloc)],
          child: const MaterialApp(home: PopularMovies()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'PopularMovies screen shows an Error widget when there is a Network Error',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream<List<Movie>>.error('Network error'));
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [moviesBlocProvider.overrideWithValue(mockMoviesBloc)],
          child: const MaterialApp(home: PopularMovies()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();
      expect(find.textContaining('Error'), findsOneWidget);
    },
  );

  testWidgets(
    'PopularMovies screen shows a "No movies found" message when the Stream is empty',
    (WidgetTester tester) async {
      when(
        mockMoviesBloc.moviesStream,
      ).thenAnswer((_) => Stream<List<Movie>>.empty());
      when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
      when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [moviesBlocProvider.overrideWithValue(mockMoviesBloc)],
          child: const MaterialApp(home: PopularMovies()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();
      expect(find.text('No movies found'), findsOneWidget);
    },
  );

  testWidgets('PopularMovies screen shows a ListView when the Stream has data', (
    WidgetTester tester,
  ) async {
    when(
      mockMoviesBloc.moviesStream,
    ).thenAnswer((_) => Stream.value([mockMovie]));
    when(mockMoviesBloc.initialize()).thenAnswer((_) async {});
    when(mockMoviesBloc.getPopularMovies()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [moviesBlocProvider.overrideWithValue(mockMoviesBloc)],
        child: const MaterialApp(home: PopularMovies()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
  });
}
