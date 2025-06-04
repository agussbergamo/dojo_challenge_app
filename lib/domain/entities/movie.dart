import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'movies')
class Movie {
  final bool? adult;
  final String? backdropPath;
  @primaryKey
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String movieType;

  String get fullBackdrop =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : '';

  String get fullPoster =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  Movie({
    this.adult,
    this.backdropPath,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    required this.movieType,
  });

  factory Movie.fromJson(Map<String, dynamic> json, Endpoint movieType) {
    return Movie(
      adult: json['adult'] as bool?,
      backdropPath: json['backdrop_path'] as String?,
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      movieType: movieType.value,
    );
  }
}
