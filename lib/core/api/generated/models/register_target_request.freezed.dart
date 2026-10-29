// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_target_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterTargetRequest {

/// Push servisinin https uç noktası (izin listesindeki ana makine).
 String get endpoint; Keys get keys;@JsonKey(name: 'user_agent') String? get userAgent;
/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterTargetRequestCopyWith<RegisterTargetRequest> get copyWith => _$RegisterTargetRequestCopyWithImpl<RegisterTargetRequest>(this as RegisterTargetRequest, _$identity);

  /// Serializes this RegisterTargetRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegisterTargetRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterTargetRequest&&(identical(other.endpoint, _this.endpoint) || other.endpoint == _this.endpoint)&&(identical(other.keys, _this.keys) || other.keys == _this.keys)&&(identical(other.userAgent, _this.userAgent) || other.userAgent == _this.userAgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegisterTargetRequest;
  return Object.hash(runtimeType,_this.endpoint,_this.keys,_this.userAgent);
}

@override
String toString() {
  final _this = this as RegisterTargetRequest;
  return 'RegisterTargetRequest(endpoint: ${_this.endpoint}, keys: ${_this.keys}, userAgent: ${_this.userAgent})';
}


}

/// @nodoc
abstract mixin class $RegisterTargetRequestCopyWith<$Res>  {
  factory $RegisterTargetRequestCopyWith(RegisterTargetRequest value, $Res Function(RegisterTargetRequest) _then) = _$RegisterTargetRequestCopyWithImpl;
@useResult
$Res call({
 String endpoint, Keys keys,@JsonKey(name: 'user_agent') String? userAgent
});


$KeysCopyWith<$Res> get keys;

}
/// @nodoc
class _$RegisterTargetRequestCopyWithImpl<$Res>
    implements $RegisterTargetRequestCopyWith<$Res> {
  _$RegisterTargetRequestCopyWithImpl(this._self, this._then);

  final RegisterTargetRequest _self;
  final $Res Function(RegisterTargetRequest) _then;

/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? endpoint = null,Object? keys = null,Object? userAgent = freezed,}) {
  return _then(RegisterTargetRequest(
endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as Keys,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KeysCopyWith<$Res> get keys {
  
  return $KeysCopyWith<$Res>(_self.keys, (value) {
    return _then(_self.copyWith(keys: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterTargetRequest].
extension RegisterTargetRequestPatterns on RegisterTargetRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterTargetRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterTargetRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterTargetRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterTargetRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterTargetRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterTargetRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String endpoint,  Keys keys, @JsonKey(name: 'user_agent')  String? userAgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterTargetRequest() when $default != null:
return $default(_that.endpoint,_that.keys,_that.userAgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String endpoint,  Keys keys, @JsonKey(name: 'user_agent')  String? userAgent)  $default,) {final _that = this;
switch (_that) {
case _RegisterTargetRequest():
return $default(_that.endpoint,_that.keys,_that.userAgent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String endpoint,  Keys keys, @JsonKey(name: 'user_agent')  String? userAgent)?  $default,) {final _that = this;
switch (_that) {
case _RegisterTargetRequest() when $default != null:
return $default(_that.endpoint,_that.keys,_that.userAgent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterTargetRequest implements RegisterTargetRequest {
  const _RegisterTargetRequest({required this.endpoint, required this.keys, @JsonKey(name: 'user_agent') this.userAgent});
  factory _RegisterTargetRequest.fromJson(Map<String, dynamic> json) => _$RegisterTargetRequestFromJson(json);

/// Push servisinin https uç noktası (izin listesindeki ana makine).
@override final  String endpoint;
@override final  Keys keys;
@override@JsonKey(name: 'user_agent') final  String? userAgent;

/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterTargetRequestCopyWith<_RegisterTargetRequest> get copyWith => __$RegisterTargetRequestCopyWithImpl<_RegisterTargetRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterTargetRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterTargetRequest&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.keys, keys) || other.keys == keys)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,endpoint,keys,userAgent);
}

@override
String toString() {
    return 'RegisterTargetRequest(endpoint: $endpoint, keys: $keys, userAgent: $userAgent)';
}


}

/// @nodoc
abstract mixin class _$RegisterTargetRequestCopyWith<$Res> implements $RegisterTargetRequestCopyWith<$Res> {
  factory _$RegisterTargetRequestCopyWith(_RegisterTargetRequest value, $Res Function(_RegisterTargetRequest) _then) = __$RegisterTargetRequestCopyWithImpl;
@override @useResult
$Res call({
 String endpoint, Keys keys,@JsonKey(name: 'user_agent') String? userAgent
});


@override $KeysCopyWith<$Res> get keys;

}
/// @nodoc
class __$RegisterTargetRequestCopyWithImpl<$Res>
    implements _$RegisterTargetRequestCopyWith<$Res> {
  __$RegisterTargetRequestCopyWithImpl(this._self, this._then);

  final _RegisterTargetRequest _self;
  final $Res Function(_RegisterTargetRequest) _then;

/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? endpoint = null,Object? keys = null,Object? userAgent = freezed,}) {
  return _then(_RegisterTargetRequest(
endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as Keys,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RegisterTargetRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KeysCopyWith<$Res> get keys {
  
  return $KeysCopyWith<$Res>(_self.keys, (value) {
    return _then(_self.copyWith(keys: value));
  });
}
}

// dart format on
