
import 'package:anime_tv_app/model/genre_response.dart';
import 'package:anime_tv_app/model/home_repository.dart';
import 'package:anime_tv_app/model/movie_detail.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/model/video_play.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  MovieRepository();
  static void setMainUrl(String mainUrl){
    if(mainUrl != null && mainUrl.isNotEmpty)
      MovieRepository.mainUrl = mainUrl;
    else
      MovieRepository.mainUrl = "https://anime-tv.gigalixirapp.com/api/vod";
  }
  static String mainUrl = "https://anime-tv.gigalixirapp.com/api/vod";
  final Dio _dio = Dio();
  var getNewseasonUrl = '$mainUrl/newseason';
  var getPopularUrl = '$mainUrl/popular';
  var getRecentUrl = '$mainUrl/recent';
  var getMoviewUrl = '$mainUrl/movie';
  var getSearchUrl = '$mainUrl/search';
  var getHomeUrl = '$mainUrl/home';
  var getDubUrl = '$mainUrl/dub';
  var getChineUrl = '$mainUrl/chinese';
  var getDetailUrl = '$mainUrl/detail';
  var getGenresUrl = '$mainUrl/genre';
  var getGenresMovieUrl = '$mainUrl/genres';

  Future<MovieResponse> getNewSeasonMovie() async {
    try {
      print("link  $getNewseasonUrl");
      Response response = await _dio.get(getNewseasonUrl);
    print("Result: ${response.statusCode}");
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPopularMovies({int countPage}) async {
    try {
      print("link  ${getPopularUrl + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getPopularUrl + "?page=${countPage.toString()}");
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

  Future<MovieResponse> getRecenMovies({int countPage}) async {
    try {
      print("link  ${getRecentUrl + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getRecentUrl + "?page=${countPage.toString()}");
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

  Future<MovieResponse> getDubMovies({int countPage = 1}) async {
    try {
      print("link  ${getDubUrl + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getDubUrl + "?page=${countPage.toString()}");
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
  Future<MovieResponse> getChineseMovies({int countPage = 1}) async {
    try {
      print("link  ${getChineUrl + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getChineUrl + "?page=${countPage.toString()}");
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

  Future<MovieResponse> getSearch(String keyword, {int countPage = 2}) async {
    try {
      print("link  ${getSearchUrl + "?page=${countPage.toString()}"} with params $keyword}");

      var params = {
        "q": keyword,
      };

      Response response = await _dio.get(getSearchUrl + "?page=${countPage.toString()}" , queryParameters: params);
      print("Result: ${response.data['code']}");
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
      print("link  $getHomeUrl");
      Response response = await _dio.get(getHomeUrl);
      print("Result: ${response.statusCode}");
      return HomeResponse.fromJson(response.data['result']['data']);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return HomeResponse.withError("$error");
    }
  }

  Future<MovieDetailResponse> getMoviesDetail(String id) async {
    try {
      print("link  $getDetailUrl/$id");
      Response response = await _dio.get(getDetailUrl+"/$id");
      print("Result: ${response.data['code']}");
      if(response.data['code'] == 200)
        return MovieDetailResponse.fromJson([response.data['result']['data']]);
      else
        return MovieDetailResponse.withError("No movie");
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<VideoPlay> getMoviesPlay(String id) async {
    try {
      print("link  $getDetailUrl/$id");
      Response response = await _dio.get(getDetailUrl+"/$id");
      print("Result: ${response.data['code']}");
      if(response.data['code'] == 200)
        return VideoPlay.fromJson(response.data['result']);
      else
         print("Exception occured: get movie play");
        return null;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<GenreResponse> getGenres() async {
    try {
      Response response = await _dio.get(getGenresUrl);
      return GenreResponse.fromJson(response.data['result']['data']);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GenreResponse.withError("$error");
    }
  }


  Future<MovieResponse> getMovieByGenre(String id, {int countPage = 1}) async {
    try {
      print("link  ${getGenresMovieUrl + "/$id" + "?page=${countPage.toString()}"}");
      Response response = await _dio.get(getGenresMovieUrl + "/$id" + "?page=${countPage.toString()}");
      print("====> ${response.statusCode}");
      if(List.from(response.data['result']['data']).length > 0 && !List.from(response.data['result']['data'])[0].toString().contains("Can't find page 2 genre/yuri 404"))
          return MovieResponse.fromJson(response.data['result']['data']);
      else
        return  MovieResponse.withError("${response.data['code']}");
    } catch (error, stacktrace) {
      print("Exception : $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

}
