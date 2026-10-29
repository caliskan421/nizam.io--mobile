// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingCreated {

 Meeting get meeting;/// Yazılamayan katılımcı kimlikleri.
@JsonKey(name: 'failed_participants') List<String>? get failedParticipants;@JsonKey(name: 'side_effects') MeetingSideEffects get sideEffects;
/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCreatedCopyWith<MeetingCreated> get copyWith => _$MeetingCreatedCopyWithImpl<MeetingCreated>(this as MeetingCreated, _$identity);

  /// Serializes this MeetingCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingCreated;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingCreated&&(identical(other.meeting, _this.meeting) || other.meeting == _this.meeting)&&const DeepCollectionEquality().equals(other.failedParticipants, _this.failedParticipants)&&(identical(other.sideEffects, _this.sideEffects) || other.sideEffects == _this.sideEffects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingCreated;
  return Object.hash(runtimeType,_this.meeting,const DeepCollectionEquality().hash(_this.failedParticipants),_this.sideEffects);
}

@override
String toString() {
  final _this = this as MeetingCreated;
  return 'MeetingCreated(meeting: ${_this.meeting}, failedParticipants: ${_this.failedParticipants}, sideEffects: ${_this.sideEffects})';
}


}

/// @nodoc
abstract mixin class $MeetingCreatedCopyWith<$Res>  {
  factory $MeetingCreatedCopyWith(MeetingCreated value, $Res Function(MeetingCreated) _then) = _$MeetingCreatedCopyWithImpl;
@useResult
$Res call({
 Meeting meeting,@JsonKey(name: 'failed_participants') List<String>? failedParticipants,@JsonKey(name: 'side_effects') MeetingSideEffects sideEffects
});


$MeetingCopyWith<$Res> get meeting;$MeetingSideEffectsCopyWith<$Res> get sideEffects;

}
/// @nodoc
class _$MeetingCreatedCopyWithImpl<$Res>
    implements $MeetingCreatedCopyWith<$Res> {
  _$MeetingCreatedCopyWithImpl(this._self, this._then);

  final MeetingCreated _self;
  final $Res Function(MeetingCreated) _then;

/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meeting = null,Object? failedParticipants = freezed,Object? sideEffects = null,}) {
  return _then(MeetingCreated(
meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as Meeting,failedParticipants: freezed == failedParticipants ? _self.failedParticipants : failedParticipants // ignore: cast_nullable_to_non_nullable
as List<String>?,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as MeetingSideEffects,
  ));
}
/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingCopyWith<$Res> get meeting {
  
  return $MeetingCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSideEffectsCopyWith<$Res> get sideEffects {
  
  return $MeetingSideEffectsCopyWith<$Res>(_self.sideEffects, (value) {
    return _then(_self.copyWith(sideEffects: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingCreated].
extension MeetingCreatedPatterns on MeetingCreated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingCreated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingCreated value)  $default,){
final _that = this;
switch (_that) {
case _MeetingCreated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingCreated value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingCreated() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Meeting meeting, @JsonKey(name: 'failed_participants')  List<String>? failedParticipants, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingCreated() when $default != null:
return $default(_that.meeting,_that.failedParticipants,_that.sideEffects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Meeting meeting, @JsonKey(name: 'failed_participants')  List<String>? failedParticipants, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects)  $default,) {final _that = this;
switch (_that) {
case _MeetingCreated():
return $default(_that.meeting,_that.failedParticipants,_that.sideEffects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Meeting meeting, @JsonKey(name: 'failed_participants')  List<String>? failedParticipants, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects)?  $default,) {final _that = this;
switch (_that) {
case _MeetingCreated() when $default != null:
return $default(_that.meeting,_that.failedParticipants,_that.sideEffects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingCreated implements MeetingCreated {
  const _MeetingCreated({required this.meeting, @JsonKey(name: 'failed_participants') required  List<String>? failedParticipants, @JsonKey(name: 'side_effects') required this.sideEffects}): _failedParticipants = failedParticipants;
  factory _MeetingCreated.fromJson(Map<String, dynamic> json) => _$MeetingCreatedFromJson(json);

@override final  Meeting meeting;
/// Yazılamayan katılımcı kimlikleri.
 final  List<String>? _failedParticipants;
/// Yazılamayan katılımcı kimlikleri.
@override@JsonKey(name: 'failed_participants') List<String>? get failedParticipants {
  final value = _failedParticipants;
  if (value == null) return null;
  if (_failedParticipants is EqualUnmodifiableListView) return _failedParticipants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'side_effects') final  MeetingSideEffects sideEffects;

/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCreatedCopyWith<_MeetingCreated> get copyWith => __$MeetingCreatedCopyWithImpl<_MeetingCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingCreated&&(identical(other.meeting, meeting) || other.meeting == meeting)&&const DeepCollectionEquality().equals(other.failedParticipants, _failedParticipants)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meeting,const DeepCollectionEquality().hash(_failedParticipants),sideEffects);
}

@override
String toString() {
    return 'MeetingCreated(meeting: $meeting, failedParticipants: $failedParticipants, sideEffects: $sideEffects)';
}


}

/// @nodoc
abstract mixin class _$MeetingCreatedCopyWith<$Res> implements $MeetingCreatedCopyWith<$Res> {
  factory _$MeetingCreatedCopyWith(_MeetingCreated value, $Res Function(_MeetingCreated) _then) = __$MeetingCreatedCopyWithImpl;
@override @useResult
$Res call({
 Meeting meeting,@JsonKey(name: 'failed_participants') List<String>? failedParticipants,@JsonKey(name: 'side_effects') MeetingSideEffects sideEffects
});


@override $MeetingCopyWith<$Res> get meeting;@override $MeetingSideEffectsCopyWith<$Res> get sideEffects;

}
/// @nodoc
class __$MeetingCreatedCopyWithImpl<$Res>
    implements _$MeetingCreatedCopyWith<$Res> {
  __$MeetingCreatedCopyWithImpl(this._self, this._then);

  final _MeetingCreated _self;
  final $Res Function(_MeetingCreated) _then;

/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meeting = null,Object? failedParticipants = freezed,Object? sideEffects = null,}) {
  return _then(_MeetingCreated(
meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as Meeting,failedParticipants: freezed == failedParticipants ? _self._failedParticipants : failedParticipants // ignore: cast_nullable_to_non_nullable
as List<String>?,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as MeetingSideEffects,
  ));
}

/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingCopyWith<$Res> get meeting {
  
  return $MeetingCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}/// Create a copy of MeetingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSideEffectsCopyWith<$Res> get sideEffects {
  
  return $MeetingSideEffectsCopyWith<$Res>(_self.sideEffects, (value) {
    return _then(_self.copyWith(sideEffects: value));
  });
}
}

// dart format on
