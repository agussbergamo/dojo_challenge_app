import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';

class FirestoreDataSource implements IDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource(this.firestore);

  Future<void> insertMovie(Movie movie) async {
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
      'movie_type': movie.movieType,
    });
  }

  Future<void> insertRecommendedMovie({
    required int baseMovieId,
    required Movie recommendedMovie,
    required int order,
  }) async {
    await firestore
        .collection('movies')
        .doc(baseMovieId.toString())
        .collection('recommendations')
        .doc(recommendedMovie.id.toString())
        .set({
          'adult': recommendedMovie.adult,
          'backdrop_path': recommendedMovie.backdropPath,
          'id': recommendedMovie.id,
          'original_language': recommendedMovie.originalLanguage,
          'original_title': recommendedMovie.originalTitle,
          'overview': recommendedMovie.overview,
          'popularity': recommendedMovie.popularity,
          'poster_path': recommendedMovie.posterPath,
          'release_date': recommendedMovie.releaseDate,
          'title': recommendedMovie.title,
          'video': recommendedMovie.video,
          'vote_average': recommendedMovie.voteAverage,
          'vote_count': recommendedMovie.voteCount,
          'movie_type': recommendedMovie.movieType,
          'order': order,
        });
  }

  @override
  Future<List<Movie>> getMovies({
    required Endpoint endpoint,
    int? movieId,
  }) async {
    switch (endpoint) {
      case Endpoint.popular:
        return _getPopularMovies(endpoint);
      case Endpoint.topRated:
        return _getTopRatedMovies(endpoint);
      case Endpoint.recommendations:
        if (movieId == null) {
          throw ArgumentError('movieId is required for recommendations');
        }
        return _getRecommendationsForMovie(endpoint, movieId);
    }
  }

  Future<List<Movie>> _getPopularMovies(Endpoint endpoint) async {
    final snapshot =
        await firestore
            .collection('movies')
            .where('movie_type', isEqualTo: 'Popular')
            .orderBy('popularity', descending: true)
            .limit(20)
            .get();

    return snapshot.docs
        .map((doc) => Movie.fromJson(doc.data(), endpoint))
        .toList();
  }

  Future<List<Movie>> _getTopRatedMovies(Endpoint endpoint) async {
    final snapshot =
        await firestore
            .collection('movies')
            .where('movie_type', isEqualTo: 'Top Rated')
            .orderBy('vote_average', descending: true)
            .limit(20)
            .get();

    return snapshot.docs
        .map((doc) => Movie.fromJson(doc.data(), endpoint))
        .toList();
  }

  Future<List<Movie>> _getRecommendationsForMovie(
    Endpoint endpoint,
    int movieId,
  ) async {
    final snapshot =
        await firestore
            .collection('movies')
            .doc(movieId.toString())
            .collection('recommendations')
            .orderBy('order')
            .limit(20)
            .get();

    return snapshot.docs
        .map((doc) => Movie.fromJson(doc.data(), endpoint))
        .toList();
  }

  Future<void> deleteMoviesByType(String movieType) async {
    final snapshot =
        await firestore
            .collection('movies')
            .where('movie_type', isEqualTo: movieType)
            .get();

    if (snapshot.docs.isEmpty) return;

    final batch = firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteRecommendationsByMovieType(String movieType) async {
    final moviesSnapshot =
        await firestore
            .collection('movies')
            .where('movie_type', isEqualTo: movieType)
            .get();

    final movieIds = moviesSnapshot.docs.map((doc) => doc['id']).toSet();

    if (movieIds.isEmpty) return;

    final recsSnapshot =
        await firestore.collection('movie_recommendations').get();

    final batch = firestore.batch();

    for (var doc in recsSnapshot.docs) {
      final recommendedId = doc['recommendedMovieId'];
      if (movieIds.contains(recommendedId)) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
  }
}
