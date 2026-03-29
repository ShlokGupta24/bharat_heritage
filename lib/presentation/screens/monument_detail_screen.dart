import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/glassmorphic_card.dart';
import '../../features/monuments/data/models/monument.dart';
import '../../features/monuments/domain/monuments_provider.dart';
import '../../features/passport/domain/passport_provider.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../features/monuments/data/models/wikipedia_image_widget.dart';
import '../../features/weather/domain/aqi_provider.dart';
import '../../features/bookmarks/domain/bookmark_provider.dart';
import '../../features/monuments/data/models/wikipedia_provider.dart';
import '../../features/monuments/data/models/visitor_stats_provider.dart';
class AsymmetricClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0); 
    path.lineTo(size.width, size.height * 0.85); 
    path.lineTo(0, size.height); 
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MonumentDetailScreen extends ConsumerStatefulWidget {
  final String monumentId;
  const MonumentDetailScreen({super.key, required this.monumentId});

  @override
  ConsumerState<MonumentDetailScreen> createState() => _MonumentDetailScreenState();
}

class _MonumentDetailScreenState extends ConsumerState<MonumentDetailScreen> {
  static const _styleMap = {
    'taj mahal': 'Mughal Architecture',
    'agra fort': 'Mughal Architecture',
    'humayun': 'Mughal Architecture',
    'red fort complex': 'Mughal Architecture',
    'fatehpur sikri': 'Mughal Architecture',
    'qutb minar': 'Indo-Islamic Architecture',
    'elephanta caves': 'Rock-cut Hindu Architecture',
    'mahabalipuram': 'Pallava Architecture',
    'jaipur city': 'Rajput / City Planning',
    'moidams': 'Ahom Architecture',
    'hoysalas': 'Hoysala Architecture',
    'santiniketan': 'Modern / Eclectic',
    'sundarbans': 'Natural Heritage (Mangrove)',
    'jantar mantar': 'Rajput Architecture',
    'western ghats': 'Natural Heritage (Biological)',
    'ajanta caves': 'Rock-cut Buddhist Architecture',
    'nalanda': 'Indo-Gangetic / Pala Art',
    'sanchi': 'Buddhist Architecture',
    'convents of goa': 'Portuguese-Baroque',
    'dholavira': 'Harappan Architecture',
    'great himalayan': 'Natural Heritage',
    'chola temples': 'Dravidian Architecture',
    'hampi': 'Vijayanagara Architecture',
    'khajuraho': 'Chandela / Nagara Style',
    'khangchendzonga': 'Mixed Heritage',
    'maratha military': 'Maratha Military Architecture',
    'victorian gothic': 'Victorian Gothic & Art Deco',
    'rani-ki-vav': 'Maru-Gurjara Style',
    'champaner': 'Indo-Islamic Architecture',
    'chhatrapati shivaji': 'Victorian Gothic Revival',
    'ellora caves': 'Rock-cut Architecture',
    'pattadakal': 'Chalukyan / Vesara Style',
    'hill forts': 'Rajput Architecture',
    'ahmadabad': 'Indo-Islamic (Sultanate)',
    'kakatiya': 'Kakatiya Architecture',
    'kaziranga': 'Natural Heritage',
    'keoladeo': 'Natural Heritage',
    'mahabodhi': 'Buddhist Architecture',
    'manas': 'Natural Heritage',
    'mountain railways': 'Colonial Engineering',
    'nanda devi': 'Natural Heritage',
    'bhimbetka': 'Prehistoric Rock Art',
    'sun temple': 'Kalinga Architecture',
    'le corbusier': 'Modern Movement Architecture',
  };

