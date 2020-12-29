
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  static String mainUrl = "https://anime-tv.gigalixirapp.com/api/vod";
  final Dio _dio = Dio();
  var getNewseasonUrl = '$mainUrl/newseason';

  Future<MovieResponse> getMovies() async {
    try {
      print("link  ${getNewseasonUrl}");
      Response response = await _dio.get(getNewseasonUrl);
    print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

}
