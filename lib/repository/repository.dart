
import 'package:anime_tv_app/model/home_repository.dart';
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
  var getHomeUrl = '$mainUrl/home';

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

  Future<MovieResponse> getMovies({int countPage = 1}) async {
    try {
      print("link  ${getMoviewUrl + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getMoviewUrl + "?page=${countPage.toString()}");
      print("Result: ${response.statusCode}");
      if(response.data['code'] == 200)
         return MovieResponse.fromJson(response.data['result']['data']);
      else
        return  MovieResponse.withError("${response.data['code']}");
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSearch(String keyword) async {
    try {
      print("link  ${getSearchUrl} with params $keyword}");

      var params = {
        "q": keyword,
      };

      Response response = await _dio.get(getSearchUrl, queryParameters: params);
      print("Result: ${response.data}");
      if(response.data['code'] == 200)
         return MovieResponse.fromJson(response.data['result']['data']);
      else
        return MovieResponse.withError("No movie");
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<HomeResponse> getMoviesHomePage() async {
    try {
      print("link  ${getHomeUrl}");
      Response response = await _dio.get(getHomeUrl);
      print("Result: ${response.statusCode}");
      return HomeResponse.fromJson(response.data['result']['data']);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return HomeResponse.withError("$error");
    }
  }

}
