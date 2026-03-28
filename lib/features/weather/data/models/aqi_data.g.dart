// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aqi_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AqiData _$AqiDataFromJson(Map<String, dynamic> json) => _AqiData(
  city: json['city'] as String,
  station: json['station'] as String,
  lastUpdate: json['lastUpdate'] as String,
  pollutantId: json['pollutantId'] as String,
  minValue: json['minValue'] as String,
  maxValue: json['maxValue'] as String,
  avgValue: json['avgValue'] as String,
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
);

Map<String, dynamic> _$AqiDataToJson(_AqiData instance) => <String, dynamic>{
  'city': instance.city,
  'station': instance.station,
  'lastUpdate': instance.lastUpdate,
  'pollutantId': instance.pollutantId,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'avgValue': instance.avgValue,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
