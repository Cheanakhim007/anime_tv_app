
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  static String mainUrl = "https://anime-tv.gigalixirapp.com/api/vod";
  final Dio _dio = Dio();
  var getNewseasonUrl = '$mainUrl/newseason';
  var getPopularUrl = '$mainUrl/popular';
  var getRecentUrl = '$mainUrl/recent';
  var getMoviewUrl = '$mainUrl/movie';
  var getSearchUrl = '$mainUrl/search';

  Future<MovieResponse> getNewSeasonMovie() async {
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

  Future<MovieResponse> getPopularMovies() async {
    try {
      print("link  ${getPopularUrl}");
      Response response = await _dio.get(getPopularUrl);
      print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getRecenMovies() async {
    try {
      print("link  ${getRecentUrl}");
      Response response = await _dio.get(getRecentUrl);
      print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovies() async {
    try {
      print("link  ${getMoviewUrl}");
      Response response = await _dio.get(getMoviewUrl);
      print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSearch(String keyword) async {
    try {
      print("link  ${getSearchUrl}");

      var params = {
        "q": keyword,
      };

      Response response = await _dio.get(getSearchUrl, queryParameters: params);
      print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

}
