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
    // ignore: invalid_annotation_target
    @JsonKey(name: 'last_update') required String lastUpdate,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'pollutant_id') required String pollutantId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'min_value') required String minValue,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'max_value') required String maxValue,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'avg_value') required String avgValue,
    required String latitude,
    required String longitude,
  }) = _AqiData;

  factory AqiData.fromJson(Map<String, dynamic> json) => _$AqiDataFromJson(json);
}
