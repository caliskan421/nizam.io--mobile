// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_conference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LastConference {

 String get id;@JsonKey(name: 'started_at') DateTime get startedAt;/// Kapanma isteğinin (kullanıcı, toplantı silme) ya da sistem kapanışının anı.
@JsonKey(name: 'ended_at') DateTime get endedAt;@JsonKey(name: 'end_reason') LastConferenceEndReason get endReason;
/// Create a copy of LastConference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastConferenceCopyWith<LastConference> get copyWith => _$LastConferenceCopyWithImpl<LastConference>(this as LastConference, _$identity);

  /// Serializes this LastConference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LastConference;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastConference&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.endReason, _this.endReason) || other.endReason == _this.endReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LastConference;
  return Object.hash(runtimeType,_this.id,_this.startedAt,_this.endedAt,_this.endReason);
}

@override
String toString() {
  final _this = this as LastConference;
  return 'LastConference(id: ${_this.id}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, endReason: ${_this.endReason})';
}


}

/// @nodoc
abstract mixin class $LastConferenceCopyWith<$Res>  {
  factory $LastConferenceCopyWith(LastConference value, $Res Function(LastConference) _then) = _$LastConferenceCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'ended_at') DateTime endedAt,@JsonKey(name: 'end_reason') LastConferenceEndReason endReason
});




}
/// @nodoc
class _$LastConferenceCopyWithImpl<$Res>
    implements $LastConferenceCopyWith<$Res> {
  _$LastConferenceCopyWithImpl(this._self, this._then);

  final LastConference _self;
  final $Res Function(LastConference) _then;

/// Create a copy of LastConference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = null,Object? endReason = null,}) {
  return _then(LastConference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endReason: null == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as LastConferenceEndReason,
  ));
}

}


/// Adds pattern-matching-related methods to [LastConference].
extension LastConferencePatterns on LastConference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastConference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastConference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastConference value)  $default,){
final _that = this;
switch (_that) {
case _LastConference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastConference value)?  $default,){
final _that = this;
switch (_that) {
case _LastConference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ended_at')  DateTime endedAt, @JsonKey(name: 'end_reason')  LastConferenceEndReason endReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastConference() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.endReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ended_at')  DateTime endedAt, @JsonKey(name: 'end_reason')  LastConferenceEndReason endReason)  $default,) {final _that = this;
switch (_that) {
case _LastConference():
return $default(_that.id,_that.startedAt,_that.endedAt,_that.endReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ended_at')  DateTime endedAt, @JsonKey(name: 'end_reason')  LastConferenceEndReason endReason)?  $default,) {final _that = this;
switch (_that) {
case _LastConference() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.endReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastConference implements LastConference {
  const _LastConference({required this.id, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'ended_at') required this.endedAt, @JsonKey(name: 'end_reason') required this.endReason});
  factory _LastConference.fromJson(Map<String, dynamic> json) => _$LastConferenceFromJson(json);

@override final  String id;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
/// Kapanma isteğinin (kullanıcı, toplantı silme) ya da sistem kapanışının anı.
@override@JsonKey(name: 'ended_at') final  DateTime endedAt;
@override@JsonKey(name: 'end_reason') final  LastConferenceEndReason endReason;

/// Create a copy of LastConference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastConferenceCopyWith<_LastConference> get copyWith => __$LastConferenceCopyWithImpl<_LastConference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastConferenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastConference&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.endReason, endReason) || other.endReason == endReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,startedAt,endedAt,endReason);
}

@override
String toString() {
    return 'LastConference(id: $id, startedAt: $startedAt, endedAt: $endedAt, endReason: $endReason)';
}


}

/// @nodoc
abstract mixin class _$LastConferenceCopyWith<$Res> implements $LastConferenceCopyWith<$Res> {
  factory _$LastConferenceCopyWith(_LastConference value, $Res Function(_LastConference) _then) = __$LastConferenceCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'ended_at') DateTime endedAt,@JsonKey(name: 'end_reason') LastConferenceEndReason endReason
});




}
/// @nodoc
class __$LastConferenceCopyWithImpl<$Res>
    implements _$LastConferenceCopyWith<$Res> {
  __$LastConferenceCopyWithImpl(this._self, this._then);

  final _LastConference _self;
  final $Res Function(_LastConference) _then;

/// Create a copy of LastConference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = null,Object? endReason = null,}) {
  return _then(_LastConference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endReason: null == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as LastConferenceEndReason,
  ));
}


}

// dart format on
