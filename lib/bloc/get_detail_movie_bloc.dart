
import 'package:anime_tv_app/model/movie_detail.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MoviesDetailBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieDetailResponse> _subject = BehaviorSubject<MovieDetailResponse>();

  getMoviesDetail({String id}) async {
    MovieDetailResponse response = await _repository.getMoviesDetail(id);
    _subject.sink.add(response);
  }

  void drainStream(){ _subject.value = null; }
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }


  BehaviorSubject<MovieDetailResponse> get subject => _subject;

}
final moviesDetailBloc = MoviesDetailBloc();