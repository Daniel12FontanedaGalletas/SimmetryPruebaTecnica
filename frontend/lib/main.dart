import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

import 'package:get_it/get_it.dart';
import 'injection_container.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:news_app_clean_architecture/presentation/pages/home_page.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCJ44zG3XTcUbuWMwTv38IHUkDIcJp-umU",
        appId: "1:227977661590:android:c581fe95dea8cc4e7f86b7",
        messagingSenderId: "227977661590",
        projectId: "symmetry-reporter-backend",
        storageBucket: "symmetry-reporter-backend.firebasestorage.app",
      ),
    );
    print("✅ Firebase inicializado correctamente.");
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
  }

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticlesBloc>(
      create: (context) => sl<RemoteArticlesBloc>()..add(const GetArticles()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: const HomePage(),
      ),
    );
  }
}
