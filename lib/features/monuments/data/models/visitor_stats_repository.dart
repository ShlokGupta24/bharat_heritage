import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';
import 'package:bharat_heritage/features/monuments/data/models/visitor_stats.dart';

part 'visitor_stats_repository.g.dart';

class VisitorStatsRepository {
  final Dio dio;
  VisitorStatsRepository({required this.dio});

  Future<List<VisitorStats>> fetchAllStats() async {
    const url =
        'https://api.data.gov.in/resource/9f24aaf0-79e3-4e5a-b9b1-35aba32506aa'
        '?api-key=579b464db66ec23bdd000001bc8ddd549e7e466e55b288106bb080ed'
        '&format=json&limit=200';
    try {
      final response = await dio.get(url);
      final records = response.data['records'] as List;
      return records.map((e) => VisitorStats.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}

@riverpod
VisitorStatsRepository visitorStatsRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return VisitorStatsRepository(dio: dio);
}