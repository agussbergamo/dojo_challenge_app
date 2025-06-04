import 'dart:async';
import 'package:dojo_challenge_app/data/datasources/local/DAOs/movie_recommendation_dao.dart';
import 'package:dojo_challenge_app/domain/entities/movie_recommendation.dart';

import '../../../domain/entities/movie.dart';
import 'DAOs/movie_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Movie, MovieRecommendation])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
  MovieRecommendationDao get movieRecommendationDao;
}
