import 'package:cloud_firestore/cloud_firestore.dart';
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
])
void main() {
  late FirestoreDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocument;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocument = MockQueryDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();

    dataSource = FirestoreDataSource(mockFirestore);
  });

  test('should return a list of movies from Firestore', () async {
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

    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.get(),
    ).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocument]);
    when(mockQueryDocument.data()).thenReturn(movieJson);

    final result = await dataSource.getPopularMovies();

    expect(result, isA<List<Movie>>());
    expect(result.first.id, 1197306);
    verify(mockFirestore.collection('movies')).called(1);
  });

  test('should save movie to Firestore', () async {
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

    when(
      mockFirestore.collection('movies'),
    ).thenReturn(mockCollectionReference);
    when(
      mockCollectionReference.doc(mockMovie.id.toString()),
    ).thenReturn(mockDocumentReference);
    when(mockDocumentReference.set(any)).thenAnswer((_) async {});

    await dataSource.saveMovie(mockMovie);

    verify(mockFirestore.collection('movies')).called(1);
    verify(mockCollectionReference.doc(mockMovie.id.toString())).called(1);
    verify(mockDocumentReference.set(any)).called(1);
  });
}
