import 'dart:async';
import '../../../domain/entities/movie.dart';
import 'DAOs/movie_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Movie])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}
