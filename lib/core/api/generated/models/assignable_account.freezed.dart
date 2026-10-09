// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignable_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignableAccount {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName;/// Hesabın hedef departman dışındaki rol bağları ("departman:rol").
 List<String>? get roles;
/// Create a copy of AssignableAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignableAccountCopyWith<AssignableAccount> get copyWith => _$AssignableAccountCopyWithImpl<AssignableAccount>(this as AssignableAccount, _$identity);

  /// Serializes this AssignableAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssignableAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignableAccount&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&const DeepCollectionEquality().equals(other.roles, _this.roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssignableAccount;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,const DeepCollectionEquality().hash(_this.roles));
}

@override
String toString() {
  final _this = this as AssignableAccount;
  return 'AssignableAccount(accountId: ${_this.accountId}, fullName: ${_this.fullName}, roles: ${_this.roles})';
}


}

/// @nodoc
abstract mixin class $AssignableAccountCopyWith<$Res>  {
  factory $AssignableAccountCopyWith(AssignableAccount value, $Res Function(AssignableAccount) _then) = _$AssignableAccountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<String>? roles
});




}
/// @nodoc
class _$AssignableAccountCopyWithImpl<$Res>
    implements $AssignableAccountCopyWith<$Res> {
  _$AssignableAccountCopyWithImpl(this._self, this._then);

  final AssignableAccount _self;
  final $Res Function(AssignableAccount) _then;

/// Create a copy of AssignableAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? roles = freezed,}) {
  return _then(AssignableAccount(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,roles: freezed == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignableAccount].
extension AssignableAccountPatterns on AssignableAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignableAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignableAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignableAccount value)  $default,){
final _that = this;
switch (_that) {
case _AssignableAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignableAccount value)?  $default,){
final _that = this;
switch (_that) {
case _AssignableAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? roles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignableAccount() when $default != null:
return $default(_that.accountId,_that.fullName,_that.roles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? roles)  $default,) {final _that = this;
switch (_that) {
case _AssignableAccount():
return $default(_that.accountId,_that.fullName,_that.roles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? roles)?  $default,) {final _that = this;
switch (_that) {
case _AssignableAccount() when $default != null:
return $default(_that.accountId,_that.fullName,_that.roles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignableAccount implements AssignableAccount {
  const _AssignableAccount({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required  List<String>? roles}): _roles = roles;
  factory _AssignableAccount.fromJson(Map<String, dynamic> json) => _$AssignableAccountFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
/// Hesabın hedef departman dışındaki rol bağları ("departman:rol").
 final  List<String>? _roles;
/// Hesabın hedef departman dışındaki rol bağları ("departman:rol").
@override List<String>? get roles {
  final value = _roles;
  if (value == null) return null;
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AssignableAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignableAccountCopyWith<_AssignableAccount> get copyWith => __$AssignableAccountCopyWithImpl<_AssignableAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignableAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignableAccount&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.roles, _roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,const DeepCollectionEquality().hash(_roles));
}

@override
String toString() {
    return 'AssignableAccount(accountId: $accountId, fullName: $fullName, roles: $roles)';
}


}

/// @nodoc
abstract mixin class _$AssignableAccountCopyWith<$Res> implements $AssignableAccountCopyWith<$Res> {
  factory _$AssignableAccountCopyWith(_AssignableAccount value, $Res Function(_AssignableAccount) _then) = __$AssignableAccountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<String>? roles
});




}
/// @nodoc
class __$AssignableAccountCopyWithImpl<$Res>
    implements _$AssignableAccountCopyWith<$Res> {
  __$AssignableAccountCopyWithImpl(this._self, this._then);

  final _AssignableAccount _self;
  final $Res Function(_AssignableAccount) _then;

/// Create a copy of AssignableAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? roles = freezed,}) {
  return _then(_AssignableAccount(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,roles: freezed == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
