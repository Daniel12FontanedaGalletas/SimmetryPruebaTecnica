import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  final List<ArticleEntity> _userAddedArticles = [];

  RemoteArticlesBloc(this._getArticleUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
    on<AddCustomArticle>(onAddCustomArticle);
    on<RemoveArticle>(onRemoveArticle);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    emit(const RemoteArticlesLoading());
    final dataState = await _getArticleUseCase(params: event.category);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      final articles = dataState.data!;
      final uniqueArticles = <ArticleEntity>[];
      final seenUrls = <String>{};

      for (final article in articles) {
        if (article.url != null && seenUrls.add(article.url!)) {
          uniqueArticles.add(article);
        }
      }

      if (event.category == 'general' || event.category == null) {
        final combinedList = [..._userAddedArticles, ...uniqueArticles];
        emit(RemoteArticlesDone(combinedList));
      } else {
        emit(RemoteArticlesDone(uniqueArticles));
      }
    } else if (dataState is DataFailed) {
      print(dataState.error);
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  void onAddCustomArticle(
      AddCustomArticle event, Emitter<RemoteArticlesState> emit) {
    final isDuplicateInUserList = _userAddedArticles
        .any((article) => article.title == event.article.title);
    if (!isDuplicateInUserList) {
      _userAddedArticles.insert(0, event.article);
    }

    if (state is RemoteArticlesDone) {
      final currentList = List<ArticleEntity>.from(state.articles!);

      final isDuplicateInCurrentList =
          currentList.any((article) => article.title == event.article.title);

      if (!isDuplicateInCurrentList) {
        currentList.insert(0, event.article);
        emit(RemoteArticlesDone(currentList));
      }
    }
  }

  void onRemoveArticle(RemoveArticle event, Emitter<RemoteArticlesState> emit) {
    _userAddedArticles
        .removeWhere((article) => article.title == event.article.title);

    if (state is RemoteArticlesDone) {
      final currentList = List<ArticleEntity>.from(state.articles!);
      currentList.removeWhere((article) =>
          article.id == event.article.id &&
          article.title == event.article.title);
      emit(RemoteArticlesDone(currentList));
    }
  }
}
