import 'dart:convert' as convert;
import '../../../domain/entities/movie.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client; 
  final String endpoint = 'https://api.themoviedb.org/3/movie/popular';
  final String apiKey = '?api_key=';
  final String apiKeyValue = '025aa98c350d497beb053d9b5e169637';

  ApiService({required this.client});

  Future<List<Movie>> getPopularMovies() async {
    final url = Uri.parse('$endpoint$apiKey$apiKeyValue');
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
