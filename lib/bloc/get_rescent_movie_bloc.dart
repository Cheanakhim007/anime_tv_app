
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesRecentListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
  BehaviorSubject<MovieResponse>();

  getMoviesRecent() async {
    MovieResponse response = await _repository.getRecenMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}
final moviesRecentBloc = MoviesRecentListBloc();