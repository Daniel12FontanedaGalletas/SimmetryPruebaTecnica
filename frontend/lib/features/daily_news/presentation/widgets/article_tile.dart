import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// 💡 CORRECCIÓN: Ruta absoluta
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  // 💡 CORRECCIÓN: Quitamos el '?' para que no sea nullable
  final bool isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;
  final void Function(ArticleEntity article)? onSave;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false, // Valor por defecto
    this.onRemove,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC), // Beige
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(context),
              _buildTitleAndDescription(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: CachedNetworkImage(
          imageUrl: article!.urlToImage ?? '',
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const Center(
                  child: CupertinoActivityIndicator(color: Colors.black)),
          errorWidget: (context, url, error) => Container(
            color: Colors.black.withOpacity(0.1),
            child: const Icon(Icons.image_not_supported, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  (article!.title ?? '').toUpperCase(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Butler',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  article!.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Save Button
            if (!isRemovable && onSave != null)
              GestureDetector(
                onTap: () => onSave!(article!),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border,
                          color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "GUARDAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isRemovable)
              GestureDetector(
                onTap: _onRemove,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.remove_circle_outline, color: Colors.red),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea() {
    return GestureDetector(
      onTap: _onRemove,
      child: const Icon(Icons.remove_circle_outline, color: Colors.red),
    );
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed!(article!);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove!(article!);
    }
  }
}
