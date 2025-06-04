import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'movie_recommendations',
  primaryKeys: ['baseMovieId', 'recommendedMovieId'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['baseMovieId'],
      parentColumns: ['id'],
      entity: Movie,
      onDelete: ForeignKeyAction.cascade
    ),
    ForeignKey(
      childColumns: ['recommendedMovieId'],
      parentColumns: ['id'],
      entity: Movie,
      onDelete: ForeignKeyAction.cascade
    ),
  ],
)
class MovieRecommendation {
  final int baseMovieId;
  final int recommendedMovieId;
  final int order; 

  MovieRecommendation(this.baseMovieId, this.recommendedMovieId, this.order);
}
