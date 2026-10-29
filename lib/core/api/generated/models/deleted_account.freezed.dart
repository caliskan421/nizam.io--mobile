// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deleted_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletedAccount {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName;
/// Create a copy of DeletedAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedAccountCopyWith<DeletedAccount> get copyWith => _$DeletedAccountCopyWithImpl<DeletedAccount>(this as DeletedAccount, _$identity);

  /// Serializes this DeletedAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeletedAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedAccount&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeletedAccount;
  return Object.hash(runtimeType,_this.accountId,_this.fullName);
}

@override
String toString() {
  final _this = this as DeletedAccount;
  return 'DeletedAccount(accountId: ${_this.accountId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $DeletedAccountCopyWith<$Res>  {
  factory $DeletedAccountCopyWith(DeletedAccount value, $Res Function(DeletedAccount) _then) = _$DeletedAccountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class _$DeletedAccountCopyWithImpl<$Res>
    implements $DeletedAccountCopyWith<$Res> {
  _$DeletedAccountCopyWithImpl(this._self, this._then);

  final DeletedAccount _self;
  final $Res Function(DeletedAccount) _then;

/// Create a copy of DeletedAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(DeletedAccount(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedAccount].
extension DeletedAccountPatterns on DeletedAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedAccount value)  $default,){
final _that = this;
switch (_that) {
case _DeletedAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedAccount value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedAccount() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)  $default,) {final _that = this;
switch (_that) {
case _DeletedAccount():
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _DeletedAccount() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedAccount implements DeletedAccount {
  const _DeletedAccount({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName});
  factory _DeletedAccount.fromJson(Map<String, dynamic> json) => _$DeletedAccountFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;

/// Create a copy of DeletedAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedAccountCopyWith<_DeletedAccount> get copyWith => __$DeletedAccountCopyWithImpl<_DeletedAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedAccount&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName);
}

@override
String toString() {
    return 'DeletedAccount(accountId: $accountId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$DeletedAccountCopyWith<$Res> implements $DeletedAccountCopyWith<$Res> {
  factory _$DeletedAccountCopyWith(_DeletedAccount value, $Res Function(_DeletedAccount) _then) = __$DeletedAccountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class __$DeletedAccountCopyWithImpl<$Res>
    implements _$DeletedAccountCopyWith<$Res> {
  __$DeletedAccountCopyWithImpl(this._self, this._then);

  final _DeletedAccount _self;
  final $Res Function(_DeletedAccount) _then;

/// Create a copy of DeletedAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(_DeletedAccount(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
