// article_entity.dart
import 'package:equatable/equatable.dart';

// La entidad (objeto de negocio puro)
class ArticleEntity extends Equatable {
  final String articleId;
  final String title;
  final String content;
  final String authorName;
  final String authorUID;
  final String category;
  final DateTime datePublished;
  final String thumbnailURL;
  final bool isPublished;

  const ArticleEntity({
    required this.articleId,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorUID,
    required this.category,
    required this.datePublished,
    required this.thumbnailURL,
    required this.isPublished,
  });

  @override
  List<Object> get props => [
        articleId,
        title,
        content,
        authorName,
        authorUID,
        category,
        datePublished,
        thumbnailURL,
        isPublished,
      ];
}