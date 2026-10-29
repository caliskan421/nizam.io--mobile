// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_lifecycle_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingLifecycleResult {

@JsonKey(name: 'meeting_id') String get meetingId; MeetingLifecycleResultStatus get status;
/// Create a copy of MeetingLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingLifecycleResultCopyWith<MeetingLifecycleResult> get copyWith => _$MeetingLifecycleResultCopyWithImpl<MeetingLifecycleResult>(this as MeetingLifecycleResult, _$identity);

  /// Serializes this MeetingLifecycleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingLifecycleResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingLifecycleResult&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingLifecycleResult;
  return Object.hash(runtimeType,_this.meetingId,_this.status);
}

@override
String toString() {
  final _this = this as MeetingLifecycleResult;
  return 'MeetingLifecycleResult(meetingId: ${_this.meetingId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MeetingLifecycleResultCopyWith<$Res>  {
  factory $MeetingLifecycleResultCopyWith(MeetingLifecycleResult value, $Res Function(MeetingLifecycleResult) _then) = _$MeetingLifecycleResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId, MeetingLifecycleResultStatus status
});




}
/// @nodoc
class _$MeetingLifecycleResultCopyWithImpl<$Res>
    implements $MeetingLifecycleResultCopyWith<$Res> {
  _$MeetingLifecycleResultCopyWithImpl(this._self, this._then);

  final MeetingLifecycleResult _self;
  final $Res Function(MeetingLifecycleResult) _then;

/// Create a copy of MeetingLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? status = null,}) {
  return _then(MeetingLifecycleResult(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingLifecycleResultStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingLifecycleResult].
extension MeetingLifecycleResultPatterns on MeetingLifecycleResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingLifecycleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingLifecycleResult value)  $default,){
final _that = this;
switch (_that) {
case _MeetingLifecycleResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingLifecycleResult value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId,  MeetingLifecycleResultStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingLifecycleResult() when $default != null:
return $default(_that.meetingId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId,  MeetingLifecycleResultStatus status)  $default,) {final _that = this;
switch (_that) {
case _MeetingLifecycleResult():
return $default(_that.meetingId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId,  MeetingLifecycleResultStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MeetingLifecycleResult() when $default != null:
return $default(_that.meetingId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingLifecycleResult implements MeetingLifecycleResult {
  const _MeetingLifecycleResult({@JsonKey(name: 'meeting_id') required this.meetingId, required this.status});
  factory _MeetingLifecycleResult.fromJson(Map<String, dynamic> json) => _$MeetingLifecycleResultFromJson(json);

@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override final  MeetingLifecycleResultStatus status;

/// Create a copy of MeetingLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingLifecycleResultCopyWith<_MeetingLifecycleResult> get copyWith => __$MeetingLifecycleResultCopyWithImpl<_MeetingLifecycleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingLifecycleResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingLifecycleResult&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,status);
}

@override
String toString() {
    return 'MeetingLifecycleResult(meetingId: $meetingId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MeetingLifecycleResultCopyWith<$Res> implements $MeetingLifecycleResultCopyWith<$Res> {
  factory _$MeetingLifecycleResultCopyWith(_MeetingLifecycleResult value, $Res Function(_MeetingLifecycleResult) _then) = __$MeetingLifecycleResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId, MeetingLifecycleResultStatus status
});




}
/// @nodoc
class __$MeetingLifecycleResultCopyWithImpl<$Res>
    implements _$MeetingLifecycleResultCopyWith<$Res> {
  __$MeetingLifecycleResultCopyWithImpl(this._self, this._then);

  final _MeetingLifecycleResult _self;
  final $Res Function(_MeetingLifecycleResult) _then;

/// Create a copy of MeetingLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? status = null,}) {
  return _then(_MeetingLifecycleResult(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingLifecycleResultStatus,
  ));
}


}

// dart format on
