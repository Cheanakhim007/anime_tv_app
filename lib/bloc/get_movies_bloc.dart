
import 'dart:async';

import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();
  getMovies({int countPage}) async {
    MovieResponse response = await _repository.getMovies(countPage: countPage);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

  @override
  String toString() {
    return 'MoviesBloc{_subject: $_subject}';
  }
}
final moviesBloc = MoviesBloc();