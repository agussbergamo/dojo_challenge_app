import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';

abstract class IUseCase<T> {
  Future<T> call({required Endpoint endpoint, DataSource? dataSource, int? movieId});
}
