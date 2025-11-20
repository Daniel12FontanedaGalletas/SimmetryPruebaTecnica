import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Noticias Globales'),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/SavedArticles'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark, color: Colors.black, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  _buildPage(BuildContext context) {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildAppbar(context),
              body: const Center(child: CupertinoActivityIndicator()));
        }
        if (state is RemoteArticlesError) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildAppbar(context),
              body: const Center(child: Icon(Icons.refresh)));
        }
        if (state is RemoteArticlesDone) {
          return _buildArticlesPage(context, state.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesPage(
      BuildContext context, List<ArticleEntity> articles) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/header.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleWidget(
                  article: articles[index],
                  onArticlePressed: (article) => Navigator.pushNamed(
                      context, '/ArticleDetails',
                      arguments: article),
                  // 💡 LÓGICA DEL BOTÓN FAVORITO
                  onSave: (article) async {
                    try {
                      await GetIt.instance<SaveArticleUseCase>()(
                          params: article);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('✅ Guardado en Favoritos'),
                          backgroundColor: Colors.green));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('⚠️ Ya estaba guardado'),
                          backgroundColor: Colors.orange));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
