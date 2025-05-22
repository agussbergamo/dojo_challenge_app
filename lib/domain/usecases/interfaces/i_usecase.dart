import 'package:dojo_challenge_app/core/parameter/data_source.dart';

abstract class IUseCase<T> {
  Future<T> call({DataSource? dataSource});
}
