// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'known_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KnownUser {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName;/// Hesabın e-postası. Yalnız şirket yöneticisinin kullanıcı yönetim uçlarında döner; üye listesi, havuz ve diğer okuma yüzleri e-posta taşımaz.
 String get email;/// Hesap şirket yöneticisi mi (ekip satırlarından bağımsız).
@JsonKey(name: 'company_admin') bool get companyAdmin;/// Hesap durumu; `disabled` girişi kapatılmış hesaptır (silinmiş hesap listede yoktur).
@JsonKey(name: 'account_status') KnownUserAccountStatus get accountStatus;/// Hesapta şu an süren başarısız giriş kilidi var mı (IDENTITY-K19). Süresi geçmiş kilit ve kilide varmamış sayaç `false`tur; yöneticinin kilit açma ucu ikisini de temizler. Hesabı kapatma (`account_status`) değildir.
@JsonKey(name: 'login_locked') bool get loginLocked;/// Ekip satırı etiketleri, `program:departman:rol` biçiminde.
 List<String>? get memberships;/// Aynı ekip satırlarının yapısal hâli (bütün programlar; canlı departmanlar). Ekipsiz hesapta boş dizi.
 List<UserTeam> get teams;
/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnownUserCopyWith<KnownUser> get copyWith => _$KnownUserCopyWithImpl<KnownUser>(this as KnownUser, _$identity);

  /// Serializes this KnownUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KnownUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnownUser&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.companyAdmin, _this.companyAdmin) || other.companyAdmin == _this.companyAdmin)&&(identical(other.accountStatus, _this.accountStatus) || other.accountStatus == _this.accountStatus)&&(identical(other.loginLocked, _this.loginLocked) || other.loginLocked == _this.loginLocked)&&const DeepCollectionEquality().equals(other.memberships, _this.memberships)&&const DeepCollectionEquality().equals(other.teams, _this.teams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KnownUser;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,_this.email,_this.companyAdmin,_this.accountStatus,_this.loginLocked,const DeepCollectionEquality().hash(_this.memberships),const DeepCollectionEquality().hash(_this.teams));
}

@override
String toString() {
  final _this = this as KnownUser;
  return 'KnownUser(accountId: ${_this.accountId}, fullName: ${_this.fullName}, email: ${_this.email}, companyAdmin: ${_this.companyAdmin}, accountStatus: ${_this.accountStatus}, loginLocked: ${_this.loginLocked}, memberships: ${_this.memberships}, teams: ${_this.teams})';
}


}

/// @nodoc
abstract mixin class $KnownUserCopyWith<$Res>  {
  factory $KnownUserCopyWith(KnownUser value, $Res Function(KnownUser) _then) = _$KnownUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String email,@JsonKey(name: 'company_admin') bool companyAdmin,@JsonKey(name: 'account_status') KnownUserAccountStatus accountStatus,@JsonKey(name: 'login_locked') bool loginLocked, List<String>? memberships, List<UserTeam> teams
});




}
/// @nodoc
class _$KnownUserCopyWithImpl<$Res>
    implements $KnownUserCopyWith<$Res> {
  _$KnownUserCopyWithImpl(this._self, this._then);

  final KnownUser _self;
  final $Res Function(KnownUser) _then;

/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? email = null,Object? companyAdmin = null,Object? accountStatus = null,Object? loginLocked = null,Object? memberships = freezed,Object? teams = null,}) {
  return _then(KnownUser(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as KnownUserAccountStatus,loginLocked: null == loginLocked ? _self.loginLocked : loginLocked // ignore: cast_nullable_to_non_nullable
as bool,memberships: freezed == memberships ? _self.memberships : memberships // ignore: cast_nullable_to_non_nullable
as List<String>?,teams: null == teams ? _self.teams : teams // ignore: cast_nullable_to_non_nullable
as List<UserTeam>,
  ));
}

}


/// Adds pattern-matching-related methods to [KnownUser].
extension KnownUserPatterns on KnownUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnownUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnownUser value)  $default,){
final _that = this;
switch (_that) {
case _KnownUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnownUser value)?  $default,){
final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String email, @JsonKey(name: 'company_admin')  bool companyAdmin, @JsonKey(name: 'account_status')  KnownUserAccountStatus accountStatus, @JsonKey(name: 'login_locked')  bool loginLocked,  List<String>? memberships,  List<UserTeam> teams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
return $default(_that.accountId,_that.fullName,_that.email,_that.companyAdmin,_that.accountStatus,_that.loginLocked,_that.memberships,_that.teams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String email, @JsonKey(name: 'company_admin')  bool companyAdmin, @JsonKey(name: 'account_status')  KnownUserAccountStatus accountStatus, @JsonKey(name: 'login_locked')  bool loginLocked,  List<String>? memberships,  List<UserTeam> teams)  $default,) {final _that = this;
switch (_that) {
case _KnownUser():
return $default(_that.accountId,_that.fullName,_that.email,_that.companyAdmin,_that.accountStatus,_that.loginLocked,_that.memberships,_that.teams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String email, @JsonKey(name: 'company_admin')  bool companyAdmin, @JsonKey(name: 'account_status')  KnownUserAccountStatus accountStatus, @JsonKey(name: 'login_locked')  bool loginLocked,  List<String>? memberships,  List<UserTeam> teams)?  $default,) {final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
return $default(_that.accountId,_that.fullName,_that.email,_that.companyAdmin,_that.accountStatus,_that.loginLocked,_that.memberships,_that.teams);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KnownUser implements KnownUser {
  const _KnownUser({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required this.email, @JsonKey(name: 'company_admin') required this.companyAdmin, @JsonKey(name: 'account_status') required this.accountStatus, @JsonKey(name: 'login_locked') required this.loginLocked, required  List<String>? memberships, required  List<UserTeam> teams}): _memberships = memberships,_teams = teams;
  factory _KnownUser.fromJson(Map<String, dynamic> json) => _$KnownUserFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
/// Hesabın e-postası. Yalnız şirket yöneticisinin kullanıcı yönetim uçlarında döner; üye listesi, havuz ve diğer okuma yüzleri e-posta taşımaz.
@override final  String email;
/// Hesap şirket yöneticisi mi (ekip satırlarından bağımsız).
@override@JsonKey(name: 'company_admin') final  bool companyAdmin;
/// Hesap durumu; `disabled` girişi kapatılmış hesaptır (silinmiş hesap listede yoktur).
@override@JsonKey(name: 'account_status') final  KnownUserAccountStatus accountStatus;
/// Hesapta şu an süren başarısız giriş kilidi var mı (IDENTITY-K19). Süresi geçmiş kilit ve kilide varmamış sayaç `false`tur; yöneticinin kilit açma ucu ikisini de temizler. Hesabı kapatma (`account_status`) değildir.
@override@JsonKey(name: 'login_locked') final  bool loginLocked;
/// Ekip satırı etiketleri, `program:departman:rol` biçiminde.
 final  List<String>? _memberships;
/// Ekip satırı etiketleri, `program:departman:rol` biçiminde.
@override List<String>? get memberships {
  final value = _memberships;
  if (value == null) return null;
  if (_memberships is EqualUnmodifiableListView) return _memberships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Aynı ekip satırlarının yapısal hâli (bütün programlar; canlı departmanlar). Ekipsiz hesapta boş dizi.
 final  List<UserTeam> _teams;
/// Aynı ekip satırlarının yapısal hâli (bütün programlar; canlı departmanlar). Ekipsiz hesapta boş dizi.
@override List<UserTeam> get teams {
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teams);
}


/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnownUserCopyWith<_KnownUser> get copyWith => __$KnownUserCopyWithImpl<_KnownUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KnownUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnownUser&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.companyAdmin, companyAdmin) || other.companyAdmin == companyAdmin)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus)&&(identical(other.loginLocked, loginLocked) || other.loginLocked == loginLocked)&&const DeepCollectionEquality().equals(other.memberships, _memberships)&&const DeepCollectionEquality().equals(other.teams, _teams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,email,companyAdmin,accountStatus,loginLocked,const DeepCollectionEquality().hash(_memberships),const DeepCollectionEquality().hash(_teams));
}

@override
String toString() {
    return 'KnownUser(accountId: $accountId, fullName: $fullName, email: $email, companyAdmin: $companyAdmin, accountStatus: $accountStatus, loginLocked: $loginLocked, memberships: $memberships, teams: $teams)';
}


}

/// @nodoc
abstract mixin class _$KnownUserCopyWith<$Res> implements $KnownUserCopyWith<$Res> {
  factory _$KnownUserCopyWith(_KnownUser value, $Res Function(_KnownUser) _then) = __$KnownUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String email,@JsonKey(name: 'company_admin') bool companyAdmin,@JsonKey(name: 'account_status') KnownUserAccountStatus accountStatus,@JsonKey(name: 'login_locked') bool loginLocked, List<String>? memberships, List<UserTeam> teams
});




}
/// @nodoc
class __$KnownUserCopyWithImpl<$Res>
    implements _$KnownUserCopyWith<$Res> {
  __$KnownUserCopyWithImpl(this._self, this._then);

  final _KnownUser _self;
  final $Res Function(_KnownUser) _then;

/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? email = null,Object? companyAdmin = null,Object? accountStatus = null,Object? loginLocked = null,Object? memberships = freezed,Object? teams = null,}) {
  return _then(_KnownUser(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as bool,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as KnownUserAccountStatus,loginLocked: null == loginLocked ? _self.loginLocked : loginLocked // ignore: cast_nullable_to_non_nullable
as bool,memberships: freezed == memberships ? _self._memberships : memberships // ignore: cast_nullable_to_non_nullable
as List<String>?,teams: null == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<UserTeam>,
  ));
}


}

// dart format on
