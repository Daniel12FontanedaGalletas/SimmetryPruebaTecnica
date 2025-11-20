import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/pages/my_articles_page.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/pages/article_creation_page.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // Controlamos el Cubit aquí para refrescar la lista cuando se vuelve de crear
  final MyArticlesCubit _myArticlesCubit = GetIt.instance<MyArticlesCubit>();

  @override
  void initState() {
    super.initState();
    _myArticlesCubit.loadArticles();
  }

  @override
  void dispose() {
    _myArticlesCubit.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      // Pestaña 0: Noticias Externas
      const DailyNews(),

      // Pestaña 1: Tus Reportajes (Con Cubit inyectado)
      BlocProvider.value(
        value: _myArticlesCubit,
        child: const MyArticlesPage(),
      ),
    ];

    return Scaffold(
      backgroundColor:
          const Color(0xFFFDF5E6), // Color crema estilo papel antiguo
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFDF5E6),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_outlined),
            activeIcon: Icon(Icons.movie_filter),
            label: 'Noticias Globales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none),
            activeIcon: Icon(Icons.mic),
            label: 'Mis Reportajes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      // El botón flotante solo aparece en tu pestaña
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ArticleCreationPage(articleToEdit: null)),
                );
                // Refrescar la lista al volver de crear
                _myArticlesCubit.loadArticles();
              },
              label: const Text("Redactar"),
              icon: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