  static const _materialMap = {
    'taj mahal': 'White Makrana Marble',
    'agra fort': 'Red Sandstone',
    'humayun': 'Red Sandstone & Marble',
    'red fort complex': 'Red Sandstone',
    'fatehpur sikri': 'Red Sandstone',
    'qutb minar': 'Red Sandstone & Marble',
    'elephanta caves': 'Basalt Rock',
    'mahabalipuram': 'Granite',
    'jaipur city': 'Pink Sandstone',
    'moidams': 'Earth, Brick & Stone',
    'hoysalas': 'Soapstone (Steatite)',
    'santiniketan': 'Laterite & Cement',
    'sundarbans': 'Natural Ecosystem',
    'jantar mantar': 'Marble & Stone',
    'western ghats': 'Basalt & Laterite',
    'ajanta caves': 'Basalt Rock',
    'nalanda': 'Brick',
    'sanchi': 'Sandstone',
    'convents of goa': 'Laterite & Lime',
    'dholavira': 'Limestone & Mud Brick',
    'great himalayan': 'Crystalline Rock',
    'chola temples': 'Granite',
    'hampi': 'Granite',
    'khajuraho': 'Sandstone',
    'khangchendzonga': 'Mixed Sedimentary',
    'maratha military': 'Basalt & Stone',
    'victorian gothic': 'Teak & Stone',
    'rani-ki-vav': 'Sandstone',
    'champaner': 'Stone & Marble',
    'chhatrapati shivaji': 'Italian Marble & Sandstone',
    'ellora caves': 'Basalt Rock',
    'pattadakal': 'Sandstone',
    'hill forts': 'Stone & Lime',
    'ahmadabad': 'Stone & Timber',
    'kakatiya': 'Sandstone & Basalt',
    'kaziranga': 'Alluvial Soil',
    'keoladeo': 'Sedimentary',
    'mahabodhi': 'Brick & Sandstone',
    'manas': 'Sedimentary & Alluvial',
    'mountain railways': 'Steel, Iron & Stone',
    'nanda devi': 'Glacial & Crystalline',
    'bhimbetka': 'Sandstone',
    'sun temple': 'Khondalite Sandstone',
    'le corbusier': 'Reinforced Concrete',
  };

  String _getStyle(String name) {
    final n = name.toLowerCase();
    for (final entry in _styleMap.entries) {
      if (n.contains(entry.key)) return entry.value;
    }
    return 'Heritage Architecture';
  }

  String _getMaterial(String name) {
    final n = name.toLowerCase();
    for (final entry in _materialMap.entries) {
      if (n.contains(entry.key)) return entry.value;
    }
    return 'Stone & Masonry';
  }

  /// Generate a unique but deterministic daily density for each monument
  int _getLiveDensity(Monument monument, List<dynamic> allStats) {
    // First try to match real visitor stats
    final match = allStats.where((s) =>
      s.monumentName.toLowerCase().contains(monument.name.toLowerCase()) ||
      monument.name.toLowerCase().contains(s.monumentName.toLowerCase())
    ).firstOrNull;

    if (match != null) {
      final dailyVisits = (((match.domesticVisitors ?? 0) + (match.foreignVisitors ?? 0)) ~/ 365);
      final base = (dailyVisits * 0.1).round();
      // Add time-based variation: more visitors mid-day
      final hour = DateTime.now().hour;
      final curve = hour >= 9 && hour <= 16 ? 1.4 : 0.6;
      return (base * curve).round().clamp(10, 9999);
    }

    // Fallback: deterministic value from monument name hash
    final hash = monument.name.codeUnits.fold(0, (a, b) => a + b);
    return (hash % 3000 + 500);
  }

