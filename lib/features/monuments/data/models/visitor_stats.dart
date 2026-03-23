import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor_stats.freezed.dart';
part 'visitor_stats.g.dart';

@freezed
abstract class VisitorStats with _$VisitorStats {
  const factory VisitorStats({
    required String monumentName,
    int? domesticVisitors,
    int? foreignVisitors,
  }) = _VisitorStats;

  factory VisitorStats.fromJson(Map<String, dynamic> json) => _$VisitorStatsFromJson(json);
}