import 'movie.dart';

class HomeResponse {
  final List<Movie> newSeason;
  final List<Movie> popular;
  final List<Movie> recent;
  final List<Movie> dub;
  final List<Movie> chinese;
  final String error;

  HomeResponse(this.dub, this.chinese, this.popular, this.recent, this.newSeason, this.error);

  HomeResponse.fromJson(Map json)
      : newSeason = (json['onGoing'] as List).map((i) => new Movie.fromJson(i)).toList(),
        popular = (json['popular'] as List).map((i) => new Movie.fromJson(i)).toList(),
        recent = (json['recent'] as List ).map((i) => new Movie.fromJson(i)).toList(),
        dub = (json['dub'] as List).map((i) => new Movie.fromJson(i)).toList(),
        chinese = (json['chinese'] as List).map((i) => new Movie.fromJson(i)).toList(),
        error = "";

  HomeResponse.withError(String errorValue)
      : newSeason = List(),
        popular = List(),
        recent = List(),
        dub = List(),
        chinese = List(),
        error = errorValue;

  @override
  String toString() {
    return 'HomeResponse{newSeason: $newSeason, popular: $popular, recent: $recent, dub: $dub, chinese: $chinese, error: $error}';
  }
}