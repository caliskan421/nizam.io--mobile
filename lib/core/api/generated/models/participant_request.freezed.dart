// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantRequest {

@JsonKey(name: 'user_id') String get userId;
/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantRequestCopyWith<ParticipantRequest> get copyWith => _$ParticipantRequestCopyWithImpl<ParticipantRequest>(this as ParticipantRequest, _$identity);

  /// Serializes this ParticipantRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParticipantRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantRequest&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParticipantRequest;
  return Object.hash(runtimeType,_this.userId);
}

@override
String toString() {
  final _this = this as ParticipantRequest;
  return 'ParticipantRequest(userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $ParticipantRequestCopyWith<$Res>  {
  factory $ParticipantRequestCopyWith(ParticipantRequest value, $Res Function(ParticipantRequest) _then) = _$ParticipantRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class _$ParticipantRequestCopyWithImpl<$Res>
    implements $ParticipantRequestCopyWith<$Res> {
  _$ParticipantRequestCopyWithImpl(this._self, this._then);

  final ParticipantRequest _self;
  final $Res Function(ParticipantRequest) _then;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,}) {
  return _then(ParticipantRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantRequest].
extension ParticipantRequestPatterns on ParticipantRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantRequest value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
return $default(_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId)  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequest():
return $default(_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
return $default(_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantRequest implements ParticipantRequest {
  const _ParticipantRequest({@JsonKey(name: 'user_id') required this.userId});
  factory _ParticipantRequest.fromJson(Map<String, dynamic> json) => _$ParticipantRequestFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantRequestCopyWith<_ParticipantRequest> get copyWith => __$ParticipantRequestCopyWithImpl<_ParticipantRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantRequest&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId);
}

@override
String toString() {
    return 'ParticipantRequest(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$ParticipantRequestCopyWith<$Res> implements $ParticipantRequestCopyWith<$Res> {
  factory _$ParticipantRequestCopyWith(_ParticipantRequest value, $Res Function(_ParticipantRequest) _then) = __$ParticipantRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class __$ParticipantRequestCopyWithImpl<$Res>
    implements _$ParticipantRequestCopyWith<$Res> {
  __$ParticipantRequestCopyWithImpl(this._self, this._then);

  final _ParticipantRequest _self;
  final $Res Function(_ParticipantRequest) _then;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(_ParticipantRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
