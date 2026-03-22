import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haversine_provider.g.dart';

class HaversineLogic {
  static const double earthRadiusKm = 6371.0;

  static double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    final dLat = _degreesToRadians(endLat - startLat);
    final dLng = _degreesToRadians(endLng - startLng);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLat)) * cos(_degreesToRadians(endLat)) *
        sin(dLng / 2) * sin(dLng / 2);
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static bool isWithin500m(double startLat, double startLng, double targetLat, double targetLng) {
    final distance = calculateDistance(startLat, startLng, targetLat, targetLng);
    return distance <= 0.5; // 500m = 0.5km
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

@riverpod
bool isNearMonument(Ref ref, double userLat, double userLng, double monumentLat, double monumentLng) {
  return HaversineLogic.isWithin500m(userLat, userLng, monumentLat, monumentLng);
}
