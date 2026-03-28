// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passport_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PassportEntry {

 String get monumentId; String get monumentName; DateTime get visitedAt; String? get notes;
/// Create a copy of PassportEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassportEntryCopyWith<PassportEntry> get copyWith => _$PassportEntryCopyWithImpl<PassportEntry>(this as PassportEntry, _$identity);

  /// Serializes this PassportEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PassportEntry&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monumentId,monumentName,visitedAt,notes);

@override
String toString() {
  return 'PassportEntry(monumentId: $monumentId, monumentName: $monumentName, visitedAt: $visitedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $PassportEntryCopyWith<$Res>  {
  factory $PassportEntryCopyWith(PassportEntry value, $Res Function(PassportEntry) _then) = _$PassportEntryCopyWithImpl;
@useResult
$Res call({
 String monumentId, String monumentName, DateTime visitedAt, String? notes
});




}
/// @nodoc
class _$PassportEntryCopyWithImpl<$Res>
    implements $PassportEntryCopyWith<$Res> {
  _$PassportEntryCopyWithImpl(this._self, this._then);

  final PassportEntry _self;
  final $Res Function(PassportEntry) _then;

/// Create a copy of PassportEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? monumentName = null,Object? visitedAt = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,monumentName: null == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PassportEntry].
extension PassportEntryPatterns on PassportEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PassportEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PassportEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PassportEntry value)  $default,){
final _that = this;
switch (_that) {
case _PassportEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PassportEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PassportEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  String monumentName,  DateTime visitedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PassportEntry() when $default != null:
return $default(_that.monumentId,_that.monumentName,_that.visitedAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  String monumentName,  DateTime visitedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _PassportEntry():
return $default(_that.monumentId,_that.monumentName,_that.visitedAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  String monumentName,  DateTime visitedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _PassportEntry() when $default != null:
return $default(_that.monumentId,_that.monumentName,_that.visitedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PassportEntry implements PassportEntry {
  const _PassportEntry({required this.monumentId, required this.monumentName, required this.visitedAt, this.notes});
  factory _PassportEntry.fromJson(Map<String, dynamic> json) => _$PassportEntryFromJson(json);

@override final  String monumentId;
@override final  String monumentName;
@override final  DateTime visitedAt;
@override final  String? notes;

/// Create a copy of PassportEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PassportEntryCopyWith<_PassportEntry> get copyWith => __$PassportEntryCopyWithImpl<_PassportEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PassportEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PassportEntry&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monumentId,monumentName,visitedAt,notes);

@override
String toString() {
  return 'PassportEntry(monumentId: $monumentId, monumentName: $monumentName, visitedAt: $visitedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$PassportEntryCopyWith<$Res> implements $PassportEntryCopyWith<$Res> {
  factory _$PassportEntryCopyWith(_PassportEntry value, $Res Function(_PassportEntry) _then) = __$PassportEntryCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, String monumentName, DateTime visitedAt, String? notes
});




}
/// @nodoc
class __$PassportEntryCopyWithImpl<$Res>
    implements _$PassportEntryCopyWith<$Res> {
  __$PassportEntryCopyWithImpl(this._self, this._then);

  final _PassportEntry _self;
  final $Res Function(_PassportEntry) _then;

/// Create a copy of PassportEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? monumentName = null,Object? visitedAt = null,Object? notes = freezed,}) {
  return _then(_PassportEntry(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,monumentName: null == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
