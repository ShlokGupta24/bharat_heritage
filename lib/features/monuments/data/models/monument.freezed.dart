// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Monument {

 String get id; String get name; String get shortDescription; String? get imageUrl; String get dateInscribed; Coordinates get coordinates;
/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentCopyWith<Monument> get copyWith => _$MonumentCopyWithImpl<Monument>(this as Monument, _$identity);

  /// Serializes this Monument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Monument&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.dateInscribed, dateInscribed) || other.dateInscribed == dateInscribed)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shortDescription,imageUrl,dateInscribed,coordinates);

@override
String toString() {
  return 'Monument(id: $id, name: $name, shortDescription: $shortDescription, imageUrl: $imageUrl, dateInscribed: $dateInscribed, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $MonumentCopyWith<$Res>  {
  factory $MonumentCopyWith(Monument value, $Res Function(Monument) _then) = _$MonumentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String shortDescription, String? imageUrl, String dateInscribed, Coordinates coordinates
});


$CoordinatesCopyWith<$Res> get coordinates;

}
/// @nodoc
class _$MonumentCopyWithImpl<$Res>
    implements $MonumentCopyWith<$Res> {
  _$MonumentCopyWithImpl(this._self, this._then);

  final Monument _self;
  final $Res Function(Monument) _then;

/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? shortDescription = null,Object? imageUrl = freezed,Object? dateInscribed = null,Object? coordinates = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,dateInscribed: null == dateInscribed ? _self.dateInscribed : dateInscribed // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates,
  ));
}
/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res> get coordinates {
  
  return $CoordinatesCopyWith<$Res>(_self.coordinates, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [Monument].
extension MonumentPatterns on Monument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Monument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Monument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Monument value)  $default,){
final _that = this;
switch (_that) {
case _Monument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Monument value)?  $default,){
final _that = this;
switch (_that) {
case _Monument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String shortDescription,  String? imageUrl,  String dateInscribed,  Coordinates coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Monument() when $default != null:
return $default(_that.id,_that.name,_that.shortDescription,_that.imageUrl,_that.dateInscribed,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String shortDescription,  String? imageUrl,  String dateInscribed,  Coordinates coordinates)  $default,) {final _that = this;
switch (_that) {
case _Monument():
return $default(_that.id,_that.name,_that.shortDescription,_that.imageUrl,_that.dateInscribed,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String shortDescription,  String? imageUrl,  String dateInscribed,  Coordinates coordinates)?  $default,) {final _that = this;
switch (_that) {
case _Monument() when $default != null:
return $default(_that.id,_that.name,_that.shortDescription,_that.imageUrl,_that.dateInscribed,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Monument implements Monument {
  const _Monument({required this.id, required this.name, required this.shortDescription, this.imageUrl, required this.dateInscribed, required this.coordinates});
  factory _Monument.fromJson(Map<String, dynamic> json) => _$MonumentFromJson(json);

@override final  String id;
@override final  String name;
@override final  String shortDescription;
@override final  String? imageUrl;
@override final  String dateInscribed;
@override final  Coordinates coordinates;

/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentCopyWith<_Monument> get copyWith => __$MonumentCopyWithImpl<_Monument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Monument&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.dateInscribed, dateInscribed) || other.dateInscribed == dateInscribed)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shortDescription,imageUrl,dateInscribed,coordinates);

@override
String toString() {
  return 'Monument(id: $id, name: $name, shortDescription: $shortDescription, imageUrl: $imageUrl, dateInscribed: $dateInscribed, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$MonumentCopyWith<$Res> implements $MonumentCopyWith<$Res> {
  factory _$MonumentCopyWith(_Monument value, $Res Function(_Monument) _then) = __$MonumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String shortDescription, String? imageUrl, String dateInscribed, Coordinates coordinates
});


@override $CoordinatesCopyWith<$Res> get coordinates;

}
/// @nodoc
class __$MonumentCopyWithImpl<$Res>
    implements _$MonumentCopyWith<$Res> {
  __$MonumentCopyWithImpl(this._self, this._then);

  final _Monument _self;
  final $Res Function(_Monument) _then;

/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? shortDescription = null,Object? imageUrl = freezed,Object? dateInscribed = null,Object? coordinates = null,}) {
  return _then(_Monument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,dateInscribed: null == dateInscribed ? _self.dateInscribed : dateInscribed // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates,
  ));
}

/// Create a copy of Monument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res> get coordinates {
  
  return $CoordinatesCopyWith<$Res>(_self.coordinates, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// @nodoc
mixin _$Coordinates {

 double get lat; double get lon;
/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<Coordinates> get copyWith => _$CoordinatesCopyWithImpl<Coordinates>(this as Coordinates, _$identity);

  /// Serializes this Coordinates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coordinates&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Coordinates(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $CoordinatesCopyWith<$Res>  {
  factory $CoordinatesCopyWith(Coordinates value, $Res Function(Coordinates) _then) = _$CoordinatesCopyWithImpl;
@useResult
$Res call({
 double lat, double lon
});




}
/// @nodoc
class _$CoordinatesCopyWithImpl<$Res>
    implements $CoordinatesCopyWith<$Res> {
  _$CoordinatesCopyWithImpl(this._self, this._then);

  final Coordinates _self;
  final $Res Function(Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Coordinates].
extension CoordinatesPatterns on Coordinates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coordinates value)  $default,){
final _that = this;
switch (_that) {
case _Coordinates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coordinates value)?  $default,){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lon)  $default,) {final _that = this;
switch (_that) {
case _Coordinates():
return $default(_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lon)?  $default,) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coordinates implements Coordinates {
  const _Coordinates({required this.lat, required this.lon});
  factory _Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

@override final  double lat;
@override final  double lon;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatesCopyWith<_Coordinates> get copyWith => __$CoordinatesCopyWithImpl<_Coordinates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coordinates&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Coordinates(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$CoordinatesCopyWith<$Res> implements $CoordinatesCopyWith<$Res> {
  factory _$CoordinatesCopyWith(_Coordinates value, $Res Function(_Coordinates) _then) = __$CoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lon
});




}
/// @nodoc
class __$CoordinatesCopyWithImpl<$Res>
    implements _$CoordinatesCopyWith<$Res> {
  __$CoordinatesCopyWithImpl(this._self, this._then);

  final _Coordinates _self;
  final $Res Function(_Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_Coordinates(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
