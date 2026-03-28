// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PassportEntry _$PassportEntryFromJson(Map<String, dynamic> json) =>
    _PassportEntry(
      monumentId: json['monumentId'] as String,
      monumentName: json['monumentName'] as String,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PassportEntryToJson(_PassportEntry instance) =>
    <String, dynamic>{
      'monumentId': instance.monumentId,
      'monumentName': instance.monumentName,
      'visitedAt': instance.visitedAt.toIso8601String(),
      'notes': instance.notes,
    };
