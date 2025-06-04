import 'package:dojo_challenge_app/domain/entities/movie_recommendation.dart';
import 'package:floor/floor.dart';

@dao
abstract class MovieRecommendationDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecommendation(MovieRecommendation recommendation);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecommendations(List<MovieRecommendation> recommendations);

  @Query(
    'SELECT recommendedMovieId FROM movie_recommendations WHERE baseMovieId = :movieId ORDER BY `order` ASC',
  )
  Future<List<int>> getRecommendedIds(int movieId);

  @Query(
    'DELETE FROM movie_recommendations WHERE recommendedMovieId IN (SELECT id FROM movies WHERE movieType = :type)',
  )
  Future<void> deleteRecommendationsByMovieType(String type);
}