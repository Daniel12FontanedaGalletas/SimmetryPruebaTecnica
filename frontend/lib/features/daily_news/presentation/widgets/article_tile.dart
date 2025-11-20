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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          border: Border.all(color: Colors.black.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(4),
          image: const DecorationImage(
            image: AssetImage(
                'assets/film_strip_border.png'), // Asegúrate de tener esta imagen
            fit: BoxFit.fill,
            repeat: ImageRepeat.noRepeat,
          ),
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
    return Container(
      width: MediaQuery.of(context).size.width / 3.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/film_strip_single.png'), // Y esta
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: ClipRRect(
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
                  child: CupertinoActivityIndicator(color: Colors.white)),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "D. ROLLEI VOLENS",
              style: TextStyle(fontSize: 8, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              (article!.title ?? '').toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily:
                    'Butler', // O una fuente más condensada y en negrita
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Expanded(
              child: Text(
                article!.description ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFFC7C7C7)),
              ),
            ),
            const SizedBox(height: 8),
            // Save Button
            if (!isRemovable && onSave != null)
              GestureDetector(
                onTap: () => onSave!(article!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.bookmark_border,
                        color: Color(0xFF4A90E2), size: 28),
                    const SizedBox(width: 4),
                    Text(
                      "GUARDAR EN\nFAVORITOS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF4A90E2),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
    // This is now handled inside _buildTitleAndDescription to match the layout.
    return Container();
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
