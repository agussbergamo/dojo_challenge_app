import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

class FirestoreDataSource implements IDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource(this.firestore);

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

  @override
  Future<List<Movie>> getPopularMovies() async {
    final snapshot = await firestore.collection('movies').get();
    final movies =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return Movie.fromJson(data);
        }).toList();
    return movies;
  }
}
