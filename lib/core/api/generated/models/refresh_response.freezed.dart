// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refresh_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RefreshResponse {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'expires_at') int get expiresAt;@JsonKey(name: 'refresh_expires_at') int get refreshExpiresAt; String? get token;@JsonKey(name: 'access_token') String? get accessToken;@JsonKey(name: 'refresh_token') String? get refreshToken;
/// Create a copy of RefreshResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshResponseCopyWith<RefreshResponse> get copyWith => _$RefreshResponseCopyWithImpl<RefreshResponse>(this as RefreshResponse, _$identity);

  /// Serializes this RefreshResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefreshResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshResponse&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.refreshExpiresAt, _this.refreshExpiresAt) || other.refreshExpiresAt == _this.refreshExpiresAt)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefreshResponse;
  return Object.hash(runtimeType,_this.accountId,_this.expiresAt,_this.refreshExpiresAt,_this.token,_this.accessToken,_this.refreshToken);
}

@override
String toString() {
  final _this = this as RefreshResponse;
  return 'RefreshResponse(accountId: ${_this.accountId}, expiresAt: ${_this.expiresAt}, refreshExpiresAt: ${_this.refreshExpiresAt}, token: ${_this.token}, accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken})';
}


}

/// @nodoc
abstract mixin class $RefreshResponseCopyWith<$Res>  {
  factory $RefreshResponseCopyWith(RefreshResponse value, $Res Function(RefreshResponse) _then) = _$RefreshResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'expires_at') int expiresAt,@JsonKey(name: 'refresh_expires_at') int refreshExpiresAt, String? token,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken
});




}
/// @nodoc
class _$RefreshResponseCopyWithImpl<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  _$RefreshResponseCopyWithImpl(this._self, this._then);

  final RefreshResponse _self;
  final $Res Function(RefreshResponse) _then;

/// Create a copy of RefreshResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? expiresAt = null,Object? refreshExpiresAt = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,}) {
  return _then(RefreshResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,refreshExpiresAt: null == refreshExpiresAt ? _self.refreshExpiresAt : refreshExpiresAt // ignore: cast_nullable_to_non_nullable
as int,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefreshResponse].
extension RefreshResponsePatterns on RefreshResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefreshResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefreshResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefreshResponse value)  $default,){
final _that = this;
switch (_that) {
case _RefreshResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefreshResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RefreshResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'refresh_expires_at')  int refreshExpiresAt,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefreshResponse() when $default != null:
return $default(_that.accountId,_that.expiresAt,_that.refreshExpiresAt,_that.token,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'refresh_expires_at')  int refreshExpiresAt,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)  $default,) {final _that = this;
switch (_that) {
case _RefreshResponse():
return $default(_that.accountId,_that.expiresAt,_that.refreshExpiresAt,_that.token,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'expires_at')  int expiresAt, @JsonKey(name: 'refresh_expires_at')  int refreshExpiresAt,  String? token, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _RefreshResponse() when $default != null:
return $default(_that.accountId,_that.expiresAt,_that.refreshExpiresAt,_that.token,_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefreshResponse implements RefreshResponse {
  const _RefreshResponse({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'refresh_expires_at') required this.refreshExpiresAt, this.token, @JsonKey(name: 'access_token') this.accessToken, @JsonKey(name: 'refresh_token') this.refreshToken});
  factory _RefreshResponse.fromJson(Map<String, dynamic> json) => _$RefreshResponseFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'expires_at') final  int expiresAt;
@override@JsonKey(name: 'refresh_expires_at') final  int refreshExpiresAt;
@override final  String? token;
@override@JsonKey(name: 'access_token') final  String? accessToken;
@override@JsonKey(name: 'refresh_token') final  String? refreshToken;

/// Create a copy of RefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshResponseCopyWith<_RefreshResponse> get copyWith => __$RefreshResponseCopyWithImpl<_RefreshResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefreshResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshResponse&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.refreshExpiresAt, refreshExpiresAt) || other.refreshExpiresAt == refreshExpiresAt)&&(identical(other.token, token) || other.token == token)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,expiresAt,refreshExpiresAt,token,accessToken,refreshToken);
}

@override
String toString() {
    return 'RefreshResponse(accountId: $accountId, expiresAt: $expiresAt, refreshExpiresAt: $refreshExpiresAt, token: $token, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$RefreshResponseCopyWith<$Res> implements $RefreshResponseCopyWith<$Res> {
  factory _$RefreshResponseCopyWith(_RefreshResponse value, $Res Function(_RefreshResponse) _then) = __$RefreshResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'expires_at') int expiresAt,@JsonKey(name: 'refresh_expires_at') int refreshExpiresAt, String? token,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken
});




}
/// @nodoc
class __$RefreshResponseCopyWithImpl<$Res>
    implements _$RefreshResponseCopyWith<$Res> {
  __$RefreshResponseCopyWithImpl(this._self, this._then);

  final _RefreshResponse _self;
  final $Res Function(_RefreshResponse) _then;

/// Create a copy of RefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? expiresAt = null,Object? refreshExpiresAt = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,}) {
  return _then(_RefreshResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,refreshExpiresAt: null == refreshExpiresAt ? _self.refreshExpiresAt : refreshExpiresAt // ignore: cast_nullable_to_non_nullable
as int,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