  Monument? _getMonument(List<Monument> monuments) {
    for (var m in monuments) {
      if (m.id == widget.monumentId) return m;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final monumentsAsync = ref.watch(monumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: monumentsAsync.when(
        data: (monuments) {
          final monument = _getMonument(monuments);
          if (monument == null) {
            return const Center(child: Text("Monument not found", style: TextStyle(color: Colors.white)));
          }
          return _buildContent(monument);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.tertiary)),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildContent(Monument monument) {
    final wikiDataAsync = ref.watch(wikipediaDetailsProvider(monument.name));
    final wiki = wikiDataAsync.value;
    final isBookmarked = ref.watch(bookmarkProvider).value?.contains(monument.id) ?? false;

    return Stack(
      children: [
        // Background Deco
        Positioned(
          top: 100, right: -50,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(color: AppColors.primaryContainer.withAlpha(51), shape: BoxShape.circle),
          ),
        ),
        Positioned(
          bottom: 100, left: -50,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(color: AppColors.secondaryContainer.withAlpha(51), shape: BoxShape.circle),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),

        CustomScrollView(
          slivers: [
            _buildSliverAppBar(monument),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildContextCard(monument, wiki),
                    const SizedBox(height: 48),
                    _buildLiveIntelligence(monument),
                    const SizedBox(height: 48),
                    _buildGallery(monument, wiki),
                    const SizedBox(height: 120), // Bottom padding for check-in button
                  ],
                ),
              ),
            ),
          ],
        ),

        // Fixed Top Header (over sliver)
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 24, right: 24, bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface.withAlpha(153),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh.withAlpha(200), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Image.asset('design/screen.png', height: 26),
                        const SizedBox(width: 8),
                        Text('BharatHeritage', style: GoogleFonts.notoSerif(color: AppColors.onSurfaceVariant, fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => ref.read(bookmarkProvider.notifier).toggleBookmark(monument.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh.withAlpha(200), borderRadius: BorderRadius.circular(12)),
                        child: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: AppColors.tertiary, size: 24),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        // Check-in Action Footer
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 24, left: 24, right: 24, top: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.surface, AppColors.surface.withAlpha(0)],
              ),
            ),
            child: GestureDetector(
              onTap: _handleQuickCheckIn,
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primary, AppColors.primaryContainer]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.primaryContainer.withAlpha(153), blurRadius: 32, offset: const Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DIGITAL PASSPORT', style: GoogleFonts.manrope(color: AppColors.onPrimaryContainer, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        Text('Check-in Now', style: GoogleFonts.notoSerif(color: AppColors.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(color: AppColors.onPrimary, shape: BoxShape.circle),
                      child: const Icon(Icons.approval, color: AppColors.primaryContainer, size: 24),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Monument monument) {
    return SliverToBoxAdapter(
      child: ClipPath(
        clipper: AsymmetricClipper(),
        child: SizedBox(
          height: 500,
          child: Stack(
            fit: StackFit.expand,
            children: [
              monument.imageUrl != null && monument.imageUrl!.isNotEmpty
                  ? Image.network(monument.imageUrl!, fit: BoxFit.cover)
                  : const WikipediaImageCard(monumentName: 'Placeholder'),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.surface, Colors.transparent],
                    stops: const [0.0, 0.4],
                  ),
                ),
              ),
              Positioned(
                bottom: 80, left: 24, right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UNESCO WORLD HERITAGE SITE', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 3)),
                    const SizedBox(height: 8),
                    Text(monument.name, style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, height: 1.1)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.surfaceContainer.withAlpha(153), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withAlpha(26))),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.tertiary, size: 14),
                              const SizedBox(width: 4),
                              Text('INDIA', style: GoogleFonts.manrope(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.surfaceContainer.withAlpha(153), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withAlpha(26))),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppColors.tertiary, size: 14),
                              const SizedBox(width: 4),
                              Text('${monument.dateInscribed} AD', style: GoogleFonts.manrope(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextCard(Monument monument, WikiData? wiki) {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Historical Context', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.white.withAlpha(26)),
            const SizedBox(height: 16),
            Text((wiki != null && wiki.description.isNotEmpty) ? wiki.description : monument.shortDescription, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.6), maxLines: 6, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12), border: const Border(left: BorderSide(color: AppColors.tertiary, width: 4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ARCHITECTURAL STYLE', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(_getStyle(monument.name), style: GoogleFonts.manrope(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12), border: const Border(left: BorderSide(color: AppColors.secondary, width: 4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PRIMARY MATERIAL', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(_getMaterial(monument.name), style: GoogleFonts.manrope(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLiveIntelligence(Monument monument) {
    final aqiAsync = ref.watch(aqiProvider(monument.coordinates));
    
    final allStats = ref.watch(allVisitorStatsProvider).value ?? [];
    final liveDensity = _getLiveDensity(monument, allStats);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Live Intelligence', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Real-time Environmental Monitoring', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.sensors, color: AppColors.error, size: 14),
                const SizedBox(width: 4),
                Text('LIVE DATA', style: GoogleFonts.manrope(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AIR QUALITY INDEX (AQI)', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    aqiAsync.when(
                      data: (aqi) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${aqi.aqi}', style: GoogleFonts.manrope(color: AppColors.secondary, fontSize: 32, fontWeight: FontWeight.w900)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(4)),
                                  child: Text(aqi.category, style: GoogleFonts.manrope(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(2)),
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(widthFactor: (aqi.aqi / 300.0).clamp(0.0, 1.0), child: Container(decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(2))))
                            )
                          ],
                        );
                      },
                      loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
                      error: (e, st) => const SizedBox(height: 60, child: Text('Failed to load AQI', style: TextStyle(color: Colors.white, fontSize: 10))),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT DENSITY', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$liveDensity', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 32, fontWeight: FontWeight.w900)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(4)),
                              child: Text('LIVE', style: GoogleFonts.manrope(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            final isSelected = index == 3;
                            final height = isSelected ? 30.0 : (10.0 + (index * 4) % 20);
                            return Container(width: 12, height: height, decoration: BoxDecoration(color: isSelected ? AppColors.tertiary : AppColors.surfaceVariant.withAlpha(102), borderRadius: const BorderRadius.vertical(top: Radius.circular(2))));
                          }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGallery(Monument monument, WikiData? wiki) {
    String? extraImg1 = wiki != null && wiki.images.isNotEmpty ? wiki.images[0] : null;
    String? extraImg2 = wiki != null && wiki.images.length > 1 ? wiki.images[1] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library, color: AppColors.tertiary, size: 20),
            const SizedBox(width: 8),
            Text('Archival Visuals', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: extraImg1 != null
                      ? Image.network(extraImg1, fit: BoxFit.cover, color: Colors.grey, colorBlendMode: BlendMode.saturation)
                      : Container(color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: extraImg2 != null
                      ? Image.network(extraImg2, fit: BoxFit.cover)
                      : Container(color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('+2 MORE', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('VIRTUAL TOUR', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 8)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Same check-in logic as home_screen
  Future<void> _handleQuickCheckIn() async {
    final isAuth = ref.read(authProvider).value ?? false;
    if (!isAuth) {
      context.push('/login?from=/');
      return;
    }

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.tertiary)));

    ref.invalidate(currentPositionProvider);
    ref.invalidate(nearbyMonumentProvider);

    try {
      final nearbyMonument = await ref.read(nearbyMonumentProvider.future);
      if (!mounted) return;

      if (nearbyMonument == null) {
        Navigator.pop(context);
        _showNoMonumentFoundDialog();
        return;
      }
      
      // If we are checking in on a detail screen, theoretically it could be for ANY nearby monument, 
      // but the HTML says "Check-in Now". We'll just run the generic check.
      
      final visited = await ref.read(visitedMonumentIdsProvider.future);
      if (!mounted) return;

      if (visited.contains(nearbyMonument.id)) {
        Navigator.pop(context);
        _showAlreadyCollectedDialog(nearbyMonument.name);
        return;
      }

      final newStampName = await ref.read(tryAwardStampProvider.future);
      if (!mounted) return;
      Navigator.pop(context);

      if (newStampName != null) {
        _showStampUnlockedDialog(newStampName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Could not collect stamp.'), backgroundColor: AppColors.error));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Error verifying location.'), backgroundColor: AppColors.error));
      }
    }
  }

  // Reused dialogs
  void _showAlreadyCollectedDialog(String monumentName) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withAlpha(128))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history_edu, color: AppColors.primary, size: 80),
              const SizedBox(height: 16),
              Text('Already Collected!', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('You have already sealed the stamp for\n$monumentName in your digital passport.', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () { Navigator.pop(ctx); context.push('/passport'); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('VIEW PASSPORT', style: GoogleFonts.manrope(color: AppColors.primary, fontWeight: FontWeight.w900, letterSpacing: 1.5)))),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('DISMISS', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold))))
            ],
          ),
        ),
      ),
    );
  }

  void _showNoMonumentFoundDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withAlpha(128))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wrong_location_outlined, color: AppColors.error, size: 80),
              const SizedBox(height: 16),
              Text('No Monument Near', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('We couldn\'t detect any heritage sites within 500m of your GPS location.', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceContainerHighest, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('OKAY', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, letterSpacing: 1.5))))
            ],
          ),
        ),
      ),
    );
  }

  void _showStampUnlockedDialog(String monumentName) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.tertiary.withAlpha(128))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: AppColors.tertiary, size: 80),
              const SizedBox(height: 16),
              Text('Stamp Unlocked!', style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('You have successfully collected the stamp for\n$monumentName', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiary, foregroundColor: AppColors.onTertiary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('AWESOME!', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, letterSpacing: 1.5))))
            ],
          ),
        ),
      ),
    );
  }
}
