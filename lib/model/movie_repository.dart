

import 'movie.dart';

class MovieResponse {
  final List<Movie> movies;
  final String error;

  MovieResponse(this.movies, this.error);

  MovieResponse.fromJson(List json)
      : movies = (json).map((i) => new Movie.fromJson(i)).toList(),
        error = "";
  MovieResponse.withError(String errorValue)
      : movies = List(),
        error = errorValue;
}