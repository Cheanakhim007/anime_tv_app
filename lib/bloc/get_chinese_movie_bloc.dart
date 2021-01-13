
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesChineseListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getMoviesChinese({int countPage}) async {
    MovieResponse response = await _repository.getChineseMovies(countPage: countPage);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}
final moviesChineseBloc = MoviesChineseListBloc();