import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/get_uploaded_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/delete_article_usecase.dart'; // Importar
import 'package:equatable/equatable.dart';

// ESTADOS
abstract class MyArticlesState extends Equatable {
  const MyArticlesState();
  @override
  List<Object> get props => [];
}
class MyArticlesLoading extends MyArticlesState {}
class MyArticlesLoaded extends MyArticlesState {
  final List<ArticleEntity> articles;
  const MyArticlesLoaded(this.articles);
  @override
  List<Object> get props => [articles];
}
class MyArticlesError extends MyArticlesState {
  final String message;
  const MyArticlesError(this.message);
  @override
  List<Object> get props => [message];
}

// CUBIT
class MyArticlesCubit extends Cubit<MyArticlesState> {
  final GetUploadedArticlesUseCase getUploadedArticlesUseCase;
  final DeleteArticleUseCase deleteArticleUseCase; // Nuevo caso de uso

  MyArticlesCubit(this.getUploadedArticlesUseCase, this.deleteArticleUseCase) 
      : super(MyArticlesLoading());

  Future<void> loadArticles() async {
    emit(MyArticlesLoading());
    final result = await getUploadedArticlesUseCase();
    
    result.fold(
      (error) => emit(MyArticlesError(error.toString())),
      (articles) => emit(MyArticlesLoaded(articles)),
    );
  }

  // 💡 NUEVO: Función Borrar
  Future<void> deleteArticle(String articleId) async {
    await deleteArticleUseCase(articleId);
    // Recargamos la lista después de borrar para actualizar la UI
    loadArticles(); 
  }
}