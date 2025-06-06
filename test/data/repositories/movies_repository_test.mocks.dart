// Mocks generated by Mockito 5.4.5 from annotations
// in dojo_challenge_app/test/data/repositories/movies_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:connectivity_plus/connectivity_plus.dart' as _i11;
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart'
    as _i12;
import 'package:dojo_challenge_app/core/parameter/endpoint.dart' as _i8;
import 'package:dojo_challenge_app/data/datasources/local/database.dart' as _i3;
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart'
    as _i9;
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart'
    as _i5;
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart'
    as _i10;
import 'package:dojo_challenge_app/domain/entities/movie.dart' as _i7;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeClient_0 extends _i1.SmartFake implements _i2.Client {
  _FakeClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAppDatabase_1 extends _i1.SmartFake implements _i3.AppDatabase {
  _FakeAppDatabase_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_2 extends _i1.SmartFake
    implements _i4.FirebaseFirestore {
  _FakeFirebaseFirestore_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ApiDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiDataSource extends _i1.Mock implements _i5.ApiDataSource {
  MockApiDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Client get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeClient_0(
          this,
          Invocation.getter(#client),
        ),
      ) as _i2.Client);

  @override
  _i6.Future<List<_i7.Movie>> getMovies({
    required _i8.Endpoint? endpoint,
    int? movieId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovies,
          [],
          {
            #endpoint: endpoint,
            #movieId: movieId,
          },
        ),
        returnValue: _i6.Future<List<_i7.Movie>>.value(<_i7.Movie>[]),
      ) as _i6.Future<List<_i7.Movie>>);
}

/// A class which mocks [DatabaseDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseDataSource extends _i1.Mock
    implements _i9.DatabaseDataSource {
  MockDatabaseDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.AppDatabase get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeAppDatabase_1(
          this,
          Invocation.getter(#database),
        ),
      ) as _i3.AppDatabase);

  @override
  _i6.Future<List<_i7.Movie>> getMovies({
    required _i8.Endpoint? endpoint,
    int? movieId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovies,
          [],
          {
            #endpoint: endpoint,
            #movieId: movieId,
          },
        ),
        returnValue: _i6.Future<List<_i7.Movie>>.value(<_i7.Movie>[]),
      ) as _i6.Future<List<_i7.Movie>>);

  @override
  _i6.Future<void> insertMovie(_i7.Movie? movie) => (super.noSuchMethod(
        Invocation.method(
          #insertMovie,
          [movie],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> insertRecommendedMovie({
    required int? baseMovieId,
    required _i7.Movie? recommendedMovie,
    required int? order,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertRecommendedMovie,
          [],
          {
            #baseMovieId: baseMovieId,
            #recommendedMovie: recommendedMovie,
            #order: order,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteMoviesByType(String? movieType) => (super.noSuchMethod(
        Invocation.method(
          #deleteMoviesByType,
          [movieType],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteRecommendationsByMovieType(String? movieType) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteRecommendationsByMovieType,
          [movieType],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [FirestoreDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirestoreDataSource extends _i1.Mock
    implements _i10.FirestoreDataSource {
  MockFirestoreDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_2(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i4.FirebaseFirestore);

  @override
  _i6.Future<void> insertMovie(_i7.Movie? movie) => (super.noSuchMethod(
        Invocation.method(
          #insertMovie,
          [movie],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> insertRecommendedMovie({
    required int? baseMovieId,
    required _i7.Movie? recommendedMovie,
    required int? order,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertRecommendedMovie,
          [],
          {
            #baseMovieId: baseMovieId,
            #recommendedMovie: recommendedMovie,
            #order: order,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<List<_i7.Movie>> getMovies({
    required _i8.Endpoint? endpoint,
    int? movieId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovies,
          [],
          {
            #endpoint: endpoint,
            #movieId: movieId,
          },
        ),
        returnValue: _i6.Future<List<_i7.Movie>>.value(<_i7.Movie>[]),
      ) as _i6.Future<List<_i7.Movie>>);

  @override
  _i6.Future<void> deleteMoviesByType(String? movieType) => (super.noSuchMethod(
        Invocation.method(
          #deleteMoviesByType,
          [movieType],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteRecommendationsByMovieType(String? movieType) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteRecommendationsByMovieType,
          [movieType],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [Connectivity].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectivity extends _i1.Mock implements _i11.Connectivity {
  MockConnectivity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Stream<List<_i12.ConnectivityResult>> get onConnectivityChanged =>
      (super.noSuchMethod(
        Invocation.getter(#onConnectivityChanged),
        returnValue: _i6.Stream<List<_i12.ConnectivityResult>>.empty(),
      ) as _i6.Stream<List<_i12.ConnectivityResult>>);

  @override
  _i6.Future<List<_i12.ConnectivityResult>> checkConnectivity() =>
      (super.noSuchMethod(
        Invocation.method(
          #checkConnectivity,
          [],
        ),
        returnValue: _i6.Future<List<_i12.ConnectivityResult>>.value(
            <_i12.ConnectivityResult>[]),
      ) as _i6.Future<List<_i12.ConnectivityResult>>);
}
