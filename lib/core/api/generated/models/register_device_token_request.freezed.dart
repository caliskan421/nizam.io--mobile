// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_device_token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterDeviceTokenRequest {

/// FCM kayıt belirteci (sır; hiçbir cevapta dönmez).
 String get token; RegisterDeviceTokenRequestPlatform get platform;
/// Create a copy of RegisterDeviceTokenRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterDeviceTokenRequestCopyWith<RegisterDeviceTokenRequest> get copyWith => _$RegisterDeviceTokenRequestCopyWithImpl<RegisterDeviceTokenRequest>(this as RegisterDeviceTokenRequest, _$identity);

  /// Serializes this RegisterDeviceTokenRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegisterDeviceTokenRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterDeviceTokenRequest&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.platform, _this.platform) || other.platform == _this.platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegisterDeviceTokenRequest;
  return Object.hash(runtimeType,_this.token,_this.platform);
}



}

/// @nodoc
abstract mixin class $RegisterDeviceTokenRequestCopyWith<$Res>  {
  factory $RegisterDeviceTokenRequestCopyWith(RegisterDeviceTokenRequest value, $Res Function(RegisterDeviceTokenRequest) _then) = _$RegisterDeviceTokenRequestCopyWithImpl;
@useResult
$Res call({
 String token, RegisterDeviceTokenRequestPlatform platform
});




}
/// @nodoc
class _$RegisterDeviceTokenRequestCopyWithImpl<$Res>
    implements $RegisterDeviceTokenRequestCopyWith<$Res> {
  _$RegisterDeviceTokenRequestCopyWithImpl(this._self, this._then);

  final RegisterDeviceTokenRequest _self;
  final $Res Function(RegisterDeviceTokenRequest) _then;

/// Create a copy of RegisterDeviceTokenRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? platform = null,}) {
  return _then(RegisterDeviceTokenRequest(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as RegisterDeviceTokenRequestPlatform,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterDeviceTokenRequest].
extension RegisterDeviceTokenRequestPatterns on RegisterDeviceTokenRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterDeviceTokenRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterDeviceTokenRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterDeviceTokenRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  RegisterDeviceTokenRequestPlatform platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest() when $default != null:
return $default(_that.token,_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  RegisterDeviceTokenRequestPlatform platform)  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest():
return $default(_that.token,_that.platform);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  RegisterDeviceTokenRequestPlatform platform)?  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceTokenRequest() when $default != null:
return $default(_that.token,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterDeviceTokenRequest implements RegisterDeviceTokenRequest {
  const _RegisterDeviceTokenRequest({required this.token, required this.platform});
  factory _RegisterDeviceTokenRequest.fromJson(Map<String, dynamic> json) => _$RegisterDeviceTokenRequestFromJson(json);

/// FCM kayıt belirteci (sır; hiçbir cevapta dönmez).
@override final  String token;
@override final  RegisterDeviceTokenRequestPlatform platform;

/// Create a copy of RegisterDeviceTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterDeviceTokenRequestCopyWith<_RegisterDeviceTokenRequest> get copyWith => __$RegisterDeviceTokenRequestCopyWithImpl<_RegisterDeviceTokenRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterDeviceTokenRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterDeviceTokenRequest&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,token,platform);
}



}

/// @nodoc
abstract mixin class _$RegisterDeviceTokenRequestCopyWith<$Res> implements $RegisterDeviceTokenRequestCopyWith<$Res> {
  factory _$RegisterDeviceTokenRequestCopyWith(_RegisterDeviceTokenRequest value, $Res Function(_RegisterDeviceTokenRequest) _then) = __$RegisterDeviceTokenRequestCopyWithImpl;
@override @useResult
$Res call({
 String token, RegisterDeviceTokenRequestPlatform platform
});




}
/// @nodoc
class __$RegisterDeviceTokenRequestCopyWithImpl<$Res>
    implements _$RegisterDeviceTokenRequestCopyWith<$Res> {
  __$RegisterDeviceTokenRequestCopyWithImpl(this._self, this._then);

  final _RegisterDeviceTokenRequest _self;
  final $Res Function(_RegisterDeviceTokenRequest) _then;

/// Create a copy of RegisterDeviceTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? platform = null,}) {
  return _then(_RegisterDeviceTokenRequest(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as RegisterDeviceTokenRequestPlatform,
  ));
}


}

// dart format on
