import 'package:anime_tv_app/model/movie.dart';

class MovieDetailResponse{
  final List<Movie> movies;
  final String error;
  final List<Movie> release;

  MovieDetailResponse(this.movies, this.error, this.release);

  MovieDetailResponse.fromJson(List json)
      : movies = (json).map((i) => new Movie.fromJson(i)).toList(),
        release = List.from((json[0]['related']).map((i) => new Movie.fromJson(i)).toList()),
        error = "";
  MovieDetailResponse.withError(String errorValue)
      : movies = List(),
        release = [],
        error = errorValue;

  @override
  String toString() {
    return 'MovieDetail{movies: $movies, error: $error, release: $release}';
  }
}