import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/upload_article_image_usecase.dart';
import 'article_creation_state.dart';

class ArticleCreationCubit extends Cubit<ArticleCreationState> {
  final CreateArticleUseCase createArticleUseCase;
  final UploadArticleImageUseCase uploadArticleImageUseCase;

  // Inyectamos AMBOS casos de uso
  ArticleCreationCubit(this.createArticleUseCase, this.uploadArticleImageUseCase)
      : super(const ArticleCreationState());

  Future<void> submitArticle({
    required ArticleEntity article,
    String? imagePath, // Ruta local de la imagen seleccionada
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    String finalThumbnailUrl = article.thumbnailURL; 

    // 1. Si hay una imagen seleccionada, subirla primero
    if (imagePath != null) {
      final uploadResult = await uploadArticleImageUseCase(imagePath);
      
      // Variable para controlar el flujo dentro del fold
      bool uploadSuccess = true;

      uploadResult.fold(
        (error) {
          emit(state.copyWith(isLoading: false, errorMessage: "Error subiendo imagen: $error"));
          uploadSuccess = false;
        },
        (url) {
          finalThumbnailUrl = url; // ¡Guardamos la URL de Firebase!
        },
      );

      if (!uploadSuccess) return; // Si falló la imagen, no seguimos.
    }

    // 2. Crear el artículo con la URL final
    final articleWithImage = ArticleEntity(
      articleId: article.articleId,
      title: article.title,
      content: article.content,
      authorName: article.authorName,
      authorUID: article.authorUID,
      category: article.category,
      datePublished: article.datePublished,
      thumbnailURL: finalThumbnailUrl, 
      isPublished: article.isPublished,
    );

    final createResult = await createArticleUseCase(articleWithImage);

    createResult.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
          isSuccess: false,
        ));
      },
      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }
}