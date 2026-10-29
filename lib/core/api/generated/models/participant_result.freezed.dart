// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantResult {

@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'user_id') String get userId;
/// Create a copy of ParticipantResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantResultCopyWith<ParticipantResult> get copyWith => _$ParticipantResultCopyWithImpl<ParticipantResult>(this as ParticipantResult, _$identity);

  /// Serializes this ParticipantResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParticipantResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantResult&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParticipantResult;
  return Object.hash(runtimeType,_this.meetingId,_this.userId);
}

@override
String toString() {
  final _this = this as ParticipantResult;
  return 'ParticipantResult(meetingId: ${_this.meetingId}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $ParticipantResultCopyWith<$Res>  {
  factory $ParticipantResultCopyWith(ParticipantResult value, $Res Function(ParticipantResult) _then) = _$ParticipantResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class _$ParticipantResultCopyWithImpl<$Res>
    implements $ParticipantResultCopyWith<$Res> {
  _$ParticipantResultCopyWithImpl(this._self, this._then);

  final ParticipantResult _self;
  final $Res Function(ParticipantResult) _then;

/// Create a copy of ParticipantResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? userId = null,}) {
  return _then(ParticipantResult(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantResult].
extension ParticipantResultPatterns on ParticipantResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantResult value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantResult value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'user_id')  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantResult() when $default != null:
return $default(_that.meetingId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'user_id')  String userId)  $default,) {final _that = this;
switch (_that) {
case _ParticipantResult():
return $default(_that.meetingId,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'user_id')  String userId)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantResult() when $default != null:
return $default(_that.meetingId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantResult implements ParticipantResult {
  const _ParticipantResult({@JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'user_id') required this.userId});
  factory _ParticipantResult.fromJson(Map<String, dynamic> json) => _$ParticipantResultFromJson(json);

@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override@JsonKey(name: 'user_id') final  String userId;

/// Create a copy of ParticipantResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantResultCopyWith<_ParticipantResult> get copyWith => __$ParticipantResultCopyWithImpl<_ParticipantResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantResult&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,userId);
}

@override
String toString() {
    return 'ParticipantResult(meetingId: $meetingId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$ParticipantResultCopyWith<$Res> implements $ParticipantResultCopyWith<$Res> {
  factory _$ParticipantResultCopyWith(_ParticipantResult value, $Res Function(_ParticipantResult) _then) = __$ParticipantResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class __$ParticipantResultCopyWithImpl<$Res>
    implements _$ParticipantResultCopyWith<$Res> {
  __$ParticipantResultCopyWithImpl(this._self, this._then);

  final _ParticipantResult _self;
  final $Res Function(_ParticipantResult) _then;

/// Create a copy of ParticipantResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? userId = null,}) {
  return _then(_ParticipantResult(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
