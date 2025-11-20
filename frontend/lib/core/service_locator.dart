import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:news_app_clean_architecture/features/article_upload/data/datasources/firebase_article_datasource.dart';
import 'package:news_app_clean_architecture/features/article_upload/data/repositories/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/get_uploaded_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/delete_article_usecase.dart';

import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/article_creation_cubit.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles_cubit.dart';

final GetIt sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerLazySingleton<FirebaseArticleDatasource>(
    () => FirebaseArticleDatasource(
      firestore: sl(),
      storage: sl(),
    ),
  );

  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(datasource: sl()),
  );

  sl.registerLazySingleton(() => CreateArticleUseCase(sl()));
  sl.registerLazySingleton(() => UploadArticleImageUseCase(sl()));
  sl.registerLazySingleton(() => GetUploadedArticlesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteArticleUseCase(sl()));

  sl.registerFactory(() => ArticleCreationCubit(sl(), sl()));

  sl.registerFactory(() => MyArticlesCubit(sl(), sl()));
}
