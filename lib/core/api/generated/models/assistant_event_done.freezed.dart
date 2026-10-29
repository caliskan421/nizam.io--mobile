// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_done.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventDone {

@JsonKey(name: 'sohbet_id') String get sohbetId;
/// Create a copy of AssistantEventDone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventDoneCopyWith<AssistantEventDone> get copyWith => _$AssistantEventDoneCopyWithImpl<AssistantEventDone>(this as AssistantEventDone, _$identity);

  /// Serializes this AssistantEventDone to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventDone;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventDone&&(identical(other.sohbetId, _this.sohbetId) || other.sohbetId == _this.sohbetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventDone;
  return Object.hash(runtimeType,_this.sohbetId);
}

@override
String toString() {
  final _this = this as AssistantEventDone;
  return 'AssistantEventDone(sohbetId: ${_this.sohbetId})';
}


}

/// @nodoc
abstract mixin class $AssistantEventDoneCopyWith<$Res>  {
  factory $AssistantEventDoneCopyWith(AssistantEventDone value, $Res Function(AssistantEventDone) _then) = _$AssistantEventDoneCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'sohbet_id') String sohbetId
});




}
/// @nodoc
class _$AssistantEventDoneCopyWithImpl<$Res>
    implements $AssistantEventDoneCopyWith<$Res> {
  _$AssistantEventDoneCopyWithImpl(this._self, this._then);

  final AssistantEventDone _self;
  final $Res Function(AssistantEventDone) _then;

/// Create a copy of AssistantEventDone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sohbetId = null,}) {
  return _then(AssistantEventDone(
sohbetId: null == sohbetId ? _self.sohbetId : sohbetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventDone].
extension AssistantEventDonePatterns on AssistantEventDone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventDone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventDone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventDone value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventDone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventDone value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventDone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'sohbet_id')  String sohbetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventDone() when $default != null:
return $default(_that.sohbetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'sohbet_id')  String sohbetId)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventDone():
return $default(_that.sohbetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'sohbet_id')  String sohbetId)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventDone() when $default != null:
return $default(_that.sohbetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventDone implements AssistantEventDone {
  const _AssistantEventDone({@JsonKey(name: 'sohbet_id') required this.sohbetId});
  factory _AssistantEventDone.fromJson(Map<String, dynamic> json) => _$AssistantEventDoneFromJson(json);

@override@JsonKey(name: 'sohbet_id') final  String sohbetId;

/// Create a copy of AssistantEventDone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventDoneCopyWith<_AssistantEventDone> get copyWith => __$AssistantEventDoneCopyWithImpl<_AssistantEventDone>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventDoneToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventDone&&(identical(other.sohbetId, sohbetId) || other.sohbetId == sohbetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sohbetId);
}

@override
String toString() {
    return 'AssistantEventDone(sohbetId: $sohbetId)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventDoneCopyWith<$Res> implements $AssistantEventDoneCopyWith<$Res> {
  factory _$AssistantEventDoneCopyWith(_AssistantEventDone value, $Res Function(_AssistantEventDone) _then) = __$AssistantEventDoneCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'sohbet_id') String sohbetId
});




}
/// @nodoc
class __$AssistantEventDoneCopyWithImpl<$Res>
    implements _$AssistantEventDoneCopyWith<$Res> {
  __$AssistantEventDoneCopyWithImpl(this._self, this._then);

  final _AssistantEventDone _self;
  final $Res Function(_AssistantEventDone) _then;

/// Create a copy of AssistantEventDone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sohbetId = null,}) {
  return _then(_AssistantEventDone(
sohbetId: null == sohbetId ? _self.sohbetId : sohbetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
