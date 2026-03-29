import 'package:freezed_annotation/freezed_annotation.dart';

part 'aqi_data.freezed.dart';
part 'aqi_data.g.dart';

@freezed
abstract class AqiData with _$AqiData {
  const factory AqiData({
    required String city,
    required String station,
    @JsonKey(name: 'last_update') required String lastUpdate,
    @JsonKey(name: 'pollutant_id') required String pollutantId,
    @JsonKey(name: 'min_value') required String minValue,
    @JsonKey(name: 'max_value') required String maxValue,
    @JsonKey(name: 'avg_value') required String avgValue,
    required String latitude,
    required String longitude,
  }) = _AqiData;

  factory AqiData.fromJson(Map<String, dynamic> json) =>
      _$AqiDataFromJson(json);
}
