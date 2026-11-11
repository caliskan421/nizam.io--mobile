// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_status_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountStatusResult {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'account_status') AccountStatusResultAccountStatus get accountStatus;/// Durum bu istekle değişti mi; zaten hedef durumdaysa `false` (idempotent tekrar).
 bool get changed;/// Kapatmada düşürülen oturum sayısı (açmada 0).
@JsonKey(name: 'revoked_sessions') int get revokedSessions;
/// Create a copy of AccountStatusResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStatusResultCopyWith<AccountStatusResult> get copyWith => _$AccountStatusResultCopyWithImpl<AccountStatusResult>(this as AccountStatusResult, _$identity);

  /// Serializes this AccountStatusResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AccountStatusResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountStatusResult&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.accountStatus, _this.accountStatus) || other.accountStatus == _this.accountStatus)&&(identical(other.changed, _this.changed) || other.changed == _this.changed)&&(identical(other.revokedSessions, _this.revokedSessions) || other.revokedSessions == _this.revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AccountStatusResult;
  return Object.hash(runtimeType,_this.accountId,_this.accountStatus,_this.changed,_this.revokedSessions);
}

@override
String toString() {
  final _this = this as AccountStatusResult;
  return 'AccountStatusResult(accountId: ${_this.accountId}, accountStatus: ${_this.accountStatus}, changed: ${_this.changed}, revokedSessions: ${_this.revokedSessions})';
}


}

/// @nodoc
abstract mixin class $AccountStatusResultCopyWith<$Res>  {
  factory $AccountStatusResultCopyWith(AccountStatusResult value, $Res Function(AccountStatusResult) _then) = _$AccountStatusResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_status') AccountStatusResultAccountStatus accountStatus, bool changed,@JsonKey(name: 'revoked_sessions') int revokedSessions
});




}
/// @nodoc
class _$AccountStatusResultCopyWithImpl<$Res>
    implements $AccountStatusResultCopyWith<$Res> {
  _$AccountStatusResultCopyWithImpl(this._self, this._then);

  final AccountStatusResult _self;
  final $Res Function(AccountStatusResult) _then;

/// Create a copy of AccountStatusResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountStatus = null,Object? changed = null,Object? revokedSessions = null,}) {
  return _then(AccountStatusResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as AccountStatusResultAccountStatus,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,revokedSessions: null == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountStatusResult].
extension AccountStatusResultPatterns on AccountStatusResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountStatusResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountStatusResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountStatusResult value)  $default,){
final _that = this;
switch (_that) {
case _AccountStatusResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountStatusResult value)?  $default,){
final _that = this;
switch (_that) {
case _AccountStatusResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_status')  AccountStatusResultAccountStatus accountStatus,  bool changed, @JsonKey(name: 'revoked_sessions')  int revokedSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountStatusResult() when $default != null:
return $default(_that.accountId,_that.accountStatus,_that.changed,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_status')  AccountStatusResultAccountStatus accountStatus,  bool changed, @JsonKey(name: 'revoked_sessions')  int revokedSessions)  $default,) {final _that = this;
switch (_that) {
case _AccountStatusResult():
return $default(_that.accountId,_that.accountStatus,_that.changed,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_status')  AccountStatusResultAccountStatus accountStatus,  bool changed, @JsonKey(name: 'revoked_sessions')  int revokedSessions)?  $default,) {final _that = this;
switch (_that) {
case _AccountStatusResult() when $default != null:
return $default(_that.accountId,_that.accountStatus,_that.changed,_that.revokedSessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountStatusResult implements AccountStatusResult {
  const _AccountStatusResult({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'account_status') required this.accountStatus, required this.changed, @JsonKey(name: 'revoked_sessions') required this.revokedSessions});
  factory _AccountStatusResult.fromJson(Map<String, dynamic> json) => _$AccountStatusResultFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'account_status') final  AccountStatusResultAccountStatus accountStatus;
/// Durum bu istekle değişti mi; zaten hedef durumdaysa `false` (idempotent tekrar).
@override final  bool changed;
/// Kapatmada düşürülen oturum sayısı (açmada 0).
@override@JsonKey(name: 'revoked_sessions') final  int revokedSessions;

/// Create a copy of AccountStatusResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStatusResultCopyWith<_AccountStatusResult> get copyWith => __$AccountStatusResultCopyWithImpl<_AccountStatusResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountStatusResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountStatusResult&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.revokedSessions, revokedSessions) || other.revokedSessions == revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,accountStatus,changed,revokedSessions);
}

@override
String toString() {
    return 'AccountStatusResult(accountId: $accountId, accountStatus: $accountStatus, changed: $changed, revokedSessions: $revokedSessions)';
}


}

/// @nodoc
abstract mixin class _$AccountStatusResultCopyWith<$Res> implements $AccountStatusResultCopyWith<$Res> {
  factory _$AccountStatusResultCopyWith(_AccountStatusResult value, $Res Function(_AccountStatusResult) _then) = __$AccountStatusResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_status') AccountStatusResultAccountStatus accountStatus, bool changed,@JsonKey(name: 'revoked_sessions') int revokedSessions
});




}
/// @nodoc
class __$AccountStatusResultCopyWithImpl<$Res>
    implements _$AccountStatusResultCopyWith<$Res> {
  __$AccountStatusResultCopyWithImpl(this._self, this._then);

  final _AccountStatusResult _self;
  final $Res Function(_AccountStatusResult) _then;

/// Create a copy of AccountStatusResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountStatus = null,Object? changed = null,Object? revokedSessions = null,}) {
  return _then(_AccountStatusResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as AccountStatusResultAccountStatus,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,revokedSessions: null == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
