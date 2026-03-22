// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aqi_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AqiData {

 String get city; String get station;@JsonKey(name: 'last_update') String get lastUpdate;@JsonKey(name: 'pollutant_id') String get pollutantId;@JsonKey(name: 'min_value') String get minValue;@JsonKey(name: 'max_value') String get maxValue;@JsonKey(name: 'avg_value') String get avgValue; String get latitude; String get longitude;
/// Create a copy of AqiData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AqiDataCopyWith<AqiData> get copyWith => _$AqiDataCopyWithImpl<AqiData>(this as AqiData, _$identity);

  /// Serializes this AqiData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AqiData&&(identical(other.city, city) || other.city == city)&&(identical(other.station, station) || other.station == station)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.pollutantId, pollutantId) || other.pollutantId == pollutantId)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.avgValue, avgValue) || other.avgValue == avgValue)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,station,lastUpdate,pollutantId,minValue,maxValue,avgValue,latitude,longitude);

@override
String toString() {
  return 'AqiData(city: $city, station: $station, lastUpdate: $lastUpdate, pollutantId: $pollutantId, minValue: $minValue, maxValue: $maxValue, avgValue: $avgValue, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $AqiDataCopyWith<$Res>  {
  factory $AqiDataCopyWith(AqiData value, $Res Function(AqiData) _then) = _$AqiDataCopyWithImpl;
@useResult
$Res call({
 String city, String station,@JsonKey(name: 'last_update') String lastUpdate,@JsonKey(name: 'pollutant_id') String pollutantId,@JsonKey(name: 'min_value') String minValue,@JsonKey(name: 'max_value') String maxValue,@JsonKey(name: 'avg_value') String avgValue, String latitude, String longitude
});




}
/// @nodoc
class _$AqiDataCopyWithImpl<$Res>
    implements $AqiDataCopyWith<$Res> {
  _$AqiDataCopyWithImpl(this._self, this._then);

  final AqiData _self;
  final $Res Function(AqiData) _then;

/// Create a copy of AqiData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = null,Object? station = null,Object? lastUpdate = null,Object? pollutantId = null,Object? minValue = null,Object? maxValue = null,Object? avgValue = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as String,pollutantId: null == pollutantId ? _self.pollutantId : pollutantId // ignore: cast_nullable_to_non_nullable
as String,minValue: null == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as String,maxValue: null == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as String,avgValue: null == avgValue ? _self.avgValue : avgValue // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as String,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AqiData].
extension AqiDataPatterns on AqiData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AqiData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AqiData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AqiData value)  $default,){
final _that = this;
switch (_that) {
case _AqiData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AqiData value)?  $default,){
final _that = this;
switch (_that) {
case _AqiData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String city,  String station, @JsonKey(name: 'last_update')  String lastUpdate, @JsonKey(name: 'pollutant_id')  String pollutantId, @JsonKey(name: 'min_value')  String minValue, @JsonKey(name: 'max_value')  String maxValue, @JsonKey(name: 'avg_value')  String avgValue,  String latitude,  String longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AqiData() when $default != null:
return $default(_that.city,_that.station,_that.lastUpdate,_that.pollutantId,_that.minValue,_that.maxValue,_that.avgValue,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String city,  String station, @JsonKey(name: 'last_update')  String lastUpdate, @JsonKey(name: 'pollutant_id')  String pollutantId, @JsonKey(name: 'min_value')  String minValue, @JsonKey(name: 'max_value')  String maxValue, @JsonKey(name: 'avg_value')  String avgValue,  String latitude,  String longitude)  $default,) {final _that = this;
switch (_that) {
case _AqiData():
return $default(_that.city,_that.station,_that.lastUpdate,_that.pollutantId,_that.minValue,_that.maxValue,_that.avgValue,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String city,  String station, @JsonKey(name: 'last_update')  String lastUpdate, @JsonKey(name: 'pollutant_id')  String pollutantId, @JsonKey(name: 'min_value')  String minValue, @JsonKey(name: 'max_value')  String maxValue, @JsonKey(name: 'avg_value')  String avgValue,  String latitude,  String longitude)?  $default,) {final _that = this;
switch (_that) {
case _AqiData() when $default != null:
return $default(_that.city,_that.station,_that.lastUpdate,_that.pollutantId,_that.minValue,_that.maxValue,_that.avgValue,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AqiData implements AqiData {
  const _AqiData({required this.city, required this.station, @JsonKey(name: 'last_update') required this.lastUpdate, @JsonKey(name: 'pollutant_id') required this.pollutantId, @JsonKey(name: 'min_value') required this.minValue, @JsonKey(name: 'max_value') required this.maxValue, @JsonKey(name: 'avg_value') required this.avgValue, required this.latitude, required this.longitude});
  factory _AqiData.fromJson(Map<String, dynamic> json) => _$AqiDataFromJson(json);

@override final  String city;
@override final  String station;
@override@JsonKey(name: 'last_update') final  String lastUpdate;
@override@JsonKey(name: 'pollutant_id') final  String pollutantId;
@override@JsonKey(name: 'min_value') final  String minValue;
@override@JsonKey(name: 'max_value') final  String maxValue;
@override@JsonKey(name: 'avg_value') final  String avgValue;
@override final  String latitude;
@override final  String longitude;

/// Create a copy of AqiData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AqiDataCopyWith<_AqiData> get copyWith => __$AqiDataCopyWithImpl<_AqiData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AqiDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AqiData&&(identical(other.city, city) || other.city == city)&&(identical(other.station, station) || other.station == station)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.pollutantId, pollutantId) || other.pollutantId == pollutantId)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.avgValue, avgValue) || other.avgValue == avgValue)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,station,lastUpdate,pollutantId,minValue,maxValue,avgValue,latitude,longitude);

@override
String toString() {
  return 'AqiData(city: $city, station: $station, lastUpdate: $lastUpdate, pollutantId: $pollutantId, minValue: $minValue, maxValue: $maxValue, avgValue: $avgValue, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$AqiDataCopyWith<$Res> implements $AqiDataCopyWith<$Res> {
  factory _$AqiDataCopyWith(_AqiData value, $Res Function(_AqiData) _then) = __$AqiDataCopyWithImpl;
@override @useResult
$Res call({
 String city, String station,@JsonKey(name: 'last_update') String lastUpdate,@JsonKey(name: 'pollutant_id') String pollutantId,@JsonKey(name: 'min_value') String minValue,@JsonKey(name: 'max_value') String maxValue,@JsonKey(name: 'avg_value') String avgValue, String latitude, String longitude
});




}
/// @nodoc
class __$AqiDataCopyWithImpl<$Res>
    implements _$AqiDataCopyWith<$Res> {
  __$AqiDataCopyWithImpl(this._self, this._then);

  final _AqiData _self;
  final $Res Function(_AqiData) _then;

/// Create a copy of AqiData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = null,Object? station = null,Object? lastUpdate = null,Object? pollutantId = null,Object? minValue = null,Object? maxValue = null,Object? avgValue = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_AqiData(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as String,pollutantId: null == pollutantId ? _self.pollutantId : pollutantId // ignore: cast_nullable_to_non_nullable
as String,minValue: null == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as String,maxValue: null == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as String,avgValue: null == avgValue ? _self.avgValue : avgValue // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as String,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
