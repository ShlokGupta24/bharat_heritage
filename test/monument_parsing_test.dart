import 'package:flutter_test/flutter_test.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument.dart';

void main() {
  group('Monument.fromUnescoJson', () {
    test('should correctly parse a valid UNESCO API response record', () {
      final json = {
        "name_en": "Agra Fort",
        "short_description_en": "Near the gardens of the Taj Mahal...",
        "date_inscribed": "1983",
        "main_image_url": "https://whc.unesco.org/document/116895",
        "id_no": "251",
        "coordinates": {
          "lon": 78.021528,
          "lat": 27.179806
        }
      };

      final monument = Monument.fromUnescoJson(json);

      expect(monument.id, '251');
      expect(monument.name, 'Agra Fort');
      expect(monument.shortDescription, 'Near the gardens of the Taj Mahal...');
      expect(monument.dateInscribed, '1983');
      expect(monument.imageUrl, 'https://whc.unesco.org/document/116895');
      expect(monument.coordinates.lat, 27.179806);
      expect(monument.coordinates.lon, 78.021528);
    });

    test('should handle missing fields gracefully', () {
      final json = {
        "name_en": "Unknown",
        "id_no": 123
      };

      final monument = Monument.fromUnescoJson(json);

      expect(monument.id, '123');
      expect(monument.name, 'Unknown');
      expect(monument.shortDescription, '');
      expect(monument.imageUrl, isNull);
      expect(monument.coordinates.lat, 0.0);
      expect(monument.coordinates.lon, 0.0);
    });
  });
}
