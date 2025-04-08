import 'dart:convert' as convert;
import 'movie.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final String endpoint = 'https://api.themoviedb.org/3/movie/popular';
  final String apiKey = '?api_key=';
  final String apiKeyValue = '025aa98c350d497beb053d9b5e169637';

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  Future<List<Movie>> getPopularMovies() async {
    final url = Uri.parse('$endpoint$apiKey$apiKeyValue');
    final response = await http.get(url);

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
