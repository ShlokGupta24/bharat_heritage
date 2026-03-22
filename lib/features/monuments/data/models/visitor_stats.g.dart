// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitorStats _$VisitorStatsFromJson(Map<String, dynamic> json) =>
    _VisitorStats(
      monumentName: json['name_of_the_monument_'] as String,
      domesticVisitors: (json['domestic___2019_20'] as num?)?.toInt(),
      foreignVisitors: (json['foreign___2019_20'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VisitorStatsToJson(_VisitorStats instance) =>
    <String, dynamic>{
      'name_of_the_monument_': instance.monumentName,
      'domestic___2019_20': instance.domesticVisitors,
      'foreign___2019_20': instance.foreignVisitors,
    };
