import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/upload_article_image_usecase.dart';
import 'article_creation_state.dart';

class ArticleCreationCubit extends Cubit<ArticleCreationState> {
  final CreateArticleUseCase createArticleUseCase;
  final UploadArticleImageUseCase uploadArticleImageUseCase;

  ArticleCreationCubit(
      this.createArticleUseCase, this.uploadArticleImageUseCase)
      : super(const ArticleCreationState());

  Future<void> submitArticle({
    required ArticleEntity article,
    String? imagePath,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    String? imageUrl = article.thumbnailURL;

    if (imagePath != null) {
      final imageResult = await uploadArticleImageUseCase(imagePath);
      final wasImageSuccessful = imageResult.fold(
        (error) {
          emit(
              state.copyWith(isLoading: false, errorMessage: error.toString()));
          return false;
        },
        (url) {
          imageUrl = url;
          return true;
        },
      );
      if (!wasImageSuccessful) return;
    }

    final finalArticle = article.copyWith(thumbnailURL: imageUrl);

    final articleResult = await createArticleUseCase(finalArticle);
    articleResult.fold(
      (error) => emit(
          state.copyWith(isLoading: false, errorMessage: error.toString())),
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }
}
