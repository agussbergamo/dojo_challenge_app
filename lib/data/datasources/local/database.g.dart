// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MovieDao? _movieDaoInstance;

  MovieRecommendationDao? _movieRecommendationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movies` (`adult` INTEGER, `backdropPath` TEXT, `id` INTEGER NOT NULL, `originalLanguage` TEXT, `originalTitle` TEXT, `overview` TEXT, `popularity` REAL, `posterPath` TEXT, `releaseDate` TEXT, `title` TEXT, `video` INTEGER, `voteAverage` REAL, `voteCount` INTEGER, `movieType` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movie_recommendations` (`baseMovieId` INTEGER NOT NULL, `recommendedMovieId` INTEGER NOT NULL, `order` INTEGER NOT NULL, FOREIGN KEY (`baseMovieId`) REFERENCES `movies` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`recommendedMovieId`) REFERENCES `movies` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`baseMovieId`, `recommendedMovieId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }

  @override
  MovieRecommendationDao get movieRecommendationDao {
    return _movieRecommendationDaoInstance ??=
        _$MovieRecommendationDao(database, changeListener);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'movies',
            (Movie item) => <String, Object?>{
                  'adult': item.adult == null ? null : (item.adult! ? 1 : 0),
                  'backdropPath': item.backdropPath,
                  'id': item.id,
                  'originalLanguage': item.originalLanguage,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'popularity': item.popularity,
                  'posterPath': item.posterPath,
                  'releaseDate': item.releaseDate,
                  'title': item.title,
                  'video': item.video == null ? null : (item.video! ? 1 : 0),
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'movieType': item.movieType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  @override
  Future<List<Movie>> getPopularMovies() async {
    return _queryAdapter.queryList(
        'SELECT * FROM movies WHERE movieType = \"Popular\" ORDER BY popularity DESC LIMIT 20',
        mapper: (Map<String, Object?> row) => Movie(
            adult: row['adult'] == null ? null : (row['adult'] as int) != 0,
            backdropPath: row['backdropPath'] as String?,
            id: row['id'] as int,
            originalLanguage: row['originalLanguage'] as String?,
            originalTitle: row['originalTitle'] as String?,
            overview: row['overview'] as String?,
            popularity: row['popularity'] as double?,
            posterPath: row['posterPath'] as String?,
            releaseDate: row['releaseDate'] as String?,
            title: row['title'] as String?,
            video: row['video'] == null ? null : (row['video'] as int) != 0,
            voteAverage: row['voteAverage'] as double?,
            voteCount: row['voteCount'] as int?,
            movieType: row['movieType'] as String));
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    return _queryAdapter.queryList(
        'SELECT * FROM movies WHERE movieType = \"Top Rated\" ORDER BY voteAverage DESC LIMIT 20',
        mapper: (Map<String, Object?> row) => Movie(
            adult: row['adult'] == null ? null : (row['adult'] as int) != 0,
            backdropPath: row['backdropPath'] as String?,
            id: row['id'] as int,
            originalLanguage: row['originalLanguage'] as String?,
            originalTitle: row['originalTitle'] as String?,
            overview: row['overview'] as String?,
            popularity: row['popularity'] as double?,
            posterPath: row['posterPath'] as String?,
            releaseDate: row['releaseDate'] as String?,
            title: row['title'] as String?,
            video: row['video'] == null ? null : (row['video'] as int) != 0,
            voteAverage: row['voteAverage'] as double?,
            voteCount: row['voteCount'] as int?,
            movieType: row['movieType'] as String));
  }

  @override
  Future<Movie?> getMovieById(int id) async {
    return _queryAdapter.query('SELECT * FROM movies WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            adult: row['adult'] == null ? null : (row['adult'] as int) != 0,
            backdropPath: row['backdropPath'] as String?,
            id: row['id'] as int,
            originalLanguage: row['originalLanguage'] as String?,
            originalTitle: row['originalTitle'] as String?,
            overview: row['overview'] as String?,
            popularity: row['popularity'] as double?,
            posterPath: row['posterPath'] as String?,
            releaseDate: row['releaseDate'] as String?,
            title: row['title'] as String?,
            video: row['video'] == null ? null : (row['video'] as int) != 0,
            voteAverage: row['voteAverage'] as double?,
            voteCount: row['voteCount'] as int?,
            movieType: row['movieType'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteMoviesByType(String type) async {
    await _queryAdapter.queryNoReturn('DELETE FROM movies WHERE movieType = ?1',
        arguments: [type]);
  }

  @override
  Future<void> insertMovie(Movie movie) async {
    await _movieInsertionAdapter.insert(movie, OnConflictStrategy.replace);
  }
}

class _$MovieRecommendationDao extends MovieRecommendationDao {
  _$MovieRecommendationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieRecommendationInsertionAdapter = InsertionAdapter(
            database,
            'movie_recommendations',
            (MovieRecommendation item) => <String, Object?>{
                  'baseMovieId': item.baseMovieId,
                  'recommendedMovieId': item.recommendedMovieId,
                  'order': item.order
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieRecommendation>
      _movieRecommendationInsertionAdapter;

  @override
  Future<List<int>> getRecommendedIds(int movieId) async {
    return _queryAdapter.queryList(
        'SELECT recommendedMovieId FROM movie_recommendations WHERE baseMovieId = ?1 ORDER BY `order` ASC',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [movieId]);
  }

  @override
  Future<void> deleteRecommendationsByMovieType(String type) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM movie_recommendations WHERE recommendedMovieId IN (SELECT id FROM movies WHERE movieType = ?1)',
        arguments: [type]);
  }

  @override
  Future<void> insertRecommendation(MovieRecommendation recommendation) async {
    await _movieRecommendationInsertionAdapter.insert(
        recommendation, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertRecommendations(
      List<MovieRecommendation> recommendations) async {
    await _movieRecommendationInsertionAdapter.insertList(
        recommendations, OnConflictStrategy.replace);
  }
}
