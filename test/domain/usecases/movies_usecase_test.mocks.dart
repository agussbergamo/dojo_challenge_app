// Mocks generated by Mockito 5.4.5 from annotations
// in dojo_challenge_app/test/domain/usecases/movies_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:connectivity_plus/connectivity_plus.dart' as _i5;
import 'package:dojo_challenge_app/core/parameter/data_source.dart' as _i10;
import 'package:dojo_challenge_app/core/parameter/endpoint.dart' as _i9;
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart'
    as _i3;
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart'
    as _i2;
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart'
    as _i4;
import 'package:dojo_challenge_app/data/repositories/movies_repository.dart'
    as _i6;
import 'package:dojo_challenge_app/domain/entities/movie.dart' as _i8;
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

class _FakeApiDataSource_0 extends _i1.SmartFake implements _i2.ApiDataSource {
  _FakeApiDataSource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabaseDataSource_1 extends _i1.SmartFake
    implements _i3.DatabaseDataSource {
  _FakeDatabaseDataSource_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirestoreDataSource_2 extends _i1.SmartFake
    implements _i4.FirestoreDataSource {
  _FakeFirestoreDataSource_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeConnectivity_3 extends _i1.SmartFake implements _i5.Connectivity {
  _FakeConnectivity_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MoviesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMoviesRepository extends _i1.Mock implements _i6.MoviesRepository {
  MockMoviesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ApiDataSource get apiDataSource => (super.noSuchMethod(
        Invocation.getter(#apiDataSource),
        returnValue: _FakeApiDataSource_0(
          this,
          Invocation.getter(#apiDataSource),
        ),
      ) as _i2.ApiDataSource);

  @override
  _i3.DatabaseDataSource get databaseDataSource => (super.noSuchMethod(
        Invocation.getter(#databaseDataSource),
        returnValue: _FakeDatabaseDataSource_1(
          this,
          Invocation.getter(#databaseDataSource),
        ),
      ) as _i3.DatabaseDataSource);

  @override
  _i4.FirestoreDataSource get firestoreDataSource => (super.noSuchMethod(
        Invocation.getter(#firestoreDataSource),
        returnValue: _FakeFirestoreDataSource_2(
          this,
          Invocation.getter(#firestoreDataSource),
        ),
      ) as _i4.FirestoreDataSource);

  @override
  _i5.Connectivity get connectivity => (super.noSuchMethod(
        Invocation.getter(#connectivity),
        returnValue: _FakeConnectivity_3(
          this,
          Invocation.getter(#connectivity),
        ),
      ) as _i5.Connectivity);

  @override
  _i7.Future<List<_i8.Movie>> getMovies({
    required _i9.Endpoint? endpoint,
    _i10.DataSource? dataSource,
    int? movieId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovies,
          [],
          {
            #endpoint: endpoint,
            #dataSource: dataSource,
            #movieId: movieId,
          },
        ),
        returnValue: _i7.Future<List<_i8.Movie>>.value(<_i8.Movie>[]),
      ) as _i7.Future<List<_i8.Movie>>);
}
