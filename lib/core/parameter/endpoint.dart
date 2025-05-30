enum Endpoint {
  popular,
  topRated;

  final String baseUrl = 'https://api.themoviedb.org/3/movie/';
  final String apiKey = '?api_key=';
  final String apiKeyValue = '025aa98c350d497beb053d9b5e169637';
  final String popularKey = 'popular';
  final String topRatedKey = 'top_rated';
  final String popularString = 'Popular';
  final String topRatedString = 'Top Rated';

  String get value {
    switch (this) {
      case Endpoint.popular:
        return popularString;
      case Endpoint.topRated:
        return topRatedString;
    }
  }

  String get fullUrl {
    switch (this) {
      case Endpoint.popular:
        return '$baseUrl$popularKey$apiKey$apiKeyValue';
      case Endpoint.topRated:
        return '$baseUrl$topRatedKey$apiKey$apiKeyValue';
    }
  }
}
