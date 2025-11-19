// frontend/lib/config/routes/routes.dart

import 'package:flutter/material.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
// 💡 NUEVA IMPORTACIÓN: Tu página de creación de artículos
import '../../features/article_upload/presentation/pages/article_creation_page.dart';


class AppRoutes {
  // 💡 NUEVA RUTA ESTÁTICA
  static const String articleCreation = '/ArticleCreation'; 

  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(ArticleDetailsView(article: settings.arguments as ArticleEntity));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());
        
      // 💡 NUEVO CASO: Navegación a la página de creación
      case articleCreation:
        return _materialRoute(const ArticleCreationPage());
        
      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}