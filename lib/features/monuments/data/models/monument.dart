import 'package:freezed_annotation/freezed_annotation.dart';

part 'monument.freezed.dart';
part 'monument.g.dart';

@freezed
abstract class Monument with _$Monument {
  const factory Monument({
    required String id,
    required String name,
    required String shortDescription,
    String? imageUrl,
    required String dateInscribed,
    required Coordinates coordinates,
  }) = _Monument;

  /// Used when loading from local static data (monument_repository.dart)
  factory Monument.fromJson(Map<String, dynamic> json) =>
      _$MonumentFromJson(json);

  /// Used when loading from the UNESCO Open Data API
  /// API response fields: id_no, name_en, short_description_en,
  /// date_inscribed, latitude, longitude, image_url (may be absent)
  factory Monument.fromUnescoJson(Map<String, dynamic> json) {
    // The API returns latitude/longitude as top-level doubles.
    // Fallback to 0.0 if missing to avoid null crashes.
    final lat = (json['latitude'] as num?)?.toDouble() ?? 0.0;
    final lon = (json['longitude'] as num?)?.toDouble() ?? 0.0;

    // id_no comes as an integer from the API, convert to String
    final id = (json['id_no'] ?? '').toString();

    // Some records have no image_url field — keep it nullable
    final imageUrl = json['image_url'] as String?;

    // date_inscribed is an integer year in the API (e.g. 1983)
    final dateInscribed = (json['date_inscribed'] ?? '').toString();

    return Monument(
      id: id,
      name: json['name_en'] as String? ?? 'Unknown Monument',
      shortDescription: json['short_description_en'] as String? ?? '',
      imageUrl: imageUrl,
      dateInscribed: dateInscribed,
      coordinates: Coordinates(lat: lat, lon: lon),
    );
  }
}

@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    required double lat,
    required double lon,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}