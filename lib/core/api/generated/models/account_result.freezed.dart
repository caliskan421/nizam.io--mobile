// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountResult {

@JsonKey(name: 'account_id') String get accountId;/// Düşürülen oturum sayısı; sıfırsa alan yoktur.
@JsonKey(name: 'revoked_sessions') int? get revokedSessions;
/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountResultCopyWith<AccountResult> get copyWith => _$AccountResultCopyWithImpl<AccountResult>(this as AccountResult, _$identity);

  /// Serializes this AccountResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AccountResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountResult&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.revokedSessions, _this.revokedSessions) || other.revokedSessions == _this.revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AccountResult;
  return Object.hash(runtimeType,_this.accountId,_this.revokedSessions);
}

@override
String toString() {
  final _this = this as AccountResult;
  return 'AccountResult(accountId: ${_this.accountId}, revokedSessions: ${_this.revokedSessions})';
}


}

/// @nodoc
abstract mixin class $AccountResultCopyWith<$Res>  {
  factory $AccountResultCopyWith(AccountResult value, $Res Function(AccountResult) _then) = _$AccountResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'revoked_sessions') int? revokedSessions
});




}
/// @nodoc
class _$AccountResultCopyWithImpl<$Res>
    implements $AccountResultCopyWith<$Res> {
  _$AccountResultCopyWithImpl(this._self, this._then);

  final AccountResult _self;
  final $Res Function(AccountResult) _then;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? revokedSessions = freezed,}) {
  return _then(AccountResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,revokedSessions: freezed == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountResult].
extension AccountResultPatterns on AccountResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountResult value)  $default,){
final _that = this;
switch (_that) {
case _AccountResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountResult value)?  $default,){
final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
return $default(_that.accountId,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)  $default,) {final _that = this;
switch (_that) {
case _AccountResult():
return $default(_that.accountId,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)?  $default,) {final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
return $default(_that.accountId,_that.revokedSessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountResult implements AccountResult {
  const _AccountResult({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'revoked_sessions') this.revokedSessions});
  factory _AccountResult.fromJson(Map<String, dynamic> json) => _$AccountResultFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
/// Düşürülen oturum sayısı; sıfırsa alan yoktur.
@override@JsonKey(name: 'revoked_sessions') final  int? revokedSessions;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountResultCopyWith<_AccountResult> get copyWith => __$AccountResultCopyWithImpl<_AccountResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountResult&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.revokedSessions, revokedSessions) || other.revokedSessions == revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,revokedSessions);
}

@override
String toString() {
    return 'AccountResult(accountId: $accountId, revokedSessions: $revokedSessions)';
}


}

/// @nodoc
abstract mixin class _$AccountResultCopyWith<$Res> implements $AccountResultCopyWith<$Res> {
  factory _$AccountResultCopyWith(_AccountResult value, $Res Function(_AccountResult) _then) = __$AccountResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'revoked_sessions') int? revokedSessions
});




}
/// @nodoc
class __$AccountResultCopyWithImpl<$Res>
    implements _$AccountResultCopyWith<$Res> {
  __$AccountResultCopyWithImpl(this._self, this._then);

  final _AccountResult _self;
  final $Res Function(_AccountResult) _then;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? revokedSessions = freezed,}) {
  return _then(_AccountResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,revokedSessions: freezed == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
