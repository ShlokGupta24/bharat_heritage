import 'package:flutter/material.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Digital Passport', style: TextStyle(fontFamily: 'Noto Serif')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Curated Journey',
                    style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '3 of 43 Unlocked',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  _buildStampGrid(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStampGrid() {
    // Dummy Data
    final stamps = [
      {'name': 'Taj Mahal', 'locked': false},
      {'name': 'Qutb Minar', 'locked': false},
      {'name': 'Sun Temple', 'locked': false},
      {'name': 'Red Fort', 'locked': true},
      {'name': 'Ajanta Caves', 'locked': true},
      {'name': 'Ellora Caves', 'locked': true},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: stamps.length,
      itemBuilder: (context, index) {
        final stamp = stamps[index];
        final isLocked = stamp['locked'] as bool;
        return GlassmorphicCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLocked ? Icons.lock_outline : Icons.verified,
                color: isLocked ? AppColors.outlineVariant : AppColors.tertiary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                stamp['name'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isLocked ? AppColors.onSurfaceVariant : AppColors.onSurface,
                  fontWeight: isLocked ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
