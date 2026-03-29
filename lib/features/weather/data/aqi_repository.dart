import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/core/network/dio_client.dart';
import 'models/aqi_data.dart';

part 'aqi_repository.g.dart';

class AqiRepository {
  final Dio dio;

  AqiRepository({required this.dio});

  Future<AqiData?> fetchAqiData(double lat, double lon) async {
    const url =
        'https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69'
        '?api-key=579b464db66ec23bdd000001bc8ddd549e7e466e55b288106bb080ed'
        '&format=json&limit=4000';
    try {
      final response = await dio.get(url);
      final records = response.data['records'] as List;
      final allAqi = records.map((e) => AqiData.fromJson(e)).toList();
      return _findNearest(allAqi, lat, lon);
    } catch (e) {
      return null;
    }
  }

  /// Groups records by station and keeps the highest sub-index pollutant
  /// for each station, which is the correct way to calculate Indian AQI.
  /// Then finds the nearest station to the monument's coordinates.
  AqiData? _findNearest(
      List<AqiData> data, double targetLat, double targetLon) {
    if (data.isEmpty) return null;

    // Aggregate: per-station, keep only the pollutant record with max avgValue
    final Map<String, AqiData> stationBest = {};
    for (final aqi in data) {
      // Skip records that have no parseable coordinates
      final lat = double.tryParse(aqi.latitude);
      final lon = double.tryParse(aqi.longitude);
      if (lat == null || lon == null) continue;

      final stationKey = '${aqi.station}_${aqi.latitude}_${aqi.longitude}';
      final existing = stationBest[stationKey];
      if (existing == null) {
        stationBest[stationKey] = aqi;
      } else {
        final existingVal = double.tryParse(existing.avgValue) ?? 0;
        final newVal = double.tryParse(aqi.avgValue) ?? 0;
        if (newVal > existingVal) {
          stationBest[stationKey] = aqi;
        }
      }
    }

    // Find the nearest station to the target coordinates
    AqiData? nearest;
    double minDistance = double.maxFinite;
    for (final aqi in stationBest.values) {
      final lat = double.tryParse(aqi.latitude)!;
      final lon = double.tryParse(aqi.longitude)!;
      final dist = _approxDistance(lat, lon, targetLat, targetLon);
      if (dist < minDistance) {
        minDistance = dist;
        nearest = aqi;
      }
    }
    return nearest;
  }

  double _approxDistance(
      double lat1, double lon1, double lat2, double lon2) {
    return (lat1 - lat2) * (lat1 - lat2) + (lon1 - lon2) * (lon1 - lon2);
  }
}

@riverpod
AqiRepository aqiRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AqiRepository(dio: dio);
}
