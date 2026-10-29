// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conference_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConferenceToken {

 String get token;/// İstemcinin bağlanacağı genel adres (wss).
 String get url;@JsonKey(name: 'expires_at') DateTime get expiresAt;/// host: yönetici ve toplantıya bağlı departmanın koordinatörü; speaker: toplantıyı gören üye.
 ConferenceTokenRole get role;
/// Create a copy of ConferenceToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConferenceTokenCopyWith<ConferenceToken> get copyWith => _$ConferenceTokenCopyWithImpl<ConferenceToken>(this as ConferenceToken, _$identity);

  /// Serializes this ConferenceToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConferenceToken;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConferenceToken&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConferenceToken;
  return Object.hash(runtimeType,_this.token,_this.url,_this.expiresAt,_this.role);
}



}

/// @nodoc
abstract mixin class $ConferenceTokenCopyWith<$Res>  {
  factory $ConferenceTokenCopyWith(ConferenceToken value, $Res Function(ConferenceToken) _then) = _$ConferenceTokenCopyWithImpl;
@useResult
$Res call({
 String token, String url,@JsonKey(name: 'expires_at') DateTime expiresAt, ConferenceTokenRole role
});




}
/// @nodoc
class _$ConferenceTokenCopyWithImpl<$Res>
    implements $ConferenceTokenCopyWith<$Res> {
  _$ConferenceTokenCopyWithImpl(this._self, this._then);

  final ConferenceToken _self;
  final $Res Function(ConferenceToken) _then;

/// Create a copy of ConferenceToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? url = null,Object? expiresAt = null,Object? role = null,}) {
  return _then(ConferenceToken(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ConferenceTokenRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ConferenceToken].
extension ConferenceTokenPatterns on ConferenceToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConferenceToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConferenceToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConferenceToken value)  $default,){
final _that = this;
switch (_that) {
case _ConferenceToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConferenceToken value)?  $default,){
final _that = this;
switch (_that) {
case _ConferenceToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt,  ConferenceTokenRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConferenceToken() when $default != null:
return $default(_that.token,_that.url,_that.expiresAt,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt,  ConferenceTokenRole role)  $default,) {final _that = this;
switch (_that) {
case _ConferenceToken():
return $default(_that.token,_that.url,_that.expiresAt,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt,  ConferenceTokenRole role)?  $default,) {final _that = this;
switch (_that) {
case _ConferenceToken() when $default != null:
return $default(_that.token,_that.url,_that.expiresAt,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConferenceToken implements ConferenceToken {
  const _ConferenceToken({required this.token, required this.url, @JsonKey(name: 'expires_at') required this.expiresAt, required this.role});
  factory _ConferenceToken.fromJson(Map<String, dynamic> json) => _$ConferenceTokenFromJson(json);

@override final  String token;
/// İstemcinin bağlanacağı genel adres (wss).
@override final  String url;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;
/// host: yönetici ve toplantıya bağlı departmanın koordinatörü; speaker: toplantıyı gören üye.
@override final  ConferenceTokenRole role;

/// Create a copy of ConferenceToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConferenceTokenCopyWith<_ConferenceToken> get copyWith => __$ConferenceTokenCopyWithImpl<_ConferenceToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConferenceTokenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConferenceToken&&(identical(other.token, token) || other.token == token)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,token,url,expiresAt,role);
}



}

/// @nodoc
abstract mixin class _$ConferenceTokenCopyWith<$Res> implements $ConferenceTokenCopyWith<$Res> {
  factory _$ConferenceTokenCopyWith(_ConferenceToken value, $Res Function(_ConferenceToken) _then) = __$ConferenceTokenCopyWithImpl;
@override @useResult
$Res call({
 String token, String url,@JsonKey(name: 'expires_at') DateTime expiresAt, ConferenceTokenRole role
});




}
/// @nodoc
class __$ConferenceTokenCopyWithImpl<$Res>
    implements _$ConferenceTokenCopyWith<$Res> {
  __$ConferenceTokenCopyWithImpl(this._self, this._then);

  final _ConferenceToken _self;
  final $Res Function(_ConferenceToken) _then;

/// Create a copy of ConferenceToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? url = null,Object? expiresAt = null,Object? role = null,}) {
  return _then(_ConferenceToken(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ConferenceTokenRole,
  ));
}


}

// dart format on
