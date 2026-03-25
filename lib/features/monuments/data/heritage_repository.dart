// d:/APP Dev/bharat_heritage/lib/features/monuments/data/heritage_repository.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';
import 'models/monument.dart';
import 'models/visitor_stats.dart';
import 'models/monument_repository.dart';

part 'heritage_repository.g.dart';

class HeritageRepository {
  final Dio dio;
  final MonumentsRepository monumentsRepository;

  HeritageRepository({required this.dio, required this.monumentsRepository});

  Future<List<Monument>> fetchMonuments() async {
    return Future.delayed(
      const Duration(milliseconds: 400),
      () => monumentsRepository.fetchMonuments(),
    );
  }

  Future<List<VisitorStats>> fetchVisitorStats() async {
    const url = 'https://api.data.gov.in/resource/9f24aaf0-79e3-4e5a-b9b1-35aba32506aa'
        '?api-key=579b464db66ec23bdd000001bc8ddd549e7e466e55b288106bb080ed'
        '&format=json&limit=200';
    final response = await dio.get(url);
    final records = response.data['records'] as List;
    return records.map((e) => VisitorStats.fromJson(e)).toList();
  }
}

@riverpod
HeritageRepository heritageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  // Fixed: removed the invalid `as ProviderListenable` cast
  final monumentsRepo = ref.watch(monumentsRepositoryProviderProvider);
  return HeritageRepository(dio: dio, monumentsRepository: monumentsRepo);
}