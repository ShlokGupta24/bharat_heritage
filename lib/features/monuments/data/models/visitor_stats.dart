import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor_stats.freezed.dart';
part 'visitor_stats.g.dart';

@freezed
abstract class VisitorStats with _$VisitorStats {
  const factory VisitorStats({
    @JsonKey(name: 'name_of_the_monument_') required String monumentName,
    @JsonKey(name: 'domestic___2019_20') int? domesticVisitors,
    @JsonKey(name: 'foreign___2019_20') int? foreignVisitors,
  }) = _VisitorStats;

  factory VisitorStats.fromJson(Map<String, dynamic> json) => _$VisitorStatsFromJson(json);
}