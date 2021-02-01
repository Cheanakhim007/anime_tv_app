
import 'package:anime_tv_app/model/genre.dart';
class GenreResponse {
  final List<Genre> genres;
  final String error;

  GenreResponse(this.genres, this.error);

  GenreResponse.fromJson(List json)
      : genres = (json).map((i) => new Genre.fromJson(i)).toList(),
        error = "";

  GenreResponse.withError(String errorValue)
      : genres = List(),
        error = errorValue;
}