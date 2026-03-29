import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument.dart';
import 'package:bharat_heritage/features/auth/domain/user_provider.dart';
import 'package:bharat_heritage/features/passport/domain/passport_provider.dart';
import 'package:bharat_heritage/features/passport/data/models/passport_model.dart';

class PassportScreen extends ConsumerStatefulWidget {
  const PassportScreen({super.key});

  @override
  ConsumerState<PassportScreen> createState() => _PassportScreenState();
}

class _PassportScreenState extends ConsumerState<PassportScreen> {
  bool _awarding = false;
  String _selectedRegion = 'All';

  String _getRegion(Coordinates coords) {
    final lat = coords.lat;
    final lon = coords.lon;
    if (lon > 85) return 'East';
    if (lat > 25.5) return 'North';
    if (lat < 18) return 'South';
    if (lon < 76) return 'West';
    return 'Central';
  }

  /// GPS check-in: invalidate stale position first, then try to award stamp.
  Future<void> _tryCheckIn() async {
    if (_awarding) return;
    setState(() => _awarding = true);
    try {
      // Force a fresh GPS fix every time — crucial fix for the stale cache issue.
      ref.invalidate(currentPositionProvider);
      ref.invalidate(nearbyMonumentProvider);

      // Small delay to let the providers start rebuilding before we read them.
      await Future.delayed(const Duration(milliseconds: 200));

      final awardedName = await ref.read(tryAwardStampProvider.future);
      if (!mounted) return;

      if (awardedName != null) {
        _showToast('🎉  Stamp awarded for $awardedName!', success: true);
        ref.invalidate(passportEntriesProvider);
        ref.invalidate(userPassportProvider);
        ref.invalidate(visitedMonumentIdsProvider);
      } else {
        _showToast('No UNESCO site found within 500 m of your location.');
      }
    } catch (e) {
      if (mounted) _showToast('Check-in failed: $e');
    } finally {
      if (mounted) setState(() => _awarding = false);
    }
  }

