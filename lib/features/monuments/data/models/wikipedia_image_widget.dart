import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'wikipedia_image_provider.dart';

/// Fetches a Wikipedia thumbnail for [monumentName] and displays it.
/// Shows [placeholder] while loading, [fallbackAsset] if everything fails.
class WikipediaImage extends ConsumerWidget {
  final String monumentName;
  final BoxFit fit;
  final String fallbackAsset;
  final Widget? placeholder;

  const WikipediaImage({
    super.key,
    required this.monumentName,
    this.fit = BoxFit.cover,
    this.fallbackAsset = 'design/tajmahal.avif',
    this.placeholder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(wikipediaImageProvider(monumentName));

    return imageAsync.when(
      loading: () =>
      placeholder ??
          Container(
            color: AppColors.surfaceContainerLow,
            child: const Center(child: CircularProgressIndicator()),
          ),
      error: (_, __) => Image.asset(fallbackAsset, fit: fit),
      data: (url) {
        if (url == null || url.isEmpty) {
          return Image.asset(fallbackAsset, fit: fit);
        }
        return Image.network(
          url,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ??
                Container(
                  color: AppColors.surfaceContainerLow,
                  child: const Center(child: CircularProgressIndicator()),
                );
          },
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(fallbackAsset, fit: fit),
        );
      },
    );
  }
}

/// Compact variant used in cards — shows a grey box while loading (no spinner)
class WikipediaImageCard extends ConsumerWidget {
  final String monumentName;
  final BoxFit fit;

  const WikipediaImageCard({
    super.key,
    required this.monumentName,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(wikipediaImageProvider(monumentName));

    return imageAsync.when(
      loading: () => Container(color: AppColors.surfaceContainerHigh),
      error: (_, __) => Container(
        color: AppColors.surfaceContainerHigh,
        child: const Icon(Icons.image_not_supported, color: AppColors.onSurfaceVariant),
      ),
      data: (url) {
        if (url == null || url.isEmpty) {
          return Container(
            color: AppColors.surfaceContainerHigh,
            child: const Icon(Icons.landscape, color: AppColors.tertiary, size: 24),
          );
        }
        return Image.network(
          url,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(color: AppColors.surfaceContainerHigh);
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.surfaceContainerHigh,
            child: const Icon(Icons.image_not_supported, color: AppColors.onSurfaceVariant),
          ),
        );
      },
    );
  }
}