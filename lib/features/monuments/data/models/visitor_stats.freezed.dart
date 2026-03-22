// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visitor_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisitorStats {

@JsonKey(name: 'name_of_the_monument_') String get monumentName;@JsonKey(name: 'domestic___2019_20') int? get domesticVisitors;@JsonKey(name: 'foreign___2019_20') int? get foreignVisitors;
/// Create a copy of VisitorStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitorStatsCopyWith<VisitorStats> get copyWith => _$VisitorStatsCopyWithImpl<VisitorStats>(this as VisitorStats, _$identity);

  /// Serializes this VisitorStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitorStats&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.domesticVisitors, domesticVisitors) || other.domesticVisitors == domesticVisitors)&&(identical(other.foreignVisitors, foreignVisitors) || other.foreignVisitors == foreignVisitors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monumentName,domesticVisitors,foreignVisitors);

@override
String toString() {
  return 'VisitorStats(monumentName: $monumentName, domesticVisitors: $domesticVisitors, foreignVisitors: $foreignVisitors)';
}


}

/// @nodoc
abstract mixin class $VisitorStatsCopyWith<$Res>  {
  factory $VisitorStatsCopyWith(VisitorStats value, $Res Function(VisitorStats) _then) = _$VisitorStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name_of_the_monument_') String monumentName,@JsonKey(name: 'domestic___2019_20') int? domesticVisitors,@JsonKey(name: 'foreign___2019_20') int? foreignVisitors
});




}
/// @nodoc
class _$VisitorStatsCopyWithImpl<$Res>
    implements $VisitorStatsCopyWith<$Res> {
  _$VisitorStatsCopyWithImpl(this._self, this._then);

  final VisitorStats _self;
  final $Res Function(VisitorStats) _then;

/// Create a copy of VisitorStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentName = null,Object? domesticVisitors = freezed,Object? foreignVisitors = freezed,}) {
  return _then(_self.copyWith(
monumentName: null == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String,domesticVisitors: freezed == domesticVisitors ? _self.domesticVisitors : domesticVisitors // ignore: cast_nullable_to_non_nullable
as int?,foreignVisitors: freezed == foreignVisitors ? _self.foreignVisitors : foreignVisitors // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitorStats].
extension VisitorStatsPatterns on VisitorStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitorStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitorStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitorStats value)  $default,){
final _that = this;
switch (_that) {
case _VisitorStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitorStats value)?  $default,){
final _that = this;
switch (_that) {
case _VisitorStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name_of_the_monument_')  String monumentName, @JsonKey(name: 'domestic___2019_20')  int? domesticVisitors, @JsonKey(name: 'foreign___2019_20')  int? foreignVisitors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitorStats() when $default != null:
return $default(_that.monumentName,_that.domesticVisitors,_that.foreignVisitors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name_of_the_monument_')  String monumentName, @JsonKey(name: 'domestic___2019_20')  int? domesticVisitors, @JsonKey(name: 'foreign___2019_20')  int? foreignVisitors)  $default,) {final _that = this;
switch (_that) {
case _VisitorStats():
return $default(_that.monumentName,_that.domesticVisitors,_that.foreignVisitors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name_of_the_monument_')  String monumentName, @JsonKey(name: 'domestic___2019_20')  int? domesticVisitors, @JsonKey(name: 'foreign___2019_20')  int? foreignVisitors)?  $default,) {final _that = this;
switch (_that) {
case _VisitorStats() when $default != null:
return $default(_that.monumentName,_that.domesticVisitors,_that.foreignVisitors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitorStats implements VisitorStats {
  const _VisitorStats({@JsonKey(name: 'name_of_the_monument_') required this.monumentName, @JsonKey(name: 'domestic___2019_20') this.domesticVisitors, @JsonKey(name: 'foreign___2019_20') this.foreignVisitors});
  factory _VisitorStats.fromJson(Map<String, dynamic> json) => _$VisitorStatsFromJson(json);

@override@JsonKey(name: 'name_of_the_monument_') final  String monumentName;
@override@JsonKey(name: 'domestic___2019_20') final  int? domesticVisitors;
@override@JsonKey(name: 'foreign___2019_20') final  int? foreignVisitors;

/// Create a copy of VisitorStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitorStatsCopyWith<_VisitorStats> get copyWith => __$VisitorStatsCopyWithImpl<_VisitorStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitorStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitorStats&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.domesticVisitors, domesticVisitors) || other.domesticVisitors == domesticVisitors)&&(identical(other.foreignVisitors, foreignVisitors) || other.foreignVisitors == foreignVisitors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monumentName,domesticVisitors,foreignVisitors);

@override
String toString() {
  return 'VisitorStats(monumentName: $monumentName, domesticVisitors: $domesticVisitors, foreignVisitors: $foreignVisitors)';
}


}

/// @nodoc
abstract mixin class _$VisitorStatsCopyWith<$Res> implements $VisitorStatsCopyWith<$Res> {
  factory _$VisitorStatsCopyWith(_VisitorStats value, $Res Function(_VisitorStats) _then) = __$VisitorStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name_of_the_monument_') String monumentName,@JsonKey(name: 'domestic___2019_20') int? domesticVisitors,@JsonKey(name: 'foreign___2019_20') int? foreignVisitors
});




}
/// @nodoc
class __$VisitorStatsCopyWithImpl<$Res>
    implements _$VisitorStatsCopyWith<$Res> {
  __$VisitorStatsCopyWithImpl(this._self, this._then);

  final _VisitorStats _self;
  final $Res Function(_VisitorStats) _then;

/// Create a copy of VisitorStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentName = null,Object? domesticVisitors = freezed,Object? foreignVisitors = freezed,}) {
  return _then(_VisitorStats(
monumentName: null == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String,domesticVisitors: freezed == domesticVisitors ? _self.domesticVisitors : domesticVisitors // ignore: cast_nullable_to_non_nullable
as int?,foreignVisitors: freezed == foreignVisitors ? _self.foreignVisitors : foreignVisitors // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
