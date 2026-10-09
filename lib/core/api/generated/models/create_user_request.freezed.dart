// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUserRequest {

 String get email;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'full_name') String? get fullName; String? get role;@JsonKey(name: 'transfer_account_id') String? get transferAccountId;@JsonKey(name: 'company_admin') bool? get companyAdmin;
/// Create a copy of CreateUserRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserRequestCopyWith<CreateUserRequest> get copyWith => _$CreateUserRequestCopyWithImpl<CreateUserRequest>(this as CreateUserRequest, _$identity);

  /// Serializes this CreateUserRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateUserRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserRequest&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.transferAccountId, _this.transferAccountId) || other.transferAccountId == _this.transferAccountId)&&(identical(other.companyAdmin, _this.companyAdmin) || other.companyAdmin == _this.companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateUserRequest;
  return Object.hash(runtimeType,_this.email,_this.departmentId,_this.fullName,_this.role,_this.transferAccountId,_this.companyAdmin);
}

@override
String toString() {
  final _this = this as CreateUserRequest;
  return 'CreateUserRequest(email: ${_this.email}, departmentId: ${_this.departmentId}, fullName: ${_this.fullName}, role: ${_this.role}, transferAccountId: ${_this.transferAccountId}, companyAdmin: ${_this.companyAdmin})';
}


}

/// @nodoc
abstract mixin class $CreateUserRequestCopyWith<$Res>  {
  factory $CreateUserRequestCopyWith(CreateUserRequest value, $Res Function(CreateUserRequest) _then) = _$CreateUserRequestCopyWithImpl;
@useResult
$Res call({
 String email,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'full_name') String? fullName, String? role,@JsonKey(name: 'transfer_account_id') String? transferAccountId,@JsonKey(name: 'company_admin') bool? companyAdmin
});




}
/// @nodoc
class _$CreateUserRequestCopyWithImpl<$Res>
    implements $CreateUserRequestCopyWith<$Res> {
  _$CreateUserRequestCopyWithImpl(this._self, this._then);

  final CreateUserRequest _self;
  final $Res Function(CreateUserRequest) _then;

/// Create a copy of CreateUserRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? departmentId = null,Object? fullName = freezed,Object? role = freezed,Object? transferAccountId = freezed,Object? companyAdmin = freezed,}) {
  return _then(CreateUserRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,transferAccountId: freezed == transferAccountId ? _self.transferAccountId : transferAccountId // ignore: cast_nullable_to_non_nullable
as String?,companyAdmin: freezed == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUserRequest].
extension CreateUserRequestPatterns on CreateUserRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'full_name')  String? fullName,  String? role, @JsonKey(name: 'transfer_account_id')  String? transferAccountId, @JsonKey(name: 'company_admin')  bool? companyAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserRequest() when $default != null:
return $default(_that.email,_that.departmentId,_that.fullName,_that.role,_that.transferAccountId,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'full_name')  String? fullName,  String? role, @JsonKey(name: 'transfer_account_id')  String? transferAccountId, @JsonKey(name: 'company_admin')  bool? companyAdmin)  $default,) {final _that = this;
switch (_that) {
case _CreateUserRequest():
return $default(_that.email,_that.departmentId,_that.fullName,_that.role,_that.transferAccountId,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'full_name')  String? fullName,  String? role, @JsonKey(name: 'transfer_account_id')  String? transferAccountId, @JsonKey(name: 'company_admin')  bool? companyAdmin)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserRequest() when $default != null:
return $default(_that.email,_that.departmentId,_that.fullName,_that.role,_that.transferAccountId,_that.companyAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUserRequest implements CreateUserRequest {
  const _CreateUserRequest({required this.email, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'full_name') this.fullName, this.role, @JsonKey(name: 'transfer_account_id') this.transferAccountId, @JsonKey(name: 'company_admin') this.companyAdmin});
  factory _CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);

@override final  String email;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override final  String? role;
@override@JsonKey(name: 'transfer_account_id') final  String? transferAccountId;
@override@JsonKey(name: 'company_admin') final  bool? companyAdmin;

/// Create a copy of CreateUserRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserRequestCopyWith<_CreateUserRequest> get copyWith => __$CreateUserRequestCopyWithImpl<_CreateUserRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.transferAccountId, transferAccountId) || other.transferAccountId == transferAccountId)&&(identical(other.companyAdmin, companyAdmin) || other.companyAdmin == companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,departmentId,fullName,role,transferAccountId,companyAdmin);
}

@override
String toString() {
    return 'CreateUserRequest(email: $email, departmentId: $departmentId, fullName: $fullName, role: $role, transferAccountId: $transferAccountId, companyAdmin: $companyAdmin)';
}


}

/// @nodoc
abstract mixin class _$CreateUserRequestCopyWith<$Res> implements $CreateUserRequestCopyWith<$Res> {
  factory _$CreateUserRequestCopyWith(_CreateUserRequest value, $Res Function(_CreateUserRequest) _then) = __$CreateUserRequestCopyWithImpl;
@override @useResult
$Res call({
 String email,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'full_name') String? fullName, String? role,@JsonKey(name: 'transfer_account_id') String? transferAccountId,@JsonKey(name: 'company_admin') bool? companyAdmin
});




}
/// @nodoc
class __$CreateUserRequestCopyWithImpl<$Res>
    implements _$CreateUserRequestCopyWith<$Res> {
  __$CreateUserRequestCopyWithImpl(this._self, this._then);

  final _CreateUserRequest _self;
  final $Res Function(_CreateUserRequest) _then;

/// Create a copy of CreateUserRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? departmentId = null,Object? fullName = freezed,Object? role = freezed,Object? transferAccountId = freezed,Object? companyAdmin = freezed,}) {
  return _then(_CreateUserRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,transferAccountId: freezed == transferAccountId ? _self.transferAccountId : transferAccountId // ignore: cast_nullable_to_non_nullable
as String?,companyAdmin: freezed == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
