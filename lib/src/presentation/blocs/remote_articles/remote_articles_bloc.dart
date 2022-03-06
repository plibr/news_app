import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/bloc/bloc_with_state.dart';
import '../../../core/params/article_request.dart';
import '../../../core/resources/data_state.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/usecases/get_articles_usecase.dart';

part 'remote_articles_event.dart';
part 'remote_articles_state.dart';

class RemoteArticlesBloc
    extends BlocWithState<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;

  final List<Article> _articles = [];
  int _page = 1;
  static const int _pageSize = 5;

  RemoteArticlesBloc(this._getArticlesUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>((event, emit) => _eventA(event, emit));
  }

  void _eventA(event, emit) async {
    await for (final result in _getBreakingNewsArticle(event)) {
      if (event is GetArticles) emit(result);
    }
  }

  Stream<RemoteArticlesState> _getBreakingNewsArticle(
      RemoteArticlesEvent event) async* {
    yield* runBlocProcess(() async* {
      final dataState =
          await _getArticlesUseCase(params: ArticlesRequestParams(page: _page));

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        final articles = dataState.data;
        final noMoreData = articles!.length < _pageSize;
        _articles.addAll(articles);
        _page++;

        yield RemoteArticlesDone(_articles, noMoreData: noMoreData);
      }
      if (dataState is DataFailed) {
        yield RemoteArticlesError(dataState.error!);
      }
    });
  }
}
