import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
// 💡 CORRECCIÓN: Ruta absoluta
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
    on<AddCustomArticle>(onAddCustomArticle);
    on<RemoveArticle>(onRemoveArticle);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _getArticleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      // Lógica para eliminar duplicados de la carga inicial
      final articles = dataState.data!;
      final uniqueArticles = <ArticleEntity>[];
      final seenUrls = <String>{};

      for (final article in articles) {
        if (article.url != null && seenUrls.add(article.url!)) {
          uniqueArticles.add(article);
        }
      }
      emit(RemoteArticlesDone(uniqueArticles));
    } else if (dataState is DataFailed) {
      print(dataState.error);
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  void onAddCustomArticle(
      AddCustomArticle event, Emitter<RemoteArticlesState> emit) {
    if (state is RemoteArticlesDone) {
      final currentList = List<ArticleEntity>.from(state.articles!);

      // Comprobar si ya existe un artículo con el mismo título
      final isDuplicate =
          currentList.any((article) => article.title == event.article.title);

      if (!isDuplicate) {
        currentList.insert(0, event.article);
        emit(RemoteArticlesDone(currentList));
      }
      // Si es un duplicado, no hacemos nada y el estado no cambia.
    }
  }

  void onRemoveArticle(RemoveArticle event, Emitter<RemoteArticlesState> emit) {
    if (state is RemoteArticlesDone) {
      final currentList = List<ArticleEntity>.from(state.articles!);
      currentList.removeWhere((article) =>
          article.id == event.article.id && article.url == event.article.url);
      emit(RemoteArticlesDone(currentList));
    }
  }
}
