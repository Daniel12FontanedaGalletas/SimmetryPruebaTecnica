import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/pages/article_creation_page.dart';

// Imports necesarios para cruzar datos
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart'
    as daily;
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';

class MyArticlesPage extends StatelessWidget {
  const MyArticlesPage({Key? key}) : super(key: key);

  // 💡 NUEVA FUNCIÓN: Enviar al Bloc de Daily News
  void _sendToMain(BuildContext context, ArticleEntity firebaseArticle) {
    // Convertir Entidad Firebase -> Entidad Daily News
    final dailyArticle = daily.ArticleEntity(
      id: firebaseArticle.articleId.hashCode,
      author: firebaseArticle.authorName,
      title: firebaseArticle.title,
      description: firebaseArticle.content,
      urlToImage: firebaseArticle.thumbnailURL,
      publishedAt: firebaseArticle.datePublished.toIso8601String(),
      content: firebaseArticle.content,
    );

    // Disparar evento al Bloc Global
    context.read<RemoteArticlesBloc>().add(AddCustomArticle(dailyArticle));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('🚀 Enviado a la portada de Noticias Globales'),
          backgroundColor: Colors.blueAccent),
    );
  }

  void _deleteArticle(BuildContext context, String id) {
    // (Mismo código de borrado que tenías...)
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("¿Eliminar?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<MyArticlesCubit>().deleteArticle(id);
                    },
                    child:
                        const Text("Sí", style: TextStyle(color: Colors.red))),
              ],
            ));
  }

  void _editArticle(BuildContext context, ArticleEntity article) async {
    // (Mismo código de edición...)
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ArticleCreationPage(articleToEdit: article)));
    context.read<MyArticlesCubit>().loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:
            const Text("Mis Reportajes", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<MyArticlesCubit, MyArticlesState>(
        builder: (context, state) {
          if (state is MyArticlesLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is MyArticlesLoaded) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: article.thumbnailURL.isNotEmpty
                            ? Image.network(article.thumbnailURL,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.error))
                            : const Icon(Icons.article),
                        title: Text(article.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      OverflowBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          // 💡 BOTÓN MODIFICADO: "Guardar en Principal"
                          TextButton.icon(
                            icon: const Icon(Icons.send_to_mobile,
                                color: Colors.indigo),
                            label: const Text("Guardar en Principal"),
                            onPressed: () => _sendToMain(context, article),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editArticle(context, article),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteArticle(context, article.articleId),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
