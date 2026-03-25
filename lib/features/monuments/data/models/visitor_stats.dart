import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor_stats.freezed.dart';
part 'visitor_stats.g.dart';

// NOTE: JSON field mapping is handled in visitor_stats.g.dart directly, as
// @JsonKey cannot be on Freezed factory constructor params.
// API fields: name_of_the_monument_ -> monumentName,
//             domestic___2019_20 -> domesticVisitors,
//             foreign___2019_20 -> foreignVisitors
@freezed
abstract class VisitorStats with _$VisitorStats {
  const factory VisitorStats({
    required String monumentName,
    int? domesticVisitors,
    int? foreignVisitors,
  }) = _VisitorStats;

  factory VisitorStats.fromJson(Map<String, dynamic> json) =>
      _$VisitorStatsFromJson(json);
}