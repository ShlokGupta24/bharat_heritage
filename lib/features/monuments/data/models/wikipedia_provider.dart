import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WikiData {
  final String description;
  final List<String> images;
  const WikiData(this.description, this.images);
}

final wikipediaDetailsProvider = FutureProvider.family<WikiData, String>((ref, title) async {
  final dio = Dio();
  final query = Uri.encodeComponent(title);
  
  try {
    // Fetch extract
    final extractRes = await dio.get(
      'https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro&explaintext&redirects=1&titles=$query&format=json'
    );
    
    String desc = '';
    final pages = extractRes.data['query']['pages'] as Map<String, dynamic>;
    if (pages.isNotEmpty) {
      final firstPage = pages.values.first;
      if (firstPage['extract'] != null) {
        desc = firstPage['extract'];
      }
    }

    // Fetch images 
    // We get file names first
    final imgRes = await dio.get(
      'https://en.wikipedia.org/w/api.php?action=query&prop=images&titles=$query&format=json&imlimit=10'
    );
    
    List<String> imageUrls = [];
    final imgPages = imgRes.data['query']['pages'] as Map<String, dynamic>;
    if (imgPages.isNotEmpty) {
      final page = imgPages.values.first;
      if (page['images'] != null) {
        final images = page['images'] as List;
        for (var img in images) {
          final fileTitle = img['title'] as String;
          // Filter out icons, svgs, mp3s
          if (!fileTitle.toLowerCase().endsWith('jpg') && !fileTitle.toLowerCase().endsWith('jpeg') && !fileTitle.toLowerCase().endsWith('png')) {
            continue;
          }
          imageUrls.add(fileTitle);
          if (imageUrls.length >= 3) break; // Only need up to 3 for gallery
        }
      }
    }

    // Resolve file names to URLs
    List<String> finalUrls = [];
    for (var file in imageUrls) {
      final fileQuery = Uri.encodeComponent(file);
      final urlRes = await dio.get(
        'https://en.wikipedia.org/w/api.php?action=query&titles=$fileQuery&prop=imageinfo&iiprop=url&format=json'
      );
      final uPages = urlRes.data['query']['pages'] as Map<String, dynamic>;
      if (uPages.isNotEmpty) {
        final uPage = uPages.values.first;
        if (uPage['imageinfo'] != null) {
          final info = uPage['imageinfo'] as List;
          if (info.isNotEmpty) {
            finalUrls.add(info.first['url']);
          }
        }
      }
    }

    return WikiData(desc, finalUrls);
  } catch (e) {
    return const WikiData('', []);
  }
});
