import 'package:freezed_annotation/freezed_annotation.dart';

part 'aqi_data.freezed.dart';
part 'aqi_data.g.dart';

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
