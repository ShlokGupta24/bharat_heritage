import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/auth/domain/auth_provider.dart';
import 'package:bharat_heritage/features/weather/data/models/aqi_provider.dart';
import 'package:bharat_heritage/features/monuments/data/models/wikipedia_image_widget.dart';
import 'package:bharat_heritage/features/monuments/data/models/visitor_stats_provider.dart';
import '../../features/monuments/data/models/monument.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _cardOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final opacity = (1.0 - ((offset - 60) / 160)).clamp(0.0, 1.0);
      if (opacity != _cardOpacity) {
        setState(() => _cardOpacity = opacity);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monumentOfTheDay = ref.watch(monumentOfTheDayProvider);
    final otherExpeditions = ref.watch(otherExpeditionsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(),
              monumentOfTheDay.when(
                data: (monument) => _buildParallaxHero(monument),
                loading: () => SliverToBoxAdapter(child: _buildHeroPlaceholder()),
                error: (_, _) => SliverToBoxAdapter(child: _buildHeroPlaceholder()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildBentoGrid(),
                      const SizedBox(height: 32),
                      _buildBottomWidgets(),
                      const SizedBox(height: 32),
                      _buildExpeditionsSection(otherExpeditions),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomNavBar(),
          Positioned(bottom: 95, right: 20, child: _buildFAB()),
          if (_isSearching) _buildSearchOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface.withValues(alpha:204),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.tertiary),
        onPressed: () {},
      ),
      title: Text('BharatHeritage',
          style: GoogleFonts.notoSerif(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.onSurface, letterSpacing: -0.5)),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant), onPressed: () => setState(() => _isSearching = true)),
        IconButton(icon: const Icon(Icons.notifications_none, color: AppColors.onSurfaceVariant), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildParallaxHero(Monument? monument) {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: false,
      snap: false,
      floating: false,
      stretch: true,
      backgroundColor: AppColors.surfaceContainerLow,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            WikipediaImage(monumentName: monument?.name ?? 'India heritage monument', fit: BoxFit.cover, fallbackAsset: 'design/tajmahal.avif'),
            Opacity(
              opacity: _cardOpacity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.surface.withValues(alpha:210)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24, left: 24, right: 24,
              child: Opacity(
                opacity: _cardOpacity,
                child: Transform.translate(
                  offset: Offset(0, (1 - _cardOpacity) * 60),
                  child: GlassmorphicCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('MONUMENT OF THE DAY',
                            style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        Text(monument?.name ?? 'The Great Arches',
                            style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 12),
                        Text(
                          monument?.shortDescription ?? 'Explore the timeless monuments of architectural brilliance.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final isAuth = ref.read(authProvider).value ?? false;
                            if (!isAuth) { context.push('/login?from=/'); return; }
                            if (monument != null) context.push('/monument/${monument.id}');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Plan Expedition', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPlaceholder() {
    return Container(height: 480,
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(24)));
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildAqiWidget()),
                const SizedBox(width: 16),
                if (!isMobile) Expanded(flex: 2, child: _buildCrowdTrendsWidget()),
              ],
            ),
            if (isMobile) ...[const SizedBox(height: 16), _buildCrowdTrendsWidget()],
          ],
        );
      },
    );
  }

  Widget _buildAqiWidget() {
    final aqiAsync = ref.watch(monumentAqiProvider);
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: aqiAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text('AQI unavailable', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12))),
        data: (aqiData) {
          final avgStr = aqiData?.avgValue ?? '--';
          final aqiInt = int.tryParse(avgStr) ?? 0;
          final aqiNormalized = (aqiInt / 500).clamp(0.0, 1.0);
          final safety = aqiData != null ? getAqiSafetyInfo(avgStr) : null;
          Color aqiColor;
          switch (safety?.level) {
            case AqiLevel.good:      aqiColor = const Color(0xFF4CAF50); break;
            case AqiLevel.moderate:  aqiColor = AppColors.tertiary;      break;
            case AqiLevel.poor:      aqiColor = const Color(0xFFFF9800); break;
            case AqiLevel.hazardous: aqiColor = const Color(0xFFF44336); break;
            default:                 aqiColor = AppColors.tertiary;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ENVIRONMENT • AQI',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const Spacer(),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: 80, height: 80,
                        child: CircularProgressIndicator(value: aqiNormalized, strokeWidth: 8,
                            backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation<Color>(aqiColor))),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(avgStr, style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text(safety?.label ?? '--', style: GoogleFonts.manrope(fontSize: 8, fontWeight: FontWeight.w800, color: aqiColor)),
                    ]),
                  ],
                ),
              ),
              const Spacer(),
              Text(safety?.message ?? 'Fetching air quality data...',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 10, height: 1.4), textAlign: TextAlign.center),
            ],
          );
        },
      ),
    );
  }

  // Crowd chart powered by real visitor stats API via crowdCurveProvider
  Widget _buildCrowdTrendsWidget() {
    final crowdAsync = ref.watch(crowdCurveProvider);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: crowdAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
            child: Text('Stats unavailable', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12))),
        data: (crowd) {
          const labels = ['06:00', '08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00'];
          final heights = crowd.heights;
          final peakIndex = heights.indexOf(heights.reduce((a, b) => a > b ? a : b));
          final quietIndex = heights.indexOf(heights.reduce((a, b) => a < b ? a : b));

          String formatCount(int n) {
            if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
            if (n >= 1000)   return '${(n / 1000).toStringAsFixed(0)}K';
            return n.toString();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INTELLIGENCE • CROWD DENSITY',
                          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                      Text('Quiet at ${labels[quietIndex]}',
                          style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Popularity badge derived from real annual visitor count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withValues(alpha:0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.secondary.withValues(alpha:0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text(crowd.popularityLabel.toUpperCase(),
                                style: GoogleFonts.manrope(color: AppColors.secondary, fontSize: 5, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      if (crowd.total > 0) ...[
                        const SizedBox(height: 3),
                        Text('${formatCount(crowd.total)} annual',
                            style: GoogleFonts.manrope(color: AppColors.outline, fontSize: 7, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Bar chart — heights derived from real visitor ratio + popularity
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(heights.length, (index) {
                  final isPeak  = index == peakIndex;
                  final isQuiet = index == quietIndex;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 52 * heights[index],
                      decoration: BoxDecoration(
                        color: isPeak
                            ? AppColors.tertiary
                            : isQuiet
                            ? AppColors.surfaceVariant.withValues(alpha:160)
                            : heights[index] > 0.5
                            ? AppColors.tertiary.withValues(alpha:102)
                            : AppColors.surfaceVariant,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        boxShadow: isPeak
                            ? [BoxShadow(color: AppColors.tertiary.withValues(alpha:77), blurRadius: 10, spreadRadius: 2)]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              // X-axis labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(labels.first, style: GoogleFonts.manrope(color: AppColors.outline, fontSize: 8)),
                  Text('${labels[peakIndex]} (Peak)', style: GoogleFonts.manrope(color: AppColors.outline, fontSize: 8)),
                  Text(labels.last, style: GoogleFonts.manrope(color: AppColors.outline, fontSize: 8)),
                ],
              ),
              // Domestic / Foreign breakdown chips — only shown when API returned data
              if (crowd.total > 0) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    _visitorChip(Icons.person, '${formatCount(crowd.totalDomestic)} domestic', AppColors.tertiary),
                    const SizedBox(width: 10),
                    _visitorChip(Icons.flight_land, '${formatCount(crowd.totalForeign)} foreign', AppColors.secondary),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _visitorChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 8, color: color),
        const SizedBox(width: 3),
        Text(label, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 7, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomWidgets() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.surfaceContainer, AppColors.surfaceContainerLow]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha:26)),
          ),
          child: Row(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer.withValues(alpha:77),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.tertiary.withValues(alpha:51)),
                ),
                child: const Icon(Icons.auto_stories, color: AppColors.tertiary, size: 32),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explorer Passport', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(4)),
                      child: Text('LEVEL 4', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('NEXT REWARD', style: GoogleFonts.manrope(color: AppColors.outline, fontSize: 8, fontWeight: FontWeight.bold)),
                  Text('Golden Temple Badge', style: GoogleFonts.manrope(color: AppColors.onSurface, fontSize: 10)),
                  const SizedBox(height: 2),
                  SizedBox(width: 80, height: 4,
                      child: LinearProgressIndicator(value: 0.75, backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tertiary))),
                  Text('12 Stamps Unlocked', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 2, height: 40,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [AppColors.tertiary, Colors.transparent]))),
                    const Icon(Icons.explore, color: Colors.white, size: 32),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('HERITAGE COMPASS', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.w900)),
              Text('Nearby gems within 5km of your location', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpeditionsSection(AsyncValue<List<Monument>> monuments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Other Expeditions', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('VIEW ALL', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: monuments.when(
            data: (list) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                final m = list[index];
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha:13)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              WikipediaImageCard(monumentName: m.name),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.black.withValues(alpha:102), borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.history_edu, color: Colors.white, size: 10),
                                        const SizedBox(width: 4),
                                        Text('Since ${m.dateInscribed}',
                                            style: GoogleFonts.manrope(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.name, style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(m.shortDescription, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const Center(child: Text('Failed to load expeditions')),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha:153),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withValues(alpha:26)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', true, () {}),
                _buildNavItem(Icons.map, 'Map', false, () => context.go('/map')),
                _buildNavItem(Icons.auto_stories, 'Passport', false, () {}),
                _buildNavItem(Icons.person, 'Profile', false, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant, size: 24),
          const SizedBox(height: 4),
          Text(label.toUpperCase(),
              style: GoogleFonts.manrope(color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant,
                  fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.tertiary.withValues(alpha:0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: const Icon(Icons.qr_code_scanner, color: AppColors.onTertiary, size: 32),
    );
  }

  Widget _buildSearchOverlay() {
    final filtered = ref.watch(filteredMonumentsProvider);
    return Positioned.fill(
      child: Container(
        color: AppColors.surface.withValues(alpha:0.95),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Heritage...',
                      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                      prefixIcon: const Icon(Icons.search, color: AppColors.tertiary),
                      filled: true,
                      fillColor: AppColors.surfaceContainerHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).updateQuery(val),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() => _isSearching = false);
                    ref.read(searchQueryProvider.notifier).updateQuery('');
                    _searchController.clear();
                  },
                  child: const Text('CANCEL', style: TextStyle(color: AppColors.onSurfaceVariant)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: filtered.when(
                data: (list) => ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final m = list[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: SizedBox(
                        width: 60, height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: m.imageUrl != null && m.imageUrl!.isNotEmpty
                              ? Image.network(m.imageUrl!, width: 60, height: 60, fit: BoxFit.cover,
                              loadingBuilder: (context, child, p) {
                                if (p == null) return child;
                                return Container(color: AppColors.surfaceContainerHigh,
                                    child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))));
                              },
                              errorBuilder: (_, _, _) => Container(color: AppColors.surfaceContainerHigh,
                                  child: const Icon(Icons.image_not_supported, color: AppColors.onSurfaceVariant, size: 24)))
                              : Container(color: AppColors.surfaceContainerHigh,
                              child: const Icon(Icons.landscape, color: AppColors.tertiary, size: 24)),
                        ),
                      ),
                      title: Text(m.name, style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(m.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 14),
                      onTap: () {
                        final isAuth = ref.read(authProvider).value ?? false;
                        if (!isAuth) { context.push('/login?from=/'); return; }
                        context.push('/monument/${m.id}');
                        setState(() => _isSearching = false);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => const Center(child: Text('Search failed')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}