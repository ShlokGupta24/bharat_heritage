import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument_repository.dart';
import 'package:bharat_heritage/features/monuments/data/models/visitor_stats_provider.dart';
import '../data/models/monument.dart';

part 'monuments_provider.g.dart';

// ---------------------------------------------------------------------------
// Core data provider — fetches all monuments from the UNESCO API
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> monuments(Ref ref) async {
  final repository = ref.watch(monumentsRepositoryProviderProvider);
  return repository.fetchMonuments();
}

// ---------------------------------------------------------------------------
// Monument of the Day — deterministically picks one monument based on the
// day-of-year so it rotates daily and is consistent within the same day.
// ---------------------------------------------------------------------------
@riverpod
Future<Monument?> monumentOfTheDay(Ref ref) async {
  final all = await ref.watch(monumentsProvider.future);
  if (all.isEmpty) return null;

  // Use a numeric date string as seed so it changes every midnight automatically
  final now = DateTime.now();
  final dayOfYear = int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );
  final index = dayOfYear % all.length;
  return all[index];
}

// ---------------------------------------------------------------------------
// Search query state
// ---------------------------------------------------------------------------
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) => state = query;
}

// ---------------------------------------------------------------------------
// Filtered monuments — derived from monuments + search query
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> filteredMonuments(Ref ref) async {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final all = await ref.watch(monumentsProvider.future);

  if (query.isEmpty) return all;

  return all.where((m) {
    return m.name.toLowerCase().contains(query) ||
        m.shortDescription.toLowerCase().contains(query);
  }).toList();
}

// ---------------------------------------------------------------------------
// Other Expeditions — returns up to 5 monuments excluding monument of the
// day, rotates daily using the same date-based seed
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> otherExpeditions(Ref ref) async {
  final all = await ref.watch(monumentsProvider.future);
  final motd = await ref.watch(monumentOfTheDayProvider.future);

  final others = all.where((m) => m.id != motd?.id).toList();
  if (others.isEmpty) return [];

  final now = DateTime.now();
  final dayOfYear = int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );

  final startIndex = (dayOfYear * 3) % others.length;
  final result = <Monument>[];
  for (int i = 0; i < 5 && i < others.length; i++) {
    result.add(others[(startIndex + i) % others.length]);
  }
  return result;
}

