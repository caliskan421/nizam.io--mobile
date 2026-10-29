// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_side_effects.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingSideEffects {

@JsonKey(name: 'failed_messages') int get failedMessages;@JsonKey(name: 'event_failed') bool get eventFailed;
/// Create a copy of MeetingSideEffects
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingSideEffectsCopyWith<MeetingSideEffects> get copyWith => _$MeetingSideEffectsCopyWithImpl<MeetingSideEffects>(this as MeetingSideEffects, _$identity);

  /// Serializes this MeetingSideEffects to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingSideEffects;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingSideEffects&&(identical(other.failedMessages, _this.failedMessages) || other.failedMessages == _this.failedMessages)&&(identical(other.eventFailed, _this.eventFailed) || other.eventFailed == _this.eventFailed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingSideEffects;
  return Object.hash(runtimeType,_this.failedMessages,_this.eventFailed);
}

@override
String toString() {
  final _this = this as MeetingSideEffects;
  return 'MeetingSideEffects(failedMessages: ${_this.failedMessages}, eventFailed: ${_this.eventFailed})';
}


}

/// @nodoc
abstract mixin class $MeetingSideEffectsCopyWith<$Res>  {
  factory $MeetingSideEffectsCopyWith(MeetingSideEffects value, $Res Function(MeetingSideEffects) _then) = _$MeetingSideEffectsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'failed_messages') int failedMessages,@JsonKey(name: 'event_failed') bool eventFailed
});




}
/// @nodoc
class _$MeetingSideEffectsCopyWithImpl<$Res>
    implements $MeetingSideEffectsCopyWith<$Res> {
  _$MeetingSideEffectsCopyWithImpl(this._self, this._then);

  final MeetingSideEffects _self;
  final $Res Function(MeetingSideEffects) _then;

/// Create a copy of MeetingSideEffects
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? failedMessages = null,Object? eventFailed = null,}) {
  return _then(MeetingSideEffects(
failedMessages: null == failedMessages ? _self.failedMessages : failedMessages // ignore: cast_nullable_to_non_nullable
as int,eventFailed: null == eventFailed ? _self.eventFailed : eventFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingSideEffects].
extension MeetingSideEffectsPatterns on MeetingSideEffects {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingSideEffects value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingSideEffects() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingSideEffects value)  $default,){
final _that = this;
switch (_that) {
case _MeetingSideEffects():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingSideEffects value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingSideEffects() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'failed_messages')  int failedMessages, @JsonKey(name: 'event_failed')  bool eventFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingSideEffects() when $default != null:
return $default(_that.failedMessages,_that.eventFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'failed_messages')  int failedMessages, @JsonKey(name: 'event_failed')  bool eventFailed)  $default,) {final _that = this;
switch (_that) {
case _MeetingSideEffects():
return $default(_that.failedMessages,_that.eventFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'failed_messages')  int failedMessages, @JsonKey(name: 'event_failed')  bool eventFailed)?  $default,) {final _that = this;
switch (_that) {
case _MeetingSideEffects() when $default != null:
return $default(_that.failedMessages,_that.eventFailed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingSideEffects implements MeetingSideEffects {
  const _MeetingSideEffects({@JsonKey(name: 'failed_messages') required this.failedMessages, @JsonKey(name: 'event_failed') required this.eventFailed});
  factory _MeetingSideEffects.fromJson(Map<String, dynamic> json) => _$MeetingSideEffectsFromJson(json);

@override@JsonKey(name: 'failed_messages') final  int failedMessages;
@override@JsonKey(name: 'event_failed') final  bool eventFailed;

/// Create a copy of MeetingSideEffects
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingSideEffectsCopyWith<_MeetingSideEffects> get copyWith => __$MeetingSideEffectsCopyWithImpl<_MeetingSideEffects>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingSideEffectsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingSideEffects&&(identical(other.failedMessages, failedMessages) || other.failedMessages == failedMessages)&&(identical(other.eventFailed, eventFailed) || other.eventFailed == eventFailed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,failedMessages,eventFailed);
}

@override
String toString() {
    return 'MeetingSideEffects(failedMessages: $failedMessages, eventFailed: $eventFailed)';
}


}

/// @nodoc
abstract mixin class _$MeetingSideEffectsCopyWith<$Res> implements $MeetingSideEffectsCopyWith<$Res> {
  factory _$MeetingSideEffectsCopyWith(_MeetingSideEffects value, $Res Function(_MeetingSideEffects) _then) = __$MeetingSideEffectsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'failed_messages') int failedMessages,@JsonKey(name: 'event_failed') bool eventFailed
});




}
/// @nodoc
class __$MeetingSideEffectsCopyWithImpl<$Res>
    implements _$MeetingSideEffectsCopyWith<$Res> {
  __$MeetingSideEffectsCopyWithImpl(this._self, this._then);

  final _MeetingSideEffects _self;
  final $Res Function(_MeetingSideEffects) _then;

/// Create a copy of MeetingSideEffects
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failedMessages = null,Object? eventFailed = null,}) {
  return _then(_MeetingSideEffects(
failedMessages: null == failedMessages ? _self.failedMessages : failedMessages // ignore: cast_nullable_to_non_nullable
as int,eventFailed: null == eventFailed ? _self.eventFailed : eventFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
