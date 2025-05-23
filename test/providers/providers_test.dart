import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/repositories/movies_repository.dart';
import 'package:dojo_challenge_app/domain/usecases/implementations/movies_usecase.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/providers/providers.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        httpClientProvider.overrideWithValue(MockHttpClient()),
        databaseDataSourceProvider.overrideWithValue(MockDatabaseDataSource()),
        firestoreDataSourceProvider.overrideWithValue(
          FirestoreDataSource(MockFirebaseFirestore()),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('httpClientProvider provides a http.Client', () {
    final client = container.read(httpClientProvider);
    expect(client, isA<http.Client>());
  });

  test('apiDataSourceProvider provides an ApiDataSource', () {
    final dataSource = container.read(apiDataSourceProvider);
    expect(dataSource, isNotNull);
  });

  test('firestoreDataSourceProvider provides FirestoreDataSource', () {
    final firestore = container.read(firestoreDataSourceProvider);
    expect(firestore, isA<FirestoreDataSource>());
  });

  test('moviesRepositoryProvider provides MoviesRepository', () {
    final repository = container.read(moviesRepositoryProvider);
    expect(repository, isA<MoviesRepository>());
  });

  test('moviesUseCaseProvider provides MoviesUseCase', () {
    final usecase = container.read(moviesUseCaseProvider);
    expect(usecase, isA<MoviesUseCase>());
  });

  test('moviesBlocProvider provides MoviesBloc', () {
    final bloc = container.read(moviesBlocProvider);
    expect(bloc, isA<MoviesBloc>());
  });

  test('goRouterProvider provides GoRouter', () {
    final router = container.read(goRouterProvider);
    expect(router, isNotNull);
  });
}
