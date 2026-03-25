import 'package:freezed_annotation/freezed_annotation.dart';

part 'aqi_data.freezed.dart';
part 'aqi_data.g.dart';

// NOTE: JSON field mapping is handled in aqi_data.g.dart directly, as
// @JsonKey cannot be on Freezed factory constructor params.
// API field: last_update -> lastUpdate, pollutant_id -> pollutantId, etc.
@freezed
abstract class AqiData with _$AqiData {
  const factory AqiData({
    required String city,
    required String station,
    required String lastUpdate,
    required String pollutantId,
    required String minValue,
    required String maxValue,
    required String avgValue,
    required String latitude,
    required String longitude,
  }) = _AqiData;

  factory AqiData.fromJson(Map<String, dynamic> json) => _$AqiDataFromJson(json);
}
