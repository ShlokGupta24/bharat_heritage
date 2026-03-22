// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Monument _$MonumentFromJson(Map<String, dynamic> json) => _Monument(
  id: json['id'] as String,
  name: json['name'] as String,
  shortDescription: json['shortDescription'] as String,
  imageUrl: json['imageUrl'] as String?,
  dateInscribed: json['dateInscribed'] as String,
  coordinates: Coordinates.fromJson(
    json['coordinates'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$MonumentToJson(_Monument instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'shortDescription': instance.shortDescription,
  'imageUrl': instance.imageUrl,
  'dateInscribed': instance.dateInscribed,
  'coordinates': instance.coordinates,
};

_Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => _Coordinates(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(_Coordinates instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
