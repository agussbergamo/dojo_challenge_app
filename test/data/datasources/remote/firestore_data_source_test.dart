import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

import 'firestore_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  WriteBatch,
])
void main() {
  late FirestoreDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocument;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockQuery<Map<String, dynamic>> mockQueryWhere;
  late MockQuery<Map<String, dynamic>> mockQueryOrderBy;
  late MockQuery<Map<String, dynamic>> mockQueryLimit;
  late MockWriteBatch mockWriteBatch;

  final movieJson = {
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
  };

  final Movie mockMoviePopular = Movie.fromJson(movieJson, Endpoint.popular);
  final Movie mockMovieRecommendations = Movie.fromJson(
    movieJson,
    Endpoint.recommendations,
  );

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocument = MockQueryDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    mockQueryWhere = MockQuery();
    mockQueryOrderBy = MockQuery();
    mockQueryLimit = MockQuery();
    mockWriteBatch = MockWriteBatch();
    dataSource = FirestoreDataSource(mockFirestore);
  });

  test(
    'should return a list of movies from Firestore when endpoint is popular',
    () async {
      when(
        mockFirestore.collection('movies'),
      ).thenReturn(mockCollectionReference);
      when(
        mockCollectionReference.where('movie_type', isEqualTo: 'Popular'),
      ).thenReturn(mockQueryWhere);
      when(
        mockQueryWhere.orderBy('popularity', descending: true),
      ).thenReturn(mockQueryOrderBy);
      when(mockQueryOrderBy.limit(20)).thenReturn(mockQueryLimit);
      when(mockQueryLimit.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
      when(
        mockQueryDocument.data(),
      ).thenReturn({...movieJson, 'movie_type': 'Popular'});

      final result = await dataSource.getMovies(endpoint: Endpoint.popular);

      expect(result, isA<List<Movie>>());
      expect(result.first.id, 1197306);
      verify(mockFirestore.collection('movies')).called(1);
    },
  );

  test(
    'should return a list of movies from Firestore when endpoint is top rated',
    () async {
      when(
        mockFirestore.collection('movies'),
      ).thenReturn(mockCollectionReference);
      when(
        mockCollectionReference.where('movie_type', isEqualTo: 'Top Rated'),
      ).thenReturn(mockQueryWhere);
      when(
        mockQueryWhere.orderBy('vote_average', descending: true),
      ).thenReturn(mockQueryOrderBy);
      when(mockQueryOrderBy.limit(20)).thenReturn(mockQueryLimit);
      when(mockQueryLimit.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
      when(
        mockQueryDocument.data(),
      ).thenReturn({...movieJson, 'movie_type': 'Top Rated'});

      final result = await dataSource.getMovies(endpoint: Endpoint.topRated);

      expect(result, isA<List<Movie>>());
      expect(result.first.id, movieJson['id']);
      verify(mockFirestore.collection('movies')).called(1);
    },
  );

  test(
    'should return a list of recommended movies for a given movieId',
    () async {
      final movieId = 1197306;

      when(
        mockFirestore.collection('movies'),
      ).thenReturn(mockCollectionReference);
      when(
        mockCollectionReference.doc(movieId.toString()),
      ).thenReturn(mockDocumentReference);
      when(
        mockDocumentReference.collection('recommendations'),
      ).thenReturn(mockCollectionReference);
      when(
        mockCollectionReference.orderBy('order'),
      ).thenReturn(mockQueryOrderBy);
      when(mockQueryOrderBy.limit(20)).thenReturn(mockQueryLimit);
      when(mockQueryLimit.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
      when(
        mockQueryDocument.data(),
      ).thenReturn({...movieJson, 'movie_type': 'Recommendations'});

      final result = await dataSource.getMovies(
        endpoint: Endpoint.recommendations,
        movieId: movieId,
      );

      expect(result, isA<List<Movie>>());
      expect(result.first.id, movieJson['id']);
      verify(mockFirestore.collection('movies')).called(1);
    },
  );

  test(
    'should throw ArgumentError if movieId is null for recommendations',
    () async {
      expect(
        () => dataSource.getMovies(endpoint: Endpoint.recommendations),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test('should insert movie to Firestore', () async {
    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.doc(mockMoviePopular.id.toString()),
    ).thenReturn(mockDocumentReference);
    when(mockDocumentReference.set(any)).thenAnswer((_) async {});

    await dataSource.insertMovie(mockMoviePopular);

    verify(mockFirestore.collection('movies')).called(1);
    verify(
      mockCollectionReference.doc(mockMoviePopular.id.toString()),
    ).called(1);
    verify(mockDocumentReference.set(any)).called(1);
  });

  test('should insert recommended movie into subcollection', () async {
    final baseMovieId = 1;
    final order = 0;

    final mockRecommendationsCollection =
        MockCollectionReference<Map<String, dynamic>>();

    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.doc(baseMovieId.toString()),
    ).thenReturn(mockDocumentReference);
    when(
      mockDocumentReference.collection('recommendations'),
    ).thenReturn(mockRecommendationsCollection);
    when(
      mockRecommendationsCollection.doc(mockMovieRecommendations.id.toString()),
    ).thenReturn(mockDocumentReference);
    when(mockDocumentReference.set(any)).thenAnswer((_) async {});

    await dataSource.insertRecommendedMovie(
      baseMovieId: baseMovieId,
      recommendedMovie: mockMovieRecommendations,
      order: order,
    );

    verify(mockFirestore.collection('movies')).called(1);
    verify(mockCollectionReference.doc(baseMovieId.toString())).called(1);
    verify(mockDocumentReference.collection('recommendations')).called(1);
    verify(mockDocumentReference.set(any)).called(1);
  });

  test('should delete all movies by type using batch', () async {
    final movieType = 'Popular';

    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.where('movie_type', isEqualTo: movieType),
    ).thenReturn(mockQueryWhere);
    when(mockQueryWhere.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
    when(mockQueryDocument.reference).thenReturn(mockDocumentReference);
    when(mockFirestore.batch()).thenReturn(mockWriteBatch);
    when(mockWriteBatch.delete(mockDocumentReference)).thenAnswer((_) {});

    when(mockWriteBatch.commit()).thenAnswer((_) async {});

    await dataSource.deleteMoviesByType(movieType);

    verify(mockFirestore.collection('movies')).called(1);
    verify(mockFirestore.batch()).called(1);
    verify(mockWriteBatch.delete(mockDocumentReference)).called(1);
    verify(mockWriteBatch.commit()).called(1);
  });

  test('should delete recommendations by movie type using batch', () async {
    final movieType = 'Top Rated';

    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.where('movie_type', isEqualTo: movieType),
    ).thenReturn(mockQueryWhere);
    when(mockQueryWhere.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
    when(mockQueryDocument['id']).thenReturn(123);

    when(
      mockFirestore.collection('movie_recommendations'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.get(),
    ).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
    when(mockQueryDocument['recommendedMovieId']).thenReturn(123);
    when(mockQueryDocument.reference).thenReturn(mockDocumentReference);
    when(mockFirestore.batch()).thenReturn(mockWriteBatch);
    when(mockWriteBatch.delete(mockDocumentReference)).thenAnswer((_) {});

    when(mockWriteBatch.commit()).thenAnswer((_) async {});

    await dataSource.deleteRecommendationsByMovieType(movieType);

    verify(mockFirestore.collection('movies')).called(1);
    verify(mockFirestore.collection('movie_recommendations')).called(1);
    verify(mockFirestore.batch()).called(1);
    verify(mockWriteBatch.delete(mockDocumentReference)).called(1);
    verify(mockWriteBatch.commit()).called(1);
  });
}
