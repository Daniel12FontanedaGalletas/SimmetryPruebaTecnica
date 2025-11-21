import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/upload_article_image_usecase.dart';
// [NUEVO IMPORT]
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'article_creation_state.dart';

class ArticleCreationCubit extends Cubit<ArticleCreationState> {
  final CreateArticleUseCase createArticleUseCase;
  final UploadArticleImageUseCase uploadArticleImageUseCase;
  // [NUEVA DEPENDENCIA]
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ArticleCreationCubit(
      this.createArticleUseCase,
      this.uploadArticleImageUseCase,
      this.getCurrentUserUseCase) // [MODIFICACIÓN]
      : super(const ArticleCreationState());

  Future<void> submitArticle({
    required ArticleEntity article,
    String? imagePath,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    // [NUEVA LÓGICA] Obtener el UID real del usuario autenticado
    final userResult = await getCurrentUserUseCase.call();
    String? userId;

    userResult.fold((l) => null, (user) => userId = user?.uid);

    if (userId == null) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: "Usuario no autenticado para publicar."));
      return;
    }

    String? imageUrl = article.thumbnailURL;

    if (imagePath != null) {
      // [MODIFICACIÓN] Pasamos el userId real al use case
      final imageResult = await uploadArticleImageUseCase(imagePath, userId!);
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

    // [MODIFICACIÓN] Aseguramos que el authorUID del artículo sea el UID real
    final finalArticle = article.copyWith(
      thumbnailURL: imageUrl,
      authorUID: userId,
    );

    final articleResult = await createArticleUseCase(finalArticle);
    articleResult.fold(
      (error) => emit(
          state.copyWith(isLoading: false, errorMessage: error.toString())),
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }
}
