import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Daily News
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart'
    as daily_news_repo;
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

// Article Upload
import 'package:news_app_clean_architecture/features/article_upload/data/datasources/firebase_article_datasource.dart';
import 'package:news_app_clean_architecture/features/article_upload/data/repositories/article_repository_impl.dart'
    as upload_repo_impl;
import 'package:news_app_clean_architecture/features/article_upload/domain/repositories/article_repository.dart'
    as upload_repo;
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/get_uploaded_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/usecases/delete_article_usecase.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/article_creation_cubit.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles_cubit.dart';

// Auth
import 'package:news_app_clean_architecture/features/auth/data/datasources/auth_datasource.dart';
import 'package:news_app_clean_architecture/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:news_app_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as auth_repo;
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton<NewsApiService>(() => NewsApiService(sl()));

  sl.registerLazySingleton<AuthDatasource>(() => FirebaseAuthDatasource(sl()));
  sl.registerLazySingleton<auth_repo.AuthRepository>(
      () => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInAnonymouslyUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
        getCurrentUserUseCase: sl(),
        signInAnonymouslyUseCase: sl(),
        signOutUseCase: sl(),
      ));

  sl.registerLazySingleton<FirebaseArticleDatasource>(
    () => FirebaseArticleDatasource(
      firestore: sl(),
      storage: sl(),
      auth: sl(),
    ),
  );
  sl.registerLazySingleton<upload_repo.ArticleRepository>(
    () => upload_repo_impl.ArticleRepositoryImpl(datasource: sl()),
  );
  sl.registerLazySingleton(() => CreateArticleUseCase(sl()));
  sl.registerLazySingleton(() => UploadArticleImageUseCase(sl()));
  sl.registerLazySingleton(() => GetUploadedArticlesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteArticleUseCase(sl()));
  sl.registerFactory(() => ArticleCreationCubit(sl(), sl(), sl()));
  sl.registerFactory(() => MyArticlesCubit(sl(), sl()));

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  sl.registerLazySingleton<ArticleRepository>(
      () => daily_news_repo.ArticleRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton(() => GetArticleUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedArticleUseCase(sl()));
  sl.registerLazySingleton(() => SaveArticleUseCase(sl()));
  sl.registerLazySingleton(() => RemoveArticleUseCase(sl()));

  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(
      () => LocalArticleBloc(sl(), sl(), sl()));
}
