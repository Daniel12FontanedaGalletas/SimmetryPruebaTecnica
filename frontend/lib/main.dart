import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

// [CORRECCIÓN] Importar el service locator.
import 'injection_container.dart';

// [NUEVOS IMPORTS PARA AUTH]
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'package:news_app_clean_architecture/presentation/pages/home_page.dart';

// Importa el archivo de opciones generado por FlutterFire
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // [CORRECCIÓN DE INICIALIZACIÓN] Usar DefaultFirebaseOptions para todas las plataformas
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase inicializado correctamente.");
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
  }

  // [CORRECCIÓN] Llamar a la función `initializeDependencies()` y esperar a que termine.
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) =>
              sl<RemoteArticlesBloc>()..add(const GetArticles()),
        ),
        // [MODIFICACIÓN] Proveer AuthBloc
        BlocProvider<AuthBloc>(
          // Inicializar lanzando el evento de inicio de sesión anónimo.
          // Si el usuario ya existe, esto lo autentica. Si no, lo crea.
          create: (context) => sl<AuthBloc>()..add(SignInAnonymously()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        // [MODIFICACIÓN] Controlar la vista principal según el estado de AuthBloc
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const HomePage();
            }
            if (state is Unauthenticated || state is AuthFailure) {
              // Muestra la LoginPage, donde el usuario puede reintentar si el error es transitorio
              return const LoginPage();
            }
            return const Scaffold(
                body: Center(child: CircularProgressIndicator())); // Loading
          },
        ),
      ),
    );
  }
}
