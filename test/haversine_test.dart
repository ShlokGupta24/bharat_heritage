import 'package:flutter_test/flutter_test.dart';
import 'package:bharat_heritage/features/passport/domain/haversine_provider.dart';

void main() {
  group('Haversine Logic Tests', () {
    test('Distance between same points should be 0', () {
      final distance = HaversineLogic.calculateDistance(28.6139, 77.2090, 28.6139, 77.2090);
      expect(distance, 0.0);
    });

    test('Distance between New Delhi and Agra (approx 176 km)', () {
      // New Delhi: 28.6139, 77.2090
      // Agra: 27.1767, 78.0081
      final distance = HaversineLogic.calculateDistance(28.6139, 77.2090, 27.1767, 78.0081);
      expect(distance, closeTo(176.0, 5.0)); // Should be around 176km with a 5km tolerance
    });

    test('isWithin500m logic returns true for same coordinates', () {
      final result = HaversineLogic.isWithin500m(28.6139, 77.2090, 28.6139, 77.2090);
      expect(result, isTrue);
    });

    test('isWithin500m logic returns false for far coordinates', () {
      final result = HaversineLogic.isWithin500m(28.6139, 77.2090, 27.1767, 78.0081);
      expect(result, isFalse);
    });

    test('isWithin500m returns true for coordinates offset by ~100 meters', () {
      // Offset by roughly 0.001 degrees lat is ~111 meters
      final result = HaversineLogic.isWithin500m(28.6139, 77.2090, 28.6148, 77.2090);
      expect(result, isTrue);
    });

    test('isWithin500m returns false for coordinates offset by ~600 meters', () {
      // Offset by roughly 0.006 degrees lat is ~666 meters
      final result = HaversineLogic.isWithin500m(28.6139, 77.2090, 28.6199, 77.2090);
      expect(result, isFalse);
    });
  });
}
