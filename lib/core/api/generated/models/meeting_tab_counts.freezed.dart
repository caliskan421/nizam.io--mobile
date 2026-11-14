// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_tab_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingTabCounts {

 int get upcoming; int get past;/// Programın silinmiş toplantı sayısı (`GET /v1/meetings/deleted` kümesi; süzgeç almaz). Yalnız şirket yöneticisinde dolu, diğer rollerde null.
 int? get deleted;
/// Create a copy of MeetingTabCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingTabCountsCopyWith<MeetingTabCounts> get copyWith => _$MeetingTabCountsCopyWithImpl<MeetingTabCounts>(this as MeetingTabCounts, _$identity);

  /// Serializes this MeetingTabCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingTabCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingTabCounts&&(identical(other.upcoming, _this.upcoming) || other.upcoming == _this.upcoming)&&(identical(other.past, _this.past) || other.past == _this.past)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingTabCounts;
  return Object.hash(runtimeType,_this.upcoming,_this.past,_this.deleted);
}

@override
String toString() {
  final _this = this as MeetingTabCounts;
  return 'MeetingTabCounts(upcoming: ${_this.upcoming}, past: ${_this.past}, deleted: ${_this.deleted})';
}


}

/// @nodoc
abstract mixin class $MeetingTabCountsCopyWith<$Res>  {
  factory $MeetingTabCountsCopyWith(MeetingTabCounts value, $Res Function(MeetingTabCounts) _then) = _$MeetingTabCountsCopyWithImpl;
@useResult
$Res call({
 int upcoming, int past, int? deleted
});




}
/// @nodoc
class _$MeetingTabCountsCopyWithImpl<$Res>
    implements $MeetingTabCountsCopyWith<$Res> {
  _$MeetingTabCountsCopyWithImpl(this._self, this._then);

  final MeetingTabCounts _self;
  final $Res Function(MeetingTabCounts) _then;

/// Create a copy of MeetingTabCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upcoming = null,Object? past = null,Object? deleted = freezed,}) {
  return _then(MeetingTabCounts(
upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as int,deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingTabCounts].
extension MeetingTabCountsPatterns on MeetingTabCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingTabCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingTabCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingTabCounts value)  $default,){
final _that = this;
switch (_that) {
case _MeetingTabCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingTabCounts value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingTabCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int upcoming,  int past,  int? deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingTabCounts() when $default != null:
return $default(_that.upcoming,_that.past,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int upcoming,  int past,  int? deleted)  $default,) {final _that = this;
switch (_that) {
case _MeetingTabCounts():
return $default(_that.upcoming,_that.past,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int upcoming,  int past,  int? deleted)?  $default,) {final _that = this;
switch (_that) {
case _MeetingTabCounts() when $default != null:
return $default(_that.upcoming,_that.past,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingTabCounts implements MeetingTabCounts {
  const _MeetingTabCounts({required this.upcoming, required this.past, required this.deleted});
  factory _MeetingTabCounts.fromJson(Map<String, dynamic> json) => _$MeetingTabCountsFromJson(json);

@override final  int upcoming;
@override final  int past;
/// Programın silinmiş toplantı sayısı (`GET /v1/meetings/deleted` kümesi; süzgeç almaz). Yalnız şirket yöneticisinde dolu, diğer rollerde null.
@override final  int? deleted;

/// Create a copy of MeetingTabCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingTabCountsCopyWith<_MeetingTabCounts> get copyWith => __$MeetingTabCountsCopyWithImpl<_MeetingTabCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingTabCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingTabCounts&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming)&&(identical(other.past, past) || other.past == past)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,upcoming,past,deleted);
}

@override
String toString() {
    return 'MeetingTabCounts(upcoming: $upcoming, past: $past, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$MeetingTabCountsCopyWith<$Res> implements $MeetingTabCountsCopyWith<$Res> {
  factory _$MeetingTabCountsCopyWith(_MeetingTabCounts value, $Res Function(_MeetingTabCounts) _then) = __$MeetingTabCountsCopyWithImpl;
@override @useResult
$Res call({
 int upcoming, int past, int? deleted
});




}
/// @nodoc
class __$MeetingTabCountsCopyWithImpl<$Res>
    implements _$MeetingTabCountsCopyWith<$Res> {
  __$MeetingTabCountsCopyWithImpl(this._self, this._then);

  final _MeetingTabCounts _self;
  final $Res Function(_MeetingTabCounts) _then;

/// Create a copy of MeetingTabCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upcoming = null,Object? past = null,Object? deleted = freezed,}) {
  return _then(_MeetingTabCounts(
upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as int,deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
