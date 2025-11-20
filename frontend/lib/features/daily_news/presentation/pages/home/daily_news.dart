import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<ArticleEntity> _filteredArticles = [];
  String? _selectedCategory;

  final List<String> _categories = [
    'general',
    'business',
    'technology',
    'entertainment',
    'sports',
    'science',
    'health'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final articles =
        (context.read<RemoteArticlesBloc>().state as RemoteArticlesDone)
            .articles!;
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredArticles = articles.where((article) {
        return article.title?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Buscar artículo...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: _isSearching
          ? _buildSearchField()
          : const Text(
              'Symmetry News',
              style: TextStyle(
                  fontFamily: 'Butler',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search,
              color: Colors.black, size: 30),
          onPressed: _toggleSearch,
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/SavedArticles'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: const Icon(Icons.bookmark, color: Colors.black, size: 30),
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
          if (_filteredArticles.isEmpty && _searchController.text.isEmpty) {
            _filteredArticles = state.articles!;
          }
          return _buildArticlesPage(
              context, _isSearching ? _filteredArticles : state.articles!);
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
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<RemoteArticlesBloc>()
              .add(GetArticles(category: _selectedCategory));
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCategoryDropdown(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/header2.png',
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
                    onRemove: (article) {
                      setState(() {
                        articles.remove(article);
                        _filteredArticles.remove(article);
                      });
                    },
                    // 💡 LÓGICA DEL BOTÓN FAVORITO
                    onSave: (article) async {
                      try {
                        await GetIt.instance<SaveArticleUseCase>()(
                            params: article);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✅ Guardado en Favoritos'),
                                backgroundColor: Colors.green));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _selectedCategory,
        hint: const Text('TODAS LAS CATEGORÍAS'),
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('TODAS'),
          ),
          ..._categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toUpperCase()),
            );
          }).toList(),
        ],
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
          context
              .read<RemoteArticlesBloc>()
              .add(GetArticles(category: newValue));
        },
      ),
    );
  }
}
