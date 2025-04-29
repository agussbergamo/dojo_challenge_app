import 'package:dojo_challenge_app/data/datasource/local/database_service.dart';
import 'package:dojo_challenge_app/data/datasource/remote/api_service.dart';
import 'package:dojo_challenge_app/data/repositories/movie_repository.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  //This throws an UnimplementedError because it's being overriden in main.
  //It's handled this way to prevent all providers from being FutureProviders.
  throw UnimplementedError();
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client: client);
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  return MovieRepository(
    apiService: apiService,
    databaseService: databaseService,
  );
});

final moviesBlocProvider = Provider<MoviesBloc>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return MoviesBloc(movieRepository: movieRepository);
});
