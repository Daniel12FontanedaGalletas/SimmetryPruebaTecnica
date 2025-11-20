import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class RemoteArticlesEvent extends Equatable {
  const RemoteArticlesEvent();

  @override
  List<Object> get props => [];
}

class GetArticles extends RemoteArticlesEvent {
  final String? category;
  const GetArticles({this.category});
}

class AddCustomArticle extends RemoteArticlesEvent {
  final ArticleEntity article;
  const AddCustomArticle(this.article);
}

class RemoveArticle extends RemoteArticlesEvent {
  final ArticleEntity article;
  const RemoveArticle(this.article);
}
