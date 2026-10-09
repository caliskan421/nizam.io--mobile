// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginResponse {

@JsonKey(name: 'account_id') String get accountId;/// Erişim/oturum belirtecinin bitişi (Unix saniyesi).
@JsonKey(name: 'expires_at') int get expiresAt;@JsonKey(name: 'force_password_change') bool get forcePasswordChange;/// Web oturum belirteci (yalnız web).
 String? get token;/// Mobil erişim belirteci (yalnız mobil).
@JsonKey(name: 'access_token') String? get accessToken;/// Mobil yenileme belirteci (yalnız mobil; web'de çerezdedir).
@JsonKey(name: 'refresh_token') String? get refreshToken;/// Yenileme belirtecinin bitişi (Unix saniyesi).
@JsonKey(name: 'refresh_expires_at') int? get refreshExpiresAt;
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseCopyWith<LoginResponse> get copyWith => _$LoginResponseCopyWithImpl<LoginResponse>(this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponse&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.forcePasswordChange, _this.forcePasswordChange) || other.forcePasswordChange == _this.forcePasswordChange)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.refreshExpiresAt, _this.refreshExpiresAt) || other.refreshExpiresAt == _this.refreshExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginResponse;
  return Object.hash(runtimeType,_this.accountId,_this.expiresAt,_this.forcePasswordChange,_this.token,_this.accessToken,_this.refreshToken,_this.refreshExpiresAt);
}

@override
String toString() {
  final _this = this as LoginResponse;
  return 'LoginResponse(accountId: ${_this.accountId}, expiresAt: ${_this.expiresAt}, forcePasswordChange: ${_this.forcePasswordChange}, token: ${_this.token}, accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, refreshExpiresAt: ${_this.refreshExpiresAt})';
}


}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res>  {
  factory $LoginResponseCopyWith(LoginResponse value, $Res Function(LoginResponse) _then) = _$LoginResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'expires_at') int expiresAt,@JsonKey(name: 'force_password_change') bool forcePasswordChange, String? token,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken,@JsonKey(name: 'refresh_expires_at') int? refreshExpiresAt
});




}
/// @nodoc
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? expiresAt = null,Object? forcePasswordChange = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,Object? refreshExpiresAt = freezed,}) {
  return _then(LoginResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,forcePasswordChange: null == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,refreshExpiresAt: freezed == refreshExpiresAt ? _self.refreshExpiresAt : refreshExpiresAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginResponse].
extension LoginResponsePatterns on LoginResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'force_password_change')  bool forcePasswordChange,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken, @JsonKey(name: 'refresh_expires_at')  int? refreshExpiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.accountId,_that.expiresAt,_that.forcePasswordChange,_that.token,_that.accessToken,_that.refreshToken,_that.refreshExpiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'force_password_change')  bool forcePasswordChange,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken, @JsonKey(name: 'refresh_expires_at')  int? refreshExpiresAt)  $default,) {final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that.accountId,_that.expiresAt,_that.forcePasswordChange,_that.token,_that.accessToken,_that.refreshToken,_that.refreshExpiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'force_password_change')  bool forcePasswordChange,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken, @JsonKey(name: 'refresh_expires_at')  int? refreshExpiresAt)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.accountId,_that.expiresAt,_that.forcePasswordChange,_that.token,_that.accessToken,_that.refreshToken,_that.refreshExpiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponse implements LoginResponse {
  const _LoginResponse({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'force_password_change') required this.forcePasswordChange, this.token, @JsonKey(name: 'access_token') this.accessToken, @JsonKey(name: 'refresh_token') this.refreshToken, @JsonKey(name: 'refresh_expires_at') this.refreshExpiresAt});
  factory _LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
/// Erişim/oturum belirtecinin bitişi (Unix saniyesi).
@override@JsonKey(name: 'expires_at') final  int expiresAt;
@override@JsonKey(name: 'force_password_change') final  bool forcePasswordChange;
/// Web oturum belirteci (yalnız web).
@override final  String? token;
/// Mobil erişim belirteci (yalnız mobil).
@override@JsonKey(name: 'access_token') final  String? accessToken;
/// Mobil yenileme belirteci (yalnız mobil; web'de çerezdedir).
@override@JsonKey(name: 'refresh_token') final  String? refreshToken;
/// Yenileme belirtecinin bitişi (Unix saniyesi).
@override@JsonKey(name: 'refresh_expires_at') final  int? refreshExpiresAt;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseCopyWith<_LoginResponse> get copyWith => __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponse&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.forcePasswordChange, forcePasswordChange) || other.forcePasswordChange == forcePasswordChange)&&(identical(other.token, token) || other.token == token)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshExpiresAt, refreshExpiresAt) || other.refreshExpiresAt == refreshExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,expiresAt,forcePasswordChange,token,accessToken,refreshToken,refreshExpiresAt);
}

@override
String toString() {
    return 'LoginResponse(accountId: $accountId, expiresAt: $expiresAt, forcePasswordChange: $forcePasswordChange, token: $token, accessToken: $accessToken, refreshToken: $refreshToken, refreshExpiresAt: $refreshExpiresAt)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res> implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(_LoginResponse value, $Res Function(_LoginResponse) _then) = __$LoginResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'expires_at') int expiresAt,@JsonKey(name: 'force_password_change') bool forcePasswordChange, String? token,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken,@JsonKey(name: 'refresh_expires_at') int? refreshExpiresAt
});




}
/// @nodoc
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? expiresAt = null,Object? forcePasswordChange = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,Object? refreshExpiresAt = freezed,}) {
  return _then(_LoginResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,forcePasswordChange: null == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,refreshExpiresAt: freezed == refreshExpiresAt ? _self.refreshExpiresAt : refreshExpiresAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
