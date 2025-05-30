import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

class FirestoreDataSource implements IDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource(this.firestore);

  Future<void> saveMovie(Movie movie) async {
    await firestore.collection('movies').doc(movie.id.toString()).set({
      'adult': movie.adult,
      'backdrop_path': movie.backdropPath,
      'id': movie.id,
      'original_language': movie.originalLanguage,
      'original_title': movie.originalTitle,
      'overview': movie.overview,
      'popularity': movie.popularity,
      'poster_path': movie.posterPath,
      'release_date': movie.releaseDate,
      'title': movie.title,
      'video': movie.video,
      'vote_average': movie.voteAverage,
      'vote_count': movie.voteCount,
    });
  }

  @override
  Future<List<Movie>> getMovies({required Endpoint endpoint}) async {
    switch (endpoint) {
      case Endpoint.popular:
        return _getPopularMovies();
      case Endpoint.topRated:
        return _getTopRatedMovies();
    }
  }

  Future<List<Movie>> _getPopularMovies() async {
    final snapshot =
        await firestore
            .collection('movies')
            .orderBy('popularity', descending: true)
            .limit(20)
            .get();
    return snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
  }

  Future<List<Movie>> _getTopRatedMovies() async {
    final snapshot =
        await firestore
            .collection('movies')
            .orderBy('vote_average', descending: true)
            .limit(20)
            .get();
    return snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
  }
}