  void _showToast(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
        backgroundColor:
            success ? AppColors.tertiaryContainer : AppColors.surfaceContainerHigh,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────── BUILD ──────
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final passportAsync = ref.watch(userPassportProvider);
    final monumentsAsync = ref.watch(monumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    // ── Hero ──
                    passportAsync.when(
                      data: (p) => _buildHeroSection(p,
                          userAsync.value?.displayName ?? userAsync.value?.email),
                      loading: () => _buildHeroSkeleton(),
                      error: (e, _) => _buildHeroSection(
                          UserPassport(visits: const [], totalMonuments: 43), null),
                    ),
                    const SizedBox(height: 32),
                    // ── Achievements ──
                    _buildAchievementsSection(passportAsync.value),
                    const SizedBox(height: 32),
                    // ── Stamps ──
                    _buildStampsHeader(),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              // Stamps grid as a proper SliverGrid — fixes RenderFlex errors
              monumentsAsync.when(
                data: (monuments) {
                  final visitedIds = passportAsync.value?.visitedIds ?? {};
                  
                  // Filter monuments by selected region
                  final filteredMonuments = _selectedRegion == 'All' 
                      ? monuments 
                      : monuments.where((m) => _getRegion(m.coordinates) == _selectedRegion).toList();

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final m = filteredMonuments[index];
                          final isUnlocked = visitedIds.contains(m.id);
                          return _buildStamp(m, isUnlocked, index);
                        },
                        childCount: filteredMonuments.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: CircularProgressIndicator(color: AppColors.tertiary),
                    ),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Text('Failed to load stamps\n$e',
                        style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildLogEntrySection(passportAsync.value),
                  ]),
                ),
              ),
            ],
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────── APP BAR ───────
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface.withAlpha(204),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('design/screen.png', height: 26),
          const SizedBox(width: 10),
          Text('BharatHeritage',
              style: GoogleFonts.notoSerif(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5)),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.bookmark_border,
                color: AppColors.onSurfaceVariant),
            onPressed: () => context.push('/bookmarks')),
        const SizedBox(width: 8),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────── HERO ────────
  Widget _buildHeroSection(UserPassport passport, String? userName) {
    final docNo = 'BH-${passport.visitedCount.toString().padLeft(4, '0')}-2024';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('DOCUMENT NO. $docNo',
                    style: GoogleFonts.manrope(
                        color: AppColors.tertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0),
                    overflow: TextOverflow.ellipsis),
              ),
              if (userName != null) ...[
                const SizedBox(width: 12),
                Text(
                  userName.length > 20
                      ? '${userName.substring(0, 18)}…'
                      : userName.toUpperCase(),
                  style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text('Digital Passport',
              style: GoogleFonts.notoSerif(
                  color: AppColors.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1)),
          const SizedBox(height: 10),
          Text(
              'Your curated archive of journeys across the Indian subcontinent. '
              'Every site visited is a fragment of history preserved.',
              style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.5)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('JOURNEY PROGRESS',
                  style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0)),
              Text('${passport.progressPercent}%',
                  style: GoogleFonts.notoSerif(
                      color: AppColors.tertiary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: passport.progressFraction,
                backgroundColor: AppColors.surfaceContainerHighest,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.tertiary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                '${passport.visitedCount} OF ${passport.totalMonuments} SITES UNLOCKED',
                style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant.withAlpha(153),
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSkeleton() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24)),
      child:
          const Center(child: CircularProgressIndicator(color: AppColors.tertiary)),
    );
  }

  // ──────────────────────────────────────────────── ACHIEVEMENTS ───────────────
  Widget _buildAchievementsSection(UserPassport? passport) {
    final visited = passport?.visitedCount ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Achievement Badges',
                style: GoogleFonts.notoSerif(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => _showAllBadgesBottomSheet(visited),
              child: Row(
                children: [
                  Text('VIEW ALL',
                      style: GoogleFonts.manrope(
                          color: AppColors.tertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5)),
                  const Icon(Icons.arrow_forward, color: AppColors.tertiary, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Wrap in LayoutBuilder so we can adapt to narrow screens
        LayoutBuilder(builder: (context, constraints) {
          // Each mini-badge needs ~90px minimum; large card needs ~160px.
          // Total = 160 + 12 + 90 + 12 + 90 = ~364px. Fine for most phones.
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBadgeCard(
                    icon: Icons.workspace_premium,
                    color: AppColors.tertiary,
                    title: 'Mughal Explorer',
                    subtitle: 'Visit your first heritage site',
                    unlocked: visited >= 1,
                    progress: '${min(visited, 1)}/1',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniBadge(
                    icon: Icons.temple_hindu,
                    color: AppColors.secondary,
                    title: 'Temple Trailblazer',
                    unlocked: visited >= 3,
                    label: visited >= 3 ? 'UNLOCKED' : '${min(visited, 3)}/3',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniBadge(
                    icon: Icons.fort,
                    color: AppColors.primary,
                    title: 'Fort Sentinel',
                    unlocked: visited >= 10,
                    label: visited >= 10 ? 'UNLOCKED' : '${min(visited, 10)}/10',
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBadgeCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool unlocked,
    required String progress,
  }) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (unlocked ? color : Colors.white).withAlpha(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.notoSerif(
                    color: unlocked ? AppColors.onSurface : AppColors.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant, fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Text(progress,
                style: GoogleFonts.manrope(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required Color color,
    required String title,
    required bool unlocked,
    required String label,
  }) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.45,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (unlocked ? color : Colors.white).withAlpha(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant),
                color: color.withAlpha(30),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: GoogleFonts.notoSerif(
                    color: unlocked ? AppColors.onSurface : AppColors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.manrope(
                    color: unlocked
                        ? color
                        : AppColors.onSurfaceVariant.withAlpha(128),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showAllBadgesBottomSheet(int visited) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white.withAlpha(26)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text('All Achievement Badges',
                  style: GoogleFonts.notoSerif(
                      color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Earn badges by visiting UNESCO World Heritage Sites across India.',
                  style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildFullWidthBadgeCard(
                      icon: Icons.workspace_premium,
                      color: AppColors.tertiary,
                      title: 'Mughal Explorer',
                      subtitle: 'Visit your first heritage site',
                      unlocked: visited >= 1,
                      progress: '${min(visited, 1)}/1',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.temple_hindu,
                      color: AppColors.secondary,
                      title: 'Temple Trailblazer',
                      subtitle: 'Uncover 3 heritage sites',
                      unlocked: visited >= 3,
                      progress: '${min(visited, 3)}/3',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.fort,
                      color: AppColors.primary,
                      title: 'Fort Sentinel',
                      subtitle: 'Stand guard at 10 sites',
                      unlocked: visited >= 10,
                      progress: '${min(visited, 10)}/10',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.school,
                      color: Colors.tealAccent,
                      title: 'Heritage Scholar',
                      subtitle: 'Deep dive into 20 sites',
                      unlocked: visited >= 20,
                      progress: '${min(visited, 20)}/20',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.explore,
                      color: Colors.pinkAccent,
                      title: 'Master Explorer',
                      subtitle: 'Navigate to 30 sites',
                      unlocked: visited >= 30,
                      progress: '${min(visited, 30)}/30',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.landscape,
                      color: Colors.amberAccent,
                      title: 'Grand Adventurer',
                      subtitle: 'Journey across 40 sites',
                      unlocked: visited >= 40,
                      progress: '${min(visited, 40)}/40',
                    ),
                    const SizedBox(height: 12),
                    _buildFullWidthBadgeCard(
                      icon: Icons.local_library,
                      color: Colors.purpleAccent,
                      title: 'Ultimate Historian',
                      subtitle: 'Visit all 43 UNESCO sites',
                      unlocked: visited >= 43,
                      progress: '${min(visited, 43)}/43',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFullWidthBadgeCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool unlocked,
    required String progress,
  }) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (unlocked ? color : Colors.white).withAlpha(20)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: color.withAlpha(26), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.notoSerif(
                          color: unlocked ? AppColors.onSurface : AppColors.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(progress,
                  style: GoogleFonts.manrope(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────── STAMPS SECTION HEADER ──────
  Widget _buildStampsHeader() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.white.withAlpha(26)))),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Site Stamps Journal',
              style: GoogleFonts.notoSerif(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          PopupMenuButton<String>(
            initialValue: _selectedRegion,
            onSelected: (value) {
              setState(() {
                _selectedRegion = value;
              });
            },
            color: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            itemBuilder: (context) => [
              'All',
              'North',
              'South',
              'East',
              'West',
              'Central'
            ].map((region) => PopupMenuItem(
              value: region,
              child: Text(region, style: GoogleFonts.manrope(
                color: _selectedRegion == region ? AppColors.tertiary : AppColors.onSurface,
                fontWeight: _selectedRegion == region ? FontWeight.bold : FontWeight.w500,
              )),
            )).toList(),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  const Icon(Icons.filter_list,
                      color: AppColors.onSurface, size: 14),
                  const SizedBox(width: 6),
                  Text(_selectedRegion.toUpperCase(),
                      style: GoogleFonts.manrope(
                          color: AppColors.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────── STAMP CARD ────
  Widget _buildStamp(Monument monument, bool isUnlocked, int index) {
    if (!isUnlocked) {
      return _StampTile(
        topChild: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(100)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: AppColors.outline, size: 26),
                const SizedBox(height: 4),
                Text('VISIT TO\nUNLOCK',
                    style: GoogleFonts.manrope(
                        color: AppColors.outline,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        label: monument.name,
        labelColor: AppColors.onSurfaceVariant.withAlpha(100),
      );
    }

    const stampColors = [
      AppColors.tertiary,
      AppColors.secondary,
      AppColors.primary,
      AppColors.onSurfaceVariant,
    ];
    const stampIcons = [
      Icons.account_balance,
      Icons.foundation,
      Icons.landscape,
      Icons.sunny,
      Icons.temple_hindu,
      Icons.fort,
      Icons.museum,
      Icons.castle,
    ];
    final color = stampColors[index % stampColors.length];
    final icon = stampIcons[index % stampIcons.length];
    const rotationAngles = [-0.18, 0.12, -0.05, 0.19, -0.1, 0.07];
    final angle = rotationAngles[index % rotationAngles.length];
    final shortName = monument.name.split(' ').first.toUpperCase();

    return GestureDetector(
      onTap: () => context.push('/monument/${monument.id}'),
      child: _StampTile(
        topChild: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha(40)),
            boxShadow: [
              BoxShadow(
                  color: color.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Transform.rotate(
            angle: angle,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withAlpha(60), width: 2),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                Positioned(
                  bottom: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    color: AppColors.surface,
                    child: Text(shortName,
                        style: GoogleFonts.manrope(
                            color: color,
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8)),
                  ),
                ),
              ],
            ),
          ),
        ),
        label: monument.name,
        labelColor: AppColors.onSurfaceVariant,
      ),
    );
  }

  // ──────────────────────────────────────────────────────── LOG SECTION ────────
  Widget _buildLogEntrySection(UserPassport? passport) {
    final latest = passport?.latestEntry;
    final dateStr = latest != null
        ? DateFormat('MMMM dd, yyyy').format(latest.visitedAt).toUpperCase()
        : '--';
    final siteName = latest?.monumentName ?? 'No visits yet';

    return Column(
      children: [
        // Latest entry card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withAlpha(128),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(26)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.edit_note,
                        color: AppColors.tertiary, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latest Entry: $siteName',
                            style: GoogleFonts.notoSerif(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(dateStr,
                            style: GoogleFonts.manrope(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                latest != null
                    ? 'You visited $siteName and earned your passport stamp. '
                        'Your journey through India\'s UNESCO World Heritage Sites continues.'
                    : 'You haven\'t visited any UNESCO heritage site yet. '
                        'Travel to one, physically arrive, then tap "CHECK IN VIA GPS" to earn your first stamp!',
                style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.6),
              ),
              if (latest != null) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [_tag('#UNESCO'), _tag('#HERITAGE'), _tag('#INDIA')],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Check-in card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withAlpha(40),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primaryContainer.withAlpha(70)),
          ),
          child: Column(
            children: [
              Icon(
                _awarding ? Icons.gps_fixed : Icons.location_on,
                color: AppColors.tertiary,
                size: 48,
              ),
              const SizedBox(height: 14),
              Text('Check In at a Heritage Site',
                  style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                  'Physically arrive at a UNESCO World Heritage Site, then tap the button below. '
                  'Your GPS will be checked — if you\'re within 500 m, you\'ll earn a stamp automatically.',
                  style:
                      GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12),
                  textAlign: TextAlign.center),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _awarding ? null : _tryCheckIn,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _awarding
                          ? [
                              AppColors.surfaceContainerHigh,
                              AppColors.surfaceContainerHighest
                            ]
                          : [AppColors.primary, AppColors.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: _awarding
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text('CHECK IN VIA GPS',
                            style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: GoogleFonts.manrope(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }

  // ────────────────────────────────────────────────────────── BOTTOM NAV ───────
  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface.withAlpha(153),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withAlpha(26)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go('/'),
                    child: _navItem(Icons.home, 'Home', false)),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go('/map'),
                    child: _navItem(Icons.map, 'Map', false)),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: _navItem(Icons.auto_stories, 'Passport', true)),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go('/profile'),
                    child: _navItem(Icons.person, 'Profile', false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant, size: 24),
        const SizedBox(height: 4),
        Text(label.toUpperCase(),
            style: GoogleFonts.manrope(color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant,
                fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────── STAMP TILE ───────
/// Separate widget so the grid cell has a clean layout contract:
/// fixed-ratio box on top, small label text below — no Expanded inside.
class _StampTile extends StatelessWidget {
  final Widget topChild;
  final String label;
  final Color labelColor;

  const _StampTile({
    required this.topChild,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: topChild),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
              color: labelColor,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
