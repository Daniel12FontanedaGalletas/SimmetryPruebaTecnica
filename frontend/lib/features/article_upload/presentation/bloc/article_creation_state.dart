// frontend/lib/features/article_upload/presentation/bloc/article_creation_state.dart

import 'package:equatable/equatable.dart';

class ArticleCreationState extends Equatable {
  // Indica si se está realizando una operación (ej. subiendo el artículo).
  final bool isLoading;
  
  // Contiene un mensaje si ocurre un error.
  final String? errorMessage;
  
  // Indica si la operación de creación fue exitosa.
  final bool isSuccess;

  const ArticleCreationState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  // Método copyWith para generar nuevos estados inmutables.
  ArticleCreationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ArticleCreationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}