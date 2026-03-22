import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import '../../auth/domain/auth_provider.dart';
import '../domain/monuments_provider.dart';
import 'widgets/crowd_trends_chart.dart';
import 'monument_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monumentOfTheDay = ref.watch(monumentOfTheDayProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const SizedBox(height: 24),
              _buildSearchBar(ref),
              const SizedBox(height: 24),
              
              ref.watch(searchQueryProvider).isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Monument of the Day
                      monumentOfTheDay.when(
                        data: (monument) => _buildMonumentOfTheDay(context, monument),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('Error: $err', style: const TextStyle(color: AppColors.error)),
                      ),
                      const SizedBox(height: 16),
                      // Bento Grid Row 1
                      Row(
                        children: [
                          Expanded(child: _buildAqiAlertCard()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPassportCard(context)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bento Grid Row 2
                      _buildCrowdTrendsCard(),
                    ],
                  )
                : _buildSearchResults(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Est. 2024 • Digital Preservation',
              style: TextStyle(
                color: AppColors.tertiary,
                fontSize: 10,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The Archivists',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => ref.read(authProvider.notifier).logout(),
          icon: const Icon(Icons.logout, color: AppColors.onSurface),
        ),
      ],
    );
  }

  Widget _buildMonumentOfTheDay(BuildContext context, dynamic monument) {
    final title = monument?.name ?? 'Discover Heritage';
    final desc = monument?.shortDescription ?? 'Explore the timeless monuments of India.';
    
    return GestureDetector(
      onTap: () {
        if (monument != null) {
          context.push('/monument', extra: monument);
        }
      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.primaryContainer,
          image: DecorationImage(
            image: const NetworkImage('https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=1000&auto=format&fit=crop'), // Placeholder for Taj Mahal
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: GlassmorphicCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MONUMENT OF THE DAY',
                style: TextStyle(color: AppColors.tertiary, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(color: AppColors.onSurface, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAqiAlertCard() {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.air, color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Text('Live AQI', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('142', style: TextStyle(color: AppColors.onSurface, fontSize: 36, fontWeight: FontWeight.bold)),
          const Text('Moderate', style: TextStyle(color: AppColors.secondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPassportCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/passport'),
      child: GlassmorphicCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.book, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('Passport', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('3/43', style: TextStyle(color: AppColors.onSurface, fontSize: 36, fontWeight: FontWeight.bold)),
            const Text('Stamps Earned', style: TextStyle(color: AppColors.primary, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCrowdTrendsCard() {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: AppColors.tertiary, size: 20),
              SizedBox(width: 8),
              Text('Crowd Trends', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 100,
            child: CrowdTrendsChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return TextField(
      onChanged: (val) => ref.read(searchQueryProvider.notifier).updateQuery(val),
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: 'Search for heritage sites...',
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.primaryContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSearchResults(WidgetRef ref) {
    final filtered = ref.watch(filteredMonumentsProvider);
    return filtered.when(
      data: (monuments) {
        if (monuments.isEmpty) {
          return const Center(
            child: Text('No monuments found.', style: TextStyle(color: AppColors.onSurfaceVariant)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: monuments.length,
          itemBuilder: (context, index) {
            final m = monuments[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      m.imageUrl ?? 'https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=200&auto=format&fit=crop',
                      width: 60, height: 60, fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(m.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                  subtitle: Text(m.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  onTap: () => context.push('/monument', extra: m),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e', style: const TextStyle(color: AppColors.error)),
    );
  }
}
