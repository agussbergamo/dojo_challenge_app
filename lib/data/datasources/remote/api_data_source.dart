import 'dart:convert' as convert;
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/datasources/i_data_source.dart';

import '../../../domain/entities/movie.dart';
import 'package:http/http.dart' as http;

class ApiDataSource implements IDataSource{
  final http.Client client;

  ApiDataSource({required this.client});

  @override
  Future<List<Movie>> getMovies({required Endpoint endpoint}) async {
    final url = Uri.parse(endpoint.fullUrl);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var results = jsonResponse['results'];
      return List<Movie>.from(results.map((movie) => Movie.fromJson(movie)));
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
