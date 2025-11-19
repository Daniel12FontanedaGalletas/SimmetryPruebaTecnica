import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
// 💡 CORRECCIÓN: Ruta absoluta
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase) : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
    on<AddCustomArticle>(onAddCustomArticle);
  }

  void onGetArticles(GetArticles event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _getArticleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteArticlesDone(dataState.data!));
    } else if (dataState is DataFailed) {
      print(dataState.error);
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  void onAddCustomArticle(AddCustomArticle event, Emitter<RemoteArticlesState> emit) {
    if (state is RemoteArticlesDone) {
      final currentList = List<ArticleEntity>.from(state.articles!);
      currentList.insert(0, event.article);
      emit(RemoteArticlesDone(currentList));
    }
  }
}