
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesDetailBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getMoviesDetail({String id}) async {
    MovieResponse response = await _repository.getMoviesDetail(id);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}
final moviesDetailBloc = MoviesDetailBloc();