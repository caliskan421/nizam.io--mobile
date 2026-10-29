// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_account_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAccountRequest {

 String? get email;@JsonKey(name: 'full_name') String? get fullName; String? get password;@JsonKey(name: 'force_password_change') bool? get forcePasswordChange;
/// Create a copy of UpdateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAccountRequestCopyWith<UpdateAccountRequest> get copyWith => _$UpdateAccountRequestCopyWithImpl<UpdateAccountRequest>(this as UpdateAccountRequest, _$identity);

  /// Serializes this UpdateAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateAccountRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAccountRequest&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.forcePasswordChange, _this.forcePasswordChange) || other.forcePasswordChange == _this.forcePasswordChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateAccountRequest;
  return Object.hash(runtimeType,_this.email,_this.fullName,_this.password,_this.forcePasswordChange);
}



}

/// @nodoc
abstract mixin class $UpdateAccountRequestCopyWith<$Res>  {
  factory $UpdateAccountRequestCopyWith(UpdateAccountRequest value, $Res Function(UpdateAccountRequest) _then) = _$UpdateAccountRequestCopyWithImpl;
@useResult
$Res call({
 String? email,@JsonKey(name: 'full_name') String? fullName, String? password,@JsonKey(name: 'force_password_change') bool? forcePasswordChange
});




}
/// @nodoc
class _$UpdateAccountRequestCopyWithImpl<$Res>
    implements $UpdateAccountRequestCopyWith<$Res> {
  _$UpdateAccountRequestCopyWithImpl(this._self, this._then);

  final UpdateAccountRequest _self;
  final $Res Function(UpdateAccountRequest) _then;

/// Create a copy of UpdateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? fullName = freezed,Object? password = freezed,Object? forcePasswordChange = freezed,}) {
  return _then(UpdateAccountRequest(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAccountRequest].
extension UpdateAccountRequestPatterns on UpdateAccountRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAccountRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAccountRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAccountRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAccountRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAccountRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAccountRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email, @JsonKey(name: 'full_name')  String? fullName,  String? password, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAccountRequest() when $default != null:
return $default(_that.email,_that.fullName,_that.password,_that.forcePasswordChange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email, @JsonKey(name: 'full_name')  String? fullName,  String? password, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)  $default,) {final _that = this;
switch (_that) {
case _UpdateAccountRequest():
return $default(_that.email,_that.fullName,_that.password,_that.forcePasswordChange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email, @JsonKey(name: 'full_name')  String? fullName,  String? password, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAccountRequest() when $default != null:
return $default(_that.email,_that.fullName,_that.password,_that.forcePasswordChange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAccountRequest implements UpdateAccountRequest {
  const _UpdateAccountRequest({this.email, @JsonKey(name: 'full_name') this.fullName, this.password, @JsonKey(name: 'force_password_change') this.forcePasswordChange});
  factory _UpdateAccountRequest.fromJson(Map<String, dynamic> json) => _$UpdateAccountRequestFromJson(json);

@override final  String? email;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override final  String? password;
@override@JsonKey(name: 'force_password_change') final  bool? forcePasswordChange;

/// Create a copy of UpdateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAccountRequestCopyWith<_UpdateAccountRequest> get copyWith => __$UpdateAccountRequestCopyWithImpl<_UpdateAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAccountRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.password, password) || other.password == password)&&(identical(other.forcePasswordChange, forcePasswordChange) || other.forcePasswordChange == forcePasswordChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,fullName,password,forcePasswordChange);
}



}

/// @nodoc
abstract mixin class _$UpdateAccountRequestCopyWith<$Res> implements $UpdateAccountRequestCopyWith<$Res> {
  factory _$UpdateAccountRequestCopyWith(_UpdateAccountRequest value, $Res Function(_UpdateAccountRequest) _then) = __$UpdateAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 String? email,@JsonKey(name: 'full_name') String? fullName, String? password,@JsonKey(name: 'force_password_change') bool? forcePasswordChange
});




}
/// @nodoc
class __$UpdateAccountRequestCopyWithImpl<$Res>
    implements _$UpdateAccountRequestCopyWith<$Res> {
  __$UpdateAccountRequestCopyWithImpl(this._self, this._then);

  final _UpdateAccountRequest _self;
  final $Res Function(_UpdateAccountRequest) _then;

/// Create a copy of UpdateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? fullName = freezed,Object? password = freezed,Object? forcePasswordChange = freezed,}) {
  return _then(_UpdateAccountRequest(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
