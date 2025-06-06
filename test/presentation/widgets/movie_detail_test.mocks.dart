// Mocks generated by Mockito 5.4.5 from annotations
// in dojo_challenge_app/test/presentation/widgets/movie_detail_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dojo_challenge_app/core/parameter/data_source.dart' as _i7;
import 'package:dojo_challenge_app/core/parameter/endpoint.dart' as _i6;
import 'package:dojo_challenge_app/domain/entities/movie.dart' as _i5;
import 'package:dojo_challenge_app/domain/usecases/interfaces/i_usecase.dart'
    as _i2;
import 'package:dojo_challenge_app/presentation/bloc/movie_detail_bloc.dart'
    as _i3;
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

class _FakeIUseCase_0<T> extends _i1.SmartFake implements _i2.IUseCase<T> {
  _FakeIUseCase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MovieDetailBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieDetailBloc extends _i1.Mock implements _i3.MovieDetailBloc {
  MockMovieDetailBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IUseCase<dynamic> get moviesUsecase => (super.noSuchMethod(
        Invocation.getter(#moviesUsecase),
        returnValue: _FakeIUseCase_0<dynamic>(
          this,
          Invocation.getter(#moviesUsecase),
        ),
      ) as _i2.IUseCase<dynamic>);

  @override
  _i4.Stream<List<_i5.Movie>> get moviesStream => (super.noSuchMethod(
        Invocation.getter(#moviesStream),
        returnValue: _i4.Stream<List<_i5.Movie>>.empty(),
      ) as _i4.Stream<List<_i5.Movie>>);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> getRecommendedMovies({
    required _i6.Endpoint? endpoint,
    required int? movieId,
    _i7.DataSource? dataSource,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRecommendedMovies,
          [],
          {
            #endpoint: endpoint,
            #movieId: movieId,
            #dataSource: dataSource,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
