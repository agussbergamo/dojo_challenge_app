import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

class FirestoreService {
  final FirebaseFirestore firestore;

  FirestoreService(this.firestore);

  Future<void> saveMovie(Movie movie) async {
    await firestore.collection('movies').doc(movie.id.toString()).set({
      'adult': movie.adult,
      'id': movie.id,
      'original_language': movie.originalLanguage,
      'original_title': movie.originalTitle,
      'overview': movie.overview,
      'popularity': movie.popularity,
      'release_date': movie.releaseDate,
      'title': movie.title,
      'video': movie.video,
      'vote_average': movie.voteAverage,
      'vote_count': movie.voteCount,
    });
  }

  Future<List<Movie>> getMovies() async {
    final snapshot = await firestore.collection('movies').get();
    final movies =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return Movie.fromJson(data);
        }).toList();
    return movies;
  }
}
