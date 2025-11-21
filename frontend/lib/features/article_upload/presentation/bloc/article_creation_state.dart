import 'package:equatable/equatable.dart';

class ArticleCreationState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ArticleCreationState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

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
