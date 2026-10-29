// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_ticket_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadTicketRequest {

 DownloadTicketRequestMethod get method;/// Göreli yol + ham sorgu dizesi (ör. `/v1/files/{id}/download`).
 String get path;/// Yalnız POST hedefinde zorunlu JSON nesnesi (≤ 64 KiB); GET hedefinde gönderilmez.
 dynamic get body;
/// Create a copy of DownloadTicketRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTicketRequestCopyWith<DownloadTicketRequest> get copyWith => _$DownloadTicketRequestCopyWithImpl<DownloadTicketRequest>(this as DownloadTicketRequest, _$identity);

  /// Serializes this DownloadTicketRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DownloadTicketRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTicketRequest&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.path, _this.path) || other.path == _this.path)&&const DeepCollectionEquality().equals(other.body, _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DownloadTicketRequest;
  return Object.hash(runtimeType,_this.method,_this.path,const DeepCollectionEquality().hash(_this.body));
}

@override
String toString() {
  final _this = this as DownloadTicketRequest;
  return 'DownloadTicketRequest(method: ${_this.method}, path: ${_this.path}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $DownloadTicketRequestCopyWith<$Res>  {
  factory $DownloadTicketRequestCopyWith(DownloadTicketRequest value, $Res Function(DownloadTicketRequest) _then) = _$DownloadTicketRequestCopyWithImpl;
@useResult
$Res call({
 DownloadTicketRequestMethod method, String path, dynamic body
});




}
/// @nodoc
class _$DownloadTicketRequestCopyWithImpl<$Res>
    implements $DownloadTicketRequestCopyWith<$Res> {
  _$DownloadTicketRequestCopyWithImpl(this._self, this._then);

  final DownloadTicketRequest _self;
  final $Res Function(DownloadTicketRequest) _then;

/// Create a copy of DownloadTicketRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? path = null,Object? body = freezed,}) {
  return _then(DownloadTicketRequest(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as DownloadTicketRequestMethod,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadTicketRequest].
extension DownloadTicketRequestPatterns on DownloadTicketRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTicketRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTicketRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTicketRequest value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTicketRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTicketRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTicketRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DownloadTicketRequestMethod method,  String path,  dynamic body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTicketRequest() when $default != null:
return $default(_that.method,_that.path,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DownloadTicketRequestMethod method,  String path,  dynamic body)  $default,) {final _that = this;
switch (_that) {
case _DownloadTicketRequest():
return $default(_that.method,_that.path,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DownloadTicketRequestMethod method,  String path,  dynamic body)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTicketRequest() when $default != null:
return $default(_that.method,_that.path,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTicketRequest implements DownloadTicketRequest {
  const _DownloadTicketRequest({required this.method, required this.path, this.body});
  factory _DownloadTicketRequest.fromJson(Map<String, dynamic> json) => _$DownloadTicketRequestFromJson(json);

@override final  DownloadTicketRequestMethod method;
/// Göreli yol + ham sorgu dizesi (ör. `/v1/files/{id}/download`).
@override final  String path;
/// Yalnız POST hedefinde zorunlu JSON nesnesi (≤ 64 KiB); GET hedefinde gönderilmez.
@override final  dynamic body;

/// Create a copy of DownloadTicketRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTicketRequestCopyWith<_DownloadTicketRequest> get copyWith => __$DownloadTicketRequestCopyWithImpl<_DownloadTicketRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTicketRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTicketRequest&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.body, body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,method,path,const DeepCollectionEquality().hash(body));
}

@override
String toString() {
    return 'DownloadTicketRequest(method: $method, path: $path, body: $body)';
}


}

/// @nodoc
abstract mixin class _$DownloadTicketRequestCopyWith<$Res> implements $DownloadTicketRequestCopyWith<$Res> {
  factory _$DownloadTicketRequestCopyWith(_DownloadTicketRequest value, $Res Function(_DownloadTicketRequest) _then) = __$DownloadTicketRequestCopyWithImpl;
@override @useResult
$Res call({
 DownloadTicketRequestMethod method, String path, dynamic body
});




}
/// @nodoc
class __$DownloadTicketRequestCopyWithImpl<$Res>
    implements _$DownloadTicketRequestCopyWith<$Res> {
  __$DownloadTicketRequestCopyWithImpl(this._self, this._then);

  final _DownloadTicketRequest _self;
  final $Res Function(_DownloadTicketRequest) _then;

/// Create a copy of DownloadTicketRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? path = null,Object? body = freezed,}) {
  return _then(_DownloadTicketRequest(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as DownloadTicketRequestMethod,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