// ---------------------------------------------------------------------------
// Monument Styling & Live Density Provider
// Memoizes heavy calculations to avoid string processing in build methods.
// ---------------------------------------------------------------------------
@riverpod
Map<String, dynamic> monumentStyler(Ref ref, Monument monument) {
  // 1. Live Density Calculation
  final allStats = ref.watch(allVisitorStatsProvider).value ?? [];
  int density;

  final match = allStats.where((s) =>
    s.monumentName.toLowerCase().contains(monument.name.toLowerCase()) ||
    monument.name.toLowerCase().contains(s.monumentName.toLowerCase())
  ).firstOrNull;

  if (match != null) {
    final dailyVisits = (((match.domesticVisitors ?? 0) + (match.foreignVisitors ?? 0)) ~/ 365);
    final base = (dailyVisits * 0.1).round();
    final hour = DateTime.now().hour;
    final curve = hour >= 9 && hour <= 16 ? 1.4 : 0.6;
    density = (base * curve).round().clamp(10, 9999);
  } else {
    final hash = monument.name.codeUnits.fold(0, (a, b) => a + b);
    density = (hash % 3000 + 500);
  }

  // 2. Architectural Style Mapping
  final Map<String, String> _styleMap = {
    'Agra Fort': 'Mughal Architecture',
    'Ajanta Caves': 'Buddhist Rock-cut',
    'Ellora Caves': 'Rock-cut (Hindu/Buddhist/Jain)',
    'Taj Mahal': 'Indo-Islamic (Mughal)',
    'Sun Temple, Konark': 'Kalinga Architecture',
    'Group of Monuments at Mahabalipuram': 'Pallava (Dravidian)',
    'Kaziranga National Park': 'Natural Landscape',
    'Manas Wildlife Sanctuary': 'Natural Landscape',
    'Keoladeo National Park': 'Natural Landscape',
    'Khajuraho Group of Monuments': 'Nagara (Chandela)',
    'Group of Monuments at Hampi': 'Vijayanagara Architecture',
    'Fatehpur Sikri': 'Mughal Architecture',
    'Group of Monuments at Pattadakal': 'Vesara (Chalukyan)',
    'Elephanta Caves': 'Rock-cut Brahminical',
    'Great Living Chola Temples': 'Dravidian Architecture',
    'Sundarbans National Park': 'Natural Landscape',
    'Nanda Devi and Valley of Flowers National Parks': 'Natural Landscape',
    'Buddhist Monuments at Sanchi': 'Buddhist Architecture',
    'Humayun\'s Tomb, Delhi': 'Mughal Architecture',
    'Qutb Minar and its Monuments, Delhi': 'Indo-Islamic',
    'Mountain Railways of India': 'Colonial Industrial',
    'Mahabodhi Temple Complex at Bodh Gaya': 'Buddhist Architecture',
    'Rock Shelters of Bhimbetka': 'Prehistoric Rock Art',
    'Champaner-Pavagadh Archaeological Park': 'Indo-Islamic',
    'Chhatrapati Shivaji Terminus (formerly Victoria Terminus)': 'Victorian Gothic',
    'Red Fort Complex': 'Mughal Architecture',
    'The Jantar Mantar, Jaipur': 'Astronomical Research',
    'Western Ghats': 'Natural Landscape',
    'Hill Forts of Rajasthan': 'Rajput Architecture',
    'Rani-ki-Vav (the Queen’s Stepwell) at Patan, Gujarat': 'Maru-Gurjara',
    'Great Himalayan National Park Conservation Area': 'Natural Landscape',
    'Archaeological Site of Nalanda Mahavihara at Nalanda, Bihar': 'Buddhist Monastic',
    'Khangchendzonga National Park': 'Mixed (Natural/Cultural)',
    'The Architectural Work of Le Corbusier, an Outstanding Contribution to the Modern Movement': 'Modernist',
    'Historic City of Ahmadabad': 'Indo-Islamic & Wooden',
    'Victorian Gothic and Art Deco Ensembles of Mumbai': 'Gothic & Art Deco',
    'Jaipur City, Rajasthan': 'Rajput (Pink City)',
    'Kakatiya Rudreshwara (Ramappa) Temple, Telangana': 'Vesara/Kakatiya',
    'Dholavira: a Harappan City': 'Indus Valley (Harappan)',
    'Santiniketan': 'Indigenous Modernism',
    'Sacred Ensembles of the Hoysalas': 'Hoysala Architecture',
    'Moidams – the Mound-Burial System of the Ahom Dynasty': 'Ahom Architecture',
    'Maratha Military Landscapes of India': 'Maratha Military',
  };

  final Map<String, String> _materialMap = {
    'Agra Fort': 'Red Sandstone',
    'Ajanta Caves': 'Basalt Rock',
    'Ellora Caves': 'Basalt',
    'Taj Mahal': 'White Marble',
    'Sun Temple, Konark': 'Khondalite',
    'Group of Monuments at Mahabalipuram': 'Granite',
    'Kaziranga National Park': 'Alluvial Soil',
    'Manas Wildlife Sanctuary': 'Terai Ecosystem',
    'Keoladeo National Park': 'Wetlands',
    'Khajuraho Group of Monuments': 'Sandstone',
    'Group of Monuments at Hampi': 'Granite',
    'Fatehpur Sikri': 'Red Sandstone',
    'Group of Monuments at Pattadakal': 'Sandstone',
    'Elephanta Caves': 'Basalt',
    'Great Living Chola Temples': 'Granite',
    'Sundarbans National Park': 'Mangrove Forest',
    'Nanda Devi and Valley of Flowers National Parks': 'Alpine Landscape',
    'Buddhist Monuments at Sanchi': 'Sandstone',
    'Humayun\'s Tomb, Delhi': 'Red Sandstone',
    'Qutb Minar and its Monuments, Delhi': 'Red Sandstone',
    'Mountain Railways of India': 'Steel & Wood',
    'Mahabodhi Temple Complex at Bodh Gaya': 'Brick',
    'Rock Shelters of Bhimbetka': 'Sandstone',
    'Champaner-Pavagadh Archaeological Park': 'Sandstone',
    'Chhatrapati Shivaji Terminus (formerly Victoria Terminus)': 'Sandstone',
    'Red Fort Complex': 'Red Sandstone',
    'The Jantar Mantar, Jaipur': 'Stone & Marble',
    'Western Ghats': 'Metamorphic Rock',
    'Hill Forts of Rajasthan': 'Sandstone',
    'Rani-ki-Vav (the Queen’s Stepwell) at Patan, Gujarat': 'Sandstone',
    'Great Himalayan National Park Conservation Area': 'Metamorphic Rock',
    'Archaeological Site of Nalanda Mahavihara at Nalanda, Bihar': 'Brick',
    'Khangchendzonga National Park': 'Mixed Soil',
    'The Architectural Work of Le Corbusier, an Outstanding Contribution to the Modern Movement': 'Concrete',
    'Historic City of Ahmadabad': 'Sandstone & Teak Wood',
    'Victorian Gothic and Art Deco Ensembles of Mumbai': 'Sandstone',
    'Jaipur City, Rajasthan': 'Pink Sandstone',
    'Kakatiya Rudreshwara (Ramappa) Temple, Telangana': 'Sandstone',
    'Dholavira: a Harappan City': 'Mud Brick',
    'Santiniketan': 'Laterite',
    'Sacred Ensembles of the Hoysalas': 'Soapstone',
    'Moidams – the Mound-Burial System of the Ahom Dynasty': 'Brick & Earth',
    'Maratha Military Landscapes of India': 'Laterite',
  };

  String getStyle() {
    for (final key in _styleMap.keys) {
      if (monument.name.toLowerCase().contains(key.toLowerCase()) || 
          key.toLowerCase().contains(monument.name.toLowerCase())) {
        return _styleMap[key]!;
      }
    }
    return 'Classical Indian';
  }

  String getMaterial() {
    for (final key in _materialMap.keys) {
      if (monument.name.toLowerCase().contains(key.toLowerCase()) || 
          key.toLowerCase().contains(monument.name.toLowerCase())) {
        return _materialMap[key]!;
      }
    }
    return 'Sandstone & Brick';
  }

  final style = getStyle();
  final material = getMaterial();

  return {
    'density': density,
    'style': style,
    'material': material,
  };
}