import 'package:equatable/equatable.dart';
// 💡 CORRECCIÓN: Ruta absoluta para encontrar la entidad Article
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class RemoteArticlesEvent extends Equatable {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  final String? category;
  const GetArticles({this.category});

  @override
  List<Object> get props => [category ?? ''];
}

class AddCustomArticle extends RemoteArticlesEvent {
  final ArticleEntity article;
  const AddCustomArticle(this.article);

  @override
  List<Object> get props => [article];
}

class RemoveArticle extends RemoteArticlesEvent {
  final ArticleEntity article;
  const RemoveArticle(this.article);

  @override
  List<Object> get props => [article];
}
