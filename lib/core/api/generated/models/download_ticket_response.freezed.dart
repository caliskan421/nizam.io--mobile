// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_ticket_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadTicketResponse {

/// 256 bit, base64url; 60 sn ömürlü, tek kullanımlık.
 String get ticket;/// Göreli tüketme yolu (`/v1/downloads/{ticket}`).
 String get url;@JsonKey(name: 'expires_at') DateTime get expiresAt;
/// Create a copy of DownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTicketResponseCopyWith<DownloadTicketResponse> get copyWith => _$DownloadTicketResponseCopyWithImpl<DownloadTicketResponse>(this as DownloadTicketResponse, _$identity);

  /// Serializes this DownloadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DownloadTicketResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTicketResponse&&(identical(other.ticket, _this.ticket) || other.ticket == _this.ticket)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DownloadTicketResponse;
  return Object.hash(runtimeType,_this.ticket,_this.url,_this.expiresAt);
}

@override
String toString() {
  final _this = this as DownloadTicketResponse;
  return 'DownloadTicketResponse(ticket: ${_this.ticket}, url: ${_this.url}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $DownloadTicketResponseCopyWith<$Res>  {
  factory $DownloadTicketResponseCopyWith(DownloadTicketResponse value, $Res Function(DownloadTicketResponse) _then) = _$DownloadTicketResponseCopyWithImpl;
@useResult
$Res call({
 String ticket, String url,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class _$DownloadTicketResponseCopyWithImpl<$Res>
    implements $DownloadTicketResponseCopyWith<$Res> {
  _$DownloadTicketResponseCopyWithImpl(this._self, this._then);

  final DownloadTicketResponse _self;
  final $Res Function(DownloadTicketResponse) _then;

/// Create a copy of DownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticket = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(DownloadTicketResponse(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadTicketResponse].
extension DownloadTicketResponsePatterns on DownloadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTicketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticket,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTicketResponse() when $default != null:
return $default(_that.ticket,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticket,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _DownloadTicketResponse():
return $default(_that.ticket,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticket,  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTicketResponse() when $default != null:
return $default(_that.ticket,_that.url,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTicketResponse implements DownloadTicketResponse {
  const _DownloadTicketResponse({required this.ticket, required this.url, @JsonKey(name: 'expires_at') required this.expiresAt});
  factory _DownloadTicketResponse.fromJson(Map<String, dynamic> json) => _$DownloadTicketResponseFromJson(json);

/// 256 bit, base64url; 60 sn ömürlü, tek kullanımlık.
@override final  String ticket;
/// Göreli tüketme yolu (`/v1/downloads/{ticket}`).
@override final  String url;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;

/// Create a copy of DownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTicketResponseCopyWith<_DownloadTicketResponse> get copyWith => __$DownloadTicketResponseCopyWithImpl<_DownloadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTicketResponse&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ticket,url,expiresAt);
}

@override
String toString() {
    return 'DownloadTicketResponse(ticket: $ticket, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$DownloadTicketResponseCopyWith<$Res> implements $DownloadTicketResponseCopyWith<$Res> {
  factory _$DownloadTicketResponseCopyWith(_DownloadTicketResponse value, $Res Function(_DownloadTicketResponse) _then) = __$DownloadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 String ticket, String url,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class __$DownloadTicketResponseCopyWithImpl<$Res>
    implements _$DownloadTicketResponseCopyWith<$Res> {
  __$DownloadTicketResponseCopyWithImpl(this._self, this._then);

  final _DownloadTicketResponse _self;
  final $Res Function(_DownloadTicketResponse) _then;

/// Create a copy of DownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(_DownloadTicketResponse(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
