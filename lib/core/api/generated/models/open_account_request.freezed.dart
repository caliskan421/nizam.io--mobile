// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_account_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenAccountRequest {

 String get email; String get password;@JsonKey(name: 'full_name') String? get fullName;@JsonKey(name: 'force_password_change') bool? get forcePasswordChange;
/// Create a copy of OpenAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenAccountRequestCopyWith<OpenAccountRequest> get copyWith => _$OpenAccountRequestCopyWithImpl<OpenAccountRequest>(this as OpenAccountRequest, _$identity);

  /// Serializes this OpenAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OpenAccountRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenAccountRequest&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.forcePasswordChange, _this.forcePasswordChange) || other.forcePasswordChange == _this.forcePasswordChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OpenAccountRequest;
  return Object.hash(runtimeType,_this.email,_this.password,_this.fullName,_this.forcePasswordChange);
}



}

/// @nodoc
abstract mixin class $OpenAccountRequestCopyWith<$Res>  {
  factory $OpenAccountRequestCopyWith(OpenAccountRequest value, $Res Function(OpenAccountRequest) _then) = _$OpenAccountRequestCopyWithImpl;
@useResult
$Res call({
 String email, String password,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'force_password_change') bool? forcePasswordChange
});




}
/// @nodoc
class _$OpenAccountRequestCopyWithImpl<$Res>
    implements $OpenAccountRequestCopyWith<$Res> {
  _$OpenAccountRequestCopyWithImpl(this._self, this._then);

  final OpenAccountRequest _self;
  final $Res Function(OpenAccountRequest) _then;

/// Create a copy of OpenAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? fullName = freezed,Object? forcePasswordChange = freezed,}) {
  return _then(OpenAccountRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenAccountRequest].
extension OpenAccountRequestPatterns on OpenAccountRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenAccountRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenAccountRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenAccountRequest value)  $default,){
final _that = this;
switch (_that) {
case _OpenAccountRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenAccountRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OpenAccountRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenAccountRequest() when $default != null:
return $default(_that.email,_that.password,_that.fullName,_that.forcePasswordChange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)  $default,) {final _that = this;
switch (_that) {
case _OpenAccountRequest():
return $default(_that.email,_that.password,_that.fullName,_that.forcePasswordChange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)?  $default,) {final _that = this;
switch (_that) {
case _OpenAccountRequest() when $default != null:
return $default(_that.email,_that.password,_that.fullName,_that.forcePasswordChange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenAccountRequest implements OpenAccountRequest {
  const _OpenAccountRequest({required this.email, required this.password, @JsonKey(name: 'full_name') this.fullName, @JsonKey(name: 'force_password_change') this.forcePasswordChange});
  factory _OpenAccountRequest.fromJson(Map<String, dynamic> json) => _$OpenAccountRequestFromJson(json);

@override final  String email;
@override final  String password;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override@JsonKey(name: 'force_password_change') final  bool? forcePasswordChange;

/// Create a copy of OpenAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenAccountRequestCopyWith<_OpenAccountRequest> get copyWith => __$OpenAccountRequestCopyWithImpl<_OpenAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenAccountRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.forcePasswordChange, forcePasswordChange) || other.forcePasswordChange == forcePasswordChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,password,fullName,forcePasswordChange);
}



}

/// @nodoc
abstract mixin class _$OpenAccountRequestCopyWith<$Res> implements $OpenAccountRequestCopyWith<$Res> {
  factory _$OpenAccountRequestCopyWith(_OpenAccountRequest value, $Res Function(_OpenAccountRequest) _then) = __$OpenAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String password,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'force_password_change') bool? forcePasswordChange
});




}
/// @nodoc
class __$OpenAccountRequestCopyWithImpl<$Res>
    implements _$OpenAccountRequestCopyWith<$Res> {
  __$OpenAccountRequestCopyWithImpl(this._self, this._then);

  final _OpenAccountRequest _self;
  final $Res Function(_OpenAccountRequest) _then;

/// Create a copy of OpenAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? fullName = freezed,Object? forcePasswordChange = freezed,}) {
  return _then(_OpenAccountRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
