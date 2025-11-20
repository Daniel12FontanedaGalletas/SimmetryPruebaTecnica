import 'package:equatable/equatable.dart';

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

  ArticleEntity copyWith({
    String? articleId,
    String? title,
    String? content,
    String? authorName,
    String? authorUID,
    String? category,
    DateTime? datePublished,
    String? thumbnailURL,
    bool? isPublished,
  }) {
    return ArticleEntity(
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorUID: authorUID ?? this.authorUID,
      category: category ?? this.category,
      datePublished: datePublished ?? this.datePublished,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  List<Object?> get props => [
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
