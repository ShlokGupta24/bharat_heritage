import 'package:flutter/material.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument.dart';
import 'package:go_router/go_router.dart';
class MonumentDetailScreen extends StatelessWidget {
  final Monument monument;

  const MonumentDetailScreen({super.key, required this.monument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Hero Image
          Positioned.fill(
            child: Image.network(
              monument.imageUrl ?? 'https://images.unsplash.com/photo-1589136777351-fdc9c9cb164f?q=80&w=1000&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.0), AppColors.surface.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GlassmorphicCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monument.dateInscribed ?? '1983',
                          style: const TextStyle(color: AppColors.tertiary, fontSize: 12, letterSpacing: 2.0),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          monument.name,
                          style: const TextStyle(color: AppColors.onSurface, fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          monument.shortDescription,
                          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.5),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.location_on),
                          label: const Text('UNLOCK STAMP HERE'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
