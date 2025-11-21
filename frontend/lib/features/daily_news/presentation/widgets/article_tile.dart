import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;
  final void Function(ArticleEntity article)? onSave;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
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
          color: const Color(0xFFF5F5DC),
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
                Text(
                  article!.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isRemovable &&
                    (article?.url ?? '').contains('symmetry-reporter.com') &&
                    onRemove != null)
                  Flexible(
                    child: GestureDetector(
                      onTap: () => onRemove!(article!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.delete_outline,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                "ELIMINAR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!isRemovable &&
                    (article?.url ?? '').contains('symmetry-reporter.com') &&
                    onRemove != null &&
                    onSave != null)
                  const SizedBox(width: 8.0),
                if (!isRemovable && onSave != null)
                  Flexible(
                    child: GestureDetector(
                      onTap: () => onSave!(article!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bookmark_border,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                "GUARDAR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (isRemovable)
                  GestureDetector(
                    onTap: () {
                      if (onRemove != null) {
                        onRemove!(article!);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.remove_circle_outline, color: Colors.red),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed!(article!);
    }
  }
}
