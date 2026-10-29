// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeResponse {

@JsonKey(name: 'account_id') String get accountId; String get email;/// Görünen ad
@JsonKey(name: 'full_name') String get fullName;/// Hesap şirket yöneticisi mi; kaynak organization yetkisi, üyelikten bağımsız
@JsonKey(name: 'company_admin') bool get companyAdmin;
/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeResponseCopyWith<MeResponse> get copyWith => _$MeResponseCopyWithImpl<MeResponse>(this as MeResponse, _$identity);

  /// Serializes this MeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeResponse&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.companyAdmin, _this.companyAdmin) || other.companyAdmin == _this.companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeResponse;
  return Object.hash(runtimeType,_this.accountId,_this.email,_this.fullName,_this.companyAdmin);
}

@override
String toString() {
  final _this = this as MeResponse;
  return 'MeResponse(accountId: ${_this.accountId}, email: ${_this.email}, fullName: ${_this.fullName}, companyAdmin: ${_this.companyAdmin})';
}


}

/// @nodoc
abstract mixin class $MeResponseCopyWith<$Res>  {
  factory $MeResponseCopyWith(MeResponse value, $Res Function(MeResponse) _then) = _$MeResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId, String email,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'company_admin') bool companyAdmin
});




}
/// @nodoc
class _$MeResponseCopyWithImpl<$Res>
    implements $MeResponseCopyWith<$Res> {
  _$MeResponseCopyWithImpl(this._self, this._then);

  final MeResponse _self;
  final $Res Function(MeResponse) _then;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? email = null,Object? fullName = null,Object? companyAdmin = null,}) {
  return _then(MeResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeResponse].
extension MeResponsePatterns on MeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeResponse value)  $default,){
final _that = this;
switch (_that) {
case _MeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId,  String email, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'company_admin')  bool companyAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
return $default(_that.accountId,_that.email,_that.fullName,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId,  String email, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'company_admin')  bool companyAdmin)  $default,) {final _that = this;
switch (_that) {
case _MeResponse():
return $default(_that.accountId,_that.email,_that.fullName,_that.companyAdmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId,  String email, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'company_admin')  bool companyAdmin)?  $default,) {final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
return $default(_that.accountId,_that.email,_that.fullName,_that.companyAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeResponse implements MeResponse {
  const _MeResponse({@JsonKey(name: 'account_id') required this.accountId, required this.email, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'company_admin') required this.companyAdmin});
  factory _MeResponse.fromJson(Map<String, dynamic> json) => _$MeResponseFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override final  String email;
/// Görünen ad
@override@JsonKey(name: 'full_name') final  String fullName;
/// Hesap şirket yöneticisi mi; kaynak organization yetkisi, üyelikten bağımsız
@override@JsonKey(name: 'company_admin') final  bool companyAdmin;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeResponseCopyWith<_MeResponse> get copyWith => __$MeResponseCopyWithImpl<_MeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeResponse&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.companyAdmin, companyAdmin) || other.companyAdmin == companyAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,email,fullName,companyAdmin);
}

@override
String toString() {
    return 'MeResponse(accountId: $accountId, email: $email, fullName: $fullName, companyAdmin: $companyAdmin)';
}


}

/// @nodoc
abstract mixin class _$MeResponseCopyWith<$Res> implements $MeResponseCopyWith<$Res> {
  factory _$MeResponseCopyWith(_MeResponse value, $Res Function(_MeResponse) _then) = __$MeResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId, String email,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'company_admin') bool companyAdmin
});




}
/// @nodoc
class __$MeResponseCopyWithImpl<$Res>
    implements _$MeResponseCopyWith<$Res> {
  __$MeResponseCopyWithImpl(this._self, this._then);

  final _MeResponse _self;
  final $Res Function(_MeResponse) _then;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? email = null,Object? fullName = null,Object? companyAdmin = null,}) {
  return _then(_MeResponse(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
