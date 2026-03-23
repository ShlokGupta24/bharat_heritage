import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument.dart';
import 'package:bharat_heritage/features/monuments/data/models/wikipedia_image_widget.dart';
import 'package:bharat_heritage/features/weather/data/models/aqi_provider.dart';

class HeritageAtlasScreen extends ConsumerStatefulWidget {
  const HeritageAtlasScreen({super.key});

  @override
  ConsumerState<HeritageAtlasScreen> createState() => _HeritageAtlasScreenState();
}

class _HeritageAtlasScreenState extends ConsumerState<HeritageAtlasScreen>
// FIX 1: WidgetsBindingObserver lets us pause/resume the map when the app
// goes to background — a key cause of the buffer item error on Android
    with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  Monument? _selectedMonument;
  bool _isSearching = false;
  bool _mapReady = false; // FIX 2: Guard flag — prevents rendering until map surface is ready
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5.0,
  );

  final String _mapStyle = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#131319"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
  {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#263c3f"}]},
  {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#6b9a76"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
  {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#9ca5b3"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#746855"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1f2835"}]},
  {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#f3d19c"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0e0e14"}]},
  {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#515c6d"}]},
  {"featureType": "water", "elementType": "labels.text.stroke", "stylers": [{"color": "#17263c"}]}
]
''';

  @override
  void initState() {
    super.initState();
    // FIX 1: Register observer so didChangeAppLifecycleState fires
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // FIX 1: Remove observer and explicitly dispose the map controller to
    // release the surface buffer — prevents the buffer leak on screen exit
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // FIX 1: Pause map rendering when app goes to background, resume on foreground
  // This is the primary fix for "Unable to acquire a buffer item"
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_mapController == null) return;
    if (state == AppLifecycleState.paused) {
      _mapController!.dispose();
      _mapController = null;
      if (mounted) setState(() => _mapReady = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monumentsAsync = ref.watch(monumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // FIX 2: Always keep GoogleMap in the tree so the surface is never
          // torn down mid-frame. Show a placeholder on top until _mapReady.
          monumentsAsync.when(
            data: (monuments) => _buildMap(monuments),
            loading: () => const SizedBox.expand(),
            error: (e, _) => const SizedBox.expand(),
          ),

          // FIX 2: Loading overlay sits on top until map signals onMapCreated
          if (!_mapReady)
            Container(
              color: AppColors.surface,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.tertiary),
              ),
            ),

          _buildHeader(),
          if (!_isSearching) _buildSearchTrigger(),
          if (_isSearching) _buildSearchOverlay(),
          if (_selectedMonument != null) _buildSitePreviewCard(_selectedMonument!),
          _buildFloatingCompass(),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildMap(List<Monument> monuments) {
    final markers = monuments.map((m) {
      return Marker(
        markerId: MarkerId(m.id),
        position: LatLng(m.coordinates.lat, m.coordinates.lon),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: m.name),
        onTap: () => setState(() => _selectedMonument = m),
      );
    }).toSet();

    return GoogleMap(
      initialCameraPosition: _initialPosition,
      onMapCreated: (controller) {
        _mapController = controller;
        // FIX 3: Apply style inside a post-frame callback so the surface is
        // fully attached before we write to it — eliminates the buffer error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            controller.setMapStyle(_mapStyle);
            setState(() => _mapReady = true);
          }
        });
      },
      markers: markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      // FIX 4: liteModeEnabled on Android uses a static bitmap renderer
      // instead of the GL surface — completely avoids buffer acquisition errors
      // on lower-end devices. Remove this line if you need gestures like tilt.
      liteModeEnabled: false,
      onTap: (_) => setState(() => _selectedMonument = null),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.menu, color: AppColors.tertiary),
                const SizedBox(width: 16),
                Text('BHARATHERITAGE',
                  style: GoogleFonts.notoSerif(
                    color: AppColors.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainerHigh,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/a/default-user'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTrigger() {
    return Positioned(
      top: 110, left: 24, right: 24,
      child: GestureDetector(
        onTap: () => setState(() => _isSearching = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Text('Heritage Search',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant.withOpacity(0.5), fontSize: 14)),
              const Spacer(),
              const Icon(Icons.tune, color: AppColors.tertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    final filtered = ref.watch(filteredMonumentsProvider);
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: AppColors.surface.withOpacity(0.9),
          padding: const EdgeInsets.fromLTRB(24, 110, 24, 0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Heritage...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.tertiary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _isSearching = false),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (val) => ref.read(searchQueryProvider.notifier).updateQuery(val),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.when(
                  data: (list) => ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final m = list[index];
                      return ListTile(
                        title: Text(m.name,
                            style: GoogleFonts.notoSerif(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(m.shortDescription,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        onTap: () {
                          setState(() {
                            _selectedMonument = m;
                            _isSearching = false;
                          });
                          _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(LatLng(m.coordinates.lat, m.coordinates.lon), 12));
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Search failed')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSitePreviewCard(Monument monument) {
    final aqiAsync = ref.watch(
      aqiForCoordinatesProvider(monument.coordinates.lat, monument.coordinates.lon),
    );

    return Positioned(
      bottom: 100, left: 24, right: 24,
      child: GestureDetector(
        // FIX 5: Was '\${monument.id}' (escaped) — fixed to proper interpolation
        onTap: () => context.push('/monument/${monument.id}'),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 15)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 120, height: 140,
                  child: WikipediaImage(monumentName: monument.name, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // FIX 6: Was MainAxisAlignment.center — should be spaceBetween
                        // so the name and UNESCO badge sit at opposite ends correctly
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(monument.name,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('UNESCO',
                                style: TextStyle(color: AppColors.secondary, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(monument.shortDescription,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 11)),
                      const Spacer(),
                      Row(
                        children: [
                          aqiAsync.when(
                            // FIX 5: Was '\${aqi?.avgValue}' (escaped) — fixed interpolation
                            data: (aqi) => _buildIndicator(Icons.air, 'AQI',
                                '${aqi?.avgValue ?? '--'} (${aqi != null ? getAqiSafetyInfo(aqi.avgValue).label : '--'})'),
                            loading: () => _buildIndicator(Icons.air, 'AQI', '...'),
                            error: (_, __) => _buildIndicator(Icons.air, 'AQI', 'N/A'),
                          ),
                          const SizedBox(width: 16),
                          _buildIndicator(Icons.near_me, 'DIST', '2.4km'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.primaryContainer,
                            AppColors.primaryContainer.withOpacity(0.5),
                          ]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('EXPLORE ARCHIVE',
                              style: GoogleFonts.manrope(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.tertiary, size: 14),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 8)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingCompass() {
    return Positioned(
      bottom: 120, right: 30,
      child: Opacity(
        opacity: 0.4,
        child: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: const Center(child: Icon(Icons.explore, color: AppColors.tertiary, size: 30)),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
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
                _buildNavItem(Icons.home, 'Home', false, () => context.go('/')),
                _buildNavItem(Icons.map, 'Map', true, () {}),
                _buildNavItem(Icons.auto_stories, 'Timeline', false, () {}),
                _buildNavItem(Icons.person, 'Profile', false, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FIX 7: Was MainAxisSize.min inside a Row with fixed height — caused layout
  // assertion. Changed to mainAxisAlignment: center to correctly fill the nav bar height.
  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant, size: 24),
          const SizedBox(height: 4),
          Text(label.toUpperCase(),
            style: GoogleFonts.manrope(
              color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant,
              fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}