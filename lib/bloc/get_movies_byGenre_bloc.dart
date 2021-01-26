import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListByGenreBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMoviesByGenre(String id , {int countPage = 1}) async {
    MovieResponse response = await _repository.getMovieByGenre(id, countPage: countPage);
    _subject.sink.add(response);
  }

  void drainStream(){ _subject.value = null; }
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
  
}
final moviesByGenreBloc = MoviesListByGenreBloc();