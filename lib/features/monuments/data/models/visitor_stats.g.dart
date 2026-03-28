// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitorStats _$VisitorStatsFromJson(Map<String, dynamic> json) =>
    _VisitorStats(
      monumentName: json['monumentName'] as String,
      domesticVisitors: (json['domesticVisitors'] as num?)?.toInt(),
      foreignVisitors: (json['foreignVisitors'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VisitorStatsToJson(_VisitorStats instance) =>
    <String, dynamic>{
      'monumentName': instance.monumentName,
      'domesticVisitors': instance.domesticVisitors,
      'foreignVisitors': instance.foreignVisitors,
    };
