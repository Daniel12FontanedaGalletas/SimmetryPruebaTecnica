import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
// Ruta absoluta para encontrar la Entidad
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  // 💡 CORRECCIÓN: Usamos DioError (para Dio v4) en lugar de DioException (Dio v5)
  final DioError? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error]; 
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone(List<ArticleEntity> article) : super(articles: article);
}

class RemoteArticlesError extends RemoteArticlesState {
  // 💡 CORRECCIÓN: DioError aquí también
  const RemoteArticlesError(DioError error) : super(error: error);
}