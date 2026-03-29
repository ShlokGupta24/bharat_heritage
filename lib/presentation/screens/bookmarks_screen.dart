import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../features/bookmarks/domain/bookmark_provider.dart';
import '../../features/monuments/domain/monuments_provider.dart';
import '../../features/monuments/data/models/monument.dart';
import '../../features/monuments/data/models/wikipedia_image_widget.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkProvider);
    final monumentsAsync = ref.watch(monumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Ambient glow decorations
          Positioned(
            top: 100, right: -60,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withAlpha(40),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 200, left: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer.withAlpha(40),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Saved Monuments',
                        style: GoogleFonts.notoSerif(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'YOUR HERITAGE COLLECTION',
                    style: GoogleFonts.manrope(
                      color: AppColors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // List
                Expanded(
                  child: bookmarksAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.tertiary),
                    ),
                    error: (e, _) => Center(
                      child: Text('Error loading bookmarks', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                    ),
                    data: (bookmarkedIds) {
                      if (bookmarkedIds.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return monumentsAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.tertiary)),
                        error: (e, _) => Center(
                          child: Text('Error loading monuments', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                        ),
                        data: (monuments) {
                          final bookmarked = monuments.where((m) => bookmarkedIds.contains(m.id)).toList();
                          if (bookmarked.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: bookmarked.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return _buildMonumentCard(context, ref, bookmarked[index]);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.tertiary.withAlpha(80)),
              ),
              child: const Icon(Icons.bookmark_border, color: AppColors.tertiary, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'No Bookmarks Yet',
              style: GoogleFonts.notoSerif(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visit a heritage site and tap the bookmark icon to save it to your collection.',
              style: GoogleFonts.manrope(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => context.go('/'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'EXPLORE HERITAGE SITES',
                  style: GoogleFonts.manrope(
                    color: AppColors.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonumentCard(BuildContext context, WidgetRef ref, Monument monument) {
    return GestureDetector(
      onTap: () => context.push('/monument/${monument.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(13)),
        ),
        child: Row(
          children: [
            // Monument image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64, height: 64,
                child: monument.imageUrl != null && monument.imageUrl!.isNotEmpty
                    ? Image.network(
                        monument.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => WikipediaImageCard(monumentName: monument.name),
                      )
                    : WikipediaImageCard(monumentName: monument.name),
              ),
            ),
            const SizedBox(width: 12),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monument.name,
                    style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    monument.shortDescription,
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer.withAlpha(180),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'UNESCO SITE',
                          style: GoogleFonts.manrope(
                            color: AppColors.tertiary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Est. ${monument.dateInscribed}',
                        style: GoogleFonts.manrope(
                          color: AppColors.outline,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark remove button
            GestureDetector(
              onTap: () => ref.read(bookmarkProvider.notifier).toggleBookmark(monument.id),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.bookmark, color: AppColors.tertiary, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
