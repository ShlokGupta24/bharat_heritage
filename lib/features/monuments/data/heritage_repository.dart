import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';
import 'models/monument.dart';
import 'models/visitor_stats.dart';
import 'models/monument_repository.dart';

part 'heritage_repository.g.dart';

class HeritageRepository {
  final Dio dio;

  HeritageRepository({required this.dio});

  Future<List<Monument>> fetchMonuments() async {
    // Return statically bundled offline data perfectly formatted
    return Future.delayed(const Duration(milliseconds: 400), () => MonumentsRepository(dio: dio));
  }

  Future<List<VisitorStats>> fetchVisitorStats() async {
    const url = 'https://api.data.gov.in/resource/9f24aaf0-79e3-4e5a-b9b1-35aba32506aa?api-key=579b464db66ec23bdd000001bc8ddd549e7e466e55b288106bb080ed&format=json';
    final response = await dio.get(url);
    final records = response.data['records'] as List;
    return records.map((e) => VisitorStats.fromJson(e)).toList();
  }
}

@riverpod
HeritageRepository heritageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return HeritageRepository(dio: dio);
}
