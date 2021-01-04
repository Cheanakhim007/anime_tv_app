import 'package:anime_tv_app/model/home_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesHomeBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<HomeResponse> _subject =
  BehaviorSubject<HomeResponse>();

  getMoviesHome() async {
    HomeResponse response = await _repository.getMoviesHomePage();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<HomeResponse> get subject => _subject;

}
final moviesSearchBloc = MoviesHomeBloc();