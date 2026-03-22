import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument.dart';

part 'monuments_repository.g.dart';

class MonumentsRepository {
  final Dio dio;

  MonumentsRepository({required this.dio});

  Future<List<Monument>> fetchMonuments() async {
    const url =
        'https://data.unesco.org/api/explore/v2.1/catalog/datasets/whc001/records'
        '?limit=43'
        '&lang=en'
        '&refine=region%3A%22Asia%20and%20the%20Pacific%22'
        '&refine=states_names%3A%22India%22';

    try {
      final response = await dio.get(url);
      final records = response.data['results'] as List;
      return records.map((e) => Monument.fromUnescoJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch monuments: $e');
    }
  }
}

@riverpod
MonumentsRepository monumentsRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MonumentsRepository(dio: dio);
}