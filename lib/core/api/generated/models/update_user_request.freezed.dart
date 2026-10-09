// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUserRequest {

 String? get email;@JsonKey(name: 'full_name') String? get fullName;@JsonKey(name: 'reset_password') bool? get resetPassword;@JsonKey(name: 'force_password_change') bool? get forcePasswordChange;@JsonKey(name: 'company_admin') bool? get companyAdmin;
/// Create a copy of UpdateUserRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserRequestCopyWith<UpdateUserRequest> get copyWith => _$UpdateUserRequestCopyWithImpl<UpdateUserRequest>(this as UpdateUserRequest, _$identity);

  /// Serializes this UpdateUserRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateUserRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserRequest&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.resetPassword, _this.resetPassword) || other.resetPassword == _this.resetPassword)&&(identical(other.forcePasswordChange, _this.forcePasswordChange) || other.forcePasswordChange == _this.forcePasswordChange)&&(identical(other.companyAdmin, _this.companyAdmin) || other.companyAdmin == _this.companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateUserRequest;
  return Object.hash(runtimeType,_this.email,_this.fullName,_this.resetPassword,_this.forcePasswordChange,_this.companyAdmin);
}

@override
String toString() {
  final _this = this as UpdateUserRequest;
  return 'UpdateUserRequest(email: ${_this.email}, fullName: ${_this.fullName}, resetPassword: ${_this.resetPassword}, forcePasswordChange: ${_this.forcePasswordChange}, companyAdmin: ${_this.companyAdmin})';
}


}

/// @nodoc
abstract mixin class $UpdateUserRequestCopyWith<$Res>  {
  factory $UpdateUserRequestCopyWith(UpdateUserRequest value, $Res Function(UpdateUserRequest) _then) = _$UpdateUserRequestCopyWithImpl;
@useResult
$Res call({
 String? email,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'reset_password') bool? resetPassword,@JsonKey(name: 'force_password_change') bool? forcePasswordChange,@JsonKey(name: 'company_admin') bool? companyAdmin
});




}
/// @nodoc
class _$UpdateUserRequestCopyWithImpl<$Res>
    implements $UpdateUserRequestCopyWith<$Res> {
  _$UpdateUserRequestCopyWithImpl(this._self, this._then);

  final UpdateUserRequest _self;
  final $Res Function(UpdateUserRequest) _then;

/// Create a copy of UpdateUserRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? fullName = freezed,Object? resetPassword = freezed,Object? forcePasswordChange = freezed,Object? companyAdmin = freezed,}) {
  return _then(UpdateUserRequest(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,resetPassword: freezed == resetPassword ? _self.resetPassword : resetPassword // ignore: cast_nullable_to_non_nullable
as bool?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,companyAdmin: freezed == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserRequest].
extension UpdateUserRequestPatterns on UpdateUserRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'reset_password')  bool? resetPassword, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange, @JsonKey(name: 'company_admin')  bool? companyAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserRequest() when $default != null:
return $default(_that.email,_that.fullName,_that.resetPassword,_that.forcePasswordChange,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'reset_password')  bool? resetPassword, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange, @JsonKey(name: 'company_admin')  bool? companyAdmin)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserRequest():
return $default(_that.email,_that.fullName,_that.resetPassword,_that.forcePasswordChange,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'reset_password')  bool? resetPassword, @JsonKey(name: 'force_password_change')  bool? forcePasswordChange, @JsonKey(name: 'company_admin')  bool? companyAdmin)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserRequest() when $default != null:
return $default(_that.email,_that.fullName,_that.resetPassword,_that.forcePasswordChange,_that.companyAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserRequest implements UpdateUserRequest {
  const _UpdateUserRequest({this.email, @JsonKey(name: 'full_name') this.fullName, @JsonKey(name: 'reset_password') this.resetPassword, @JsonKey(name: 'force_password_change') this.forcePasswordChange, @JsonKey(name: 'company_admin') this.companyAdmin});
  factory _UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);

@override final  String? email;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override@JsonKey(name: 'reset_password') final  bool? resetPassword;
@override@JsonKey(name: 'force_password_change') final  bool? forcePasswordChange;
@override@JsonKey(name: 'company_admin') final  bool? companyAdmin;

/// Create a copy of UpdateUserRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserRequestCopyWith<_UpdateUserRequest> get copyWith => __$UpdateUserRequestCopyWithImpl<_UpdateUserRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.resetPassword, resetPassword) || other.resetPassword == resetPassword)&&(identical(other.forcePasswordChange, forcePasswordChange) || other.forcePasswordChange == forcePasswordChange)&&(identical(other.companyAdmin, companyAdmin) || other.companyAdmin == companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,fullName,resetPassword,forcePasswordChange,companyAdmin);
}

@override
String toString() {
    return 'UpdateUserRequest(email: $email, fullName: $fullName, resetPassword: $resetPassword, forcePasswordChange: $forcePasswordChange, companyAdmin: $companyAdmin)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserRequestCopyWith<$Res> implements $UpdateUserRequestCopyWith<$Res> {
  factory _$UpdateUserRequestCopyWith(_UpdateUserRequest value, $Res Function(_UpdateUserRequest) _then) = __$UpdateUserRequestCopyWithImpl;
@override @useResult
$Res call({
 String? email,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'reset_password') bool? resetPassword,@JsonKey(name: 'force_password_change') bool? forcePasswordChange,@JsonKey(name: 'company_admin') bool? companyAdmin
});




}
/// @nodoc
class __$UpdateUserRequestCopyWithImpl<$Res>
    implements _$UpdateUserRequestCopyWith<$Res> {
  __$UpdateUserRequestCopyWithImpl(this._self, this._then);

  final _UpdateUserRequest _self;
  final $Res Function(_UpdateUserRequest) _then;

/// Create a copy of UpdateUserRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? fullName = freezed,Object? resetPassword = freezed,Object? forcePasswordChange = freezed,Object? companyAdmin = freezed,}) {
  return _then(_UpdateUserRequest(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,resetPassword: freezed == resetPassword ? _self.resetPassword : resetPassword // ignore: cast_nullable_to_non_nullable
as bool?,forcePasswordChange: freezed == forcePasswordChange ? _self.forcePasswordChange : forcePasswordChange // ignore: cast_nullable_to_non_nullable
as bool?,companyAdmin: freezed == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
