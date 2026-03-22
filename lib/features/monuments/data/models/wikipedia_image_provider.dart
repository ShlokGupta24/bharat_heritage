import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';

part 'wikipedia_image_provider.g.dart';

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------
class WikipediaImageRepository {
  final Dio dio;
  WikipediaImageRepository({required this.dio});

  /// Fetches the best thumbnail URL for a Wikipedia article matching [query].
  /// Returns null if nothing is found.
  Future<String?> fetchImageUrl(String query) async {
    try {
      // Step 1 — search for the closest article title
      final searchResp = await dio.get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'query',
          'list': 'search',
          'srsearch': query,
          'srlimit': '1',
          'format': 'json',
          'origin': '*',
        },
      );

      final searchResults = searchResp.data['query']['search'] as List?;
      if (searchResults == null || searchResults.isEmpty) return null;

      final pageTitle = searchResults.first['title'] as String;

      // Step 2 — fetch the page thumbnail for that title
      final pageResp = await dio.get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'query',
          'titles': pageTitle,
          'prop': 'pageimages',
          'pithumbsize': '800',  // request a reasonably large thumbnail
          'format': 'json',
          'origin': '*',
        },
      );

      final pages = pageResp.data['query']['pages'] as Map<String, dynamic>;
      final page = pages.values.first as Map<String, dynamic>;
      final thumbnail = page['thumbnail'] as Map<String, dynamic>?;
      return thumbnail?['source'] as String?;
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------
@riverpod
WikipediaImageRepository wikipediaImageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return WikipediaImageRepository(dio: dio);
}

/// Family provider — pass the monument name, get back a nullable image URL.
/// Results are cached per name for the lifetime of the provider.
@riverpod
Future<String?> wikipediaImage(Ref ref, String monumentName) async {
  final repo = ref.watch(wikipediaImageRepositoryProvider);
  return repo.fetchImageUrl(monumentName);
}