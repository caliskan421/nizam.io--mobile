// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lockout_reset_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LockoutResetResult {

@JsonKey(name: 'accounts_reset') int get accountsReset;@JsonKey(name: 'attempts_cleared') int get attemptsCleared;
/// Create a copy of LockoutResetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockoutResetResultCopyWith<LockoutResetResult> get copyWith => _$LockoutResetResultCopyWithImpl<LockoutResetResult>(this as LockoutResetResult, _$identity);

  /// Serializes this LockoutResetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LockoutResetResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockoutResetResult&&(identical(other.accountsReset, _this.accountsReset) || other.accountsReset == _this.accountsReset)&&(identical(other.attemptsCleared, _this.attemptsCleared) || other.attemptsCleared == _this.attemptsCleared));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LockoutResetResult;
  return Object.hash(runtimeType,_this.accountsReset,_this.attemptsCleared);
}

@override
String toString() {
  final _this = this as LockoutResetResult;
  return 'LockoutResetResult(accountsReset: ${_this.accountsReset}, attemptsCleared: ${_this.attemptsCleared})';
}


}

/// @nodoc
abstract mixin class $LockoutResetResultCopyWith<$Res>  {
  factory $LockoutResetResultCopyWith(LockoutResetResult value, $Res Function(LockoutResetResult) _then) = _$LockoutResetResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'accounts_reset') int accountsReset,@JsonKey(name: 'attempts_cleared') int attemptsCleared
});




}
/// @nodoc
class _$LockoutResetResultCopyWithImpl<$Res>
    implements $LockoutResetResultCopyWith<$Res> {
  _$LockoutResetResultCopyWithImpl(this._self, this._then);

  final LockoutResetResult _self;
  final $Res Function(LockoutResetResult) _then;

/// Create a copy of LockoutResetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountsReset = null,Object? attemptsCleared = null,}) {
  return _then(LockoutResetResult(
accountsReset: null == accountsReset ? _self.accountsReset : accountsReset // ignore: cast_nullable_to_non_nullable
as int,attemptsCleared: null == attemptsCleared ? _self.attemptsCleared : attemptsCleared // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LockoutResetResult].
extension LockoutResetResultPatterns on LockoutResetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LockoutResetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LockoutResetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LockoutResetResult value)  $default,){
final _that = this;
switch (_that) {
case _LockoutResetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LockoutResetResult value)?  $default,){
final _that = this;
switch (_that) {
case _LockoutResetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'accounts_reset')  int accountsReset, @JsonKey(name: 'attempts_cleared')  int attemptsCleared)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LockoutResetResult() when $default != null:
return $default(_that.accountsReset,_that.attemptsCleared);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'accounts_reset')  int accountsReset, @JsonKey(name: 'attempts_cleared')  int attemptsCleared)  $default,) {final _that = this;
switch (_that) {
case _LockoutResetResult():
return $default(_that.accountsReset,_that.attemptsCleared);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'accounts_reset')  int accountsReset, @JsonKey(name: 'attempts_cleared')  int attemptsCleared)?  $default,) {final _that = this;
switch (_that) {
case _LockoutResetResult() when $default != null:
return $default(_that.accountsReset,_that.attemptsCleared);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LockoutResetResult implements LockoutResetResult {
  const _LockoutResetResult({@JsonKey(name: 'accounts_reset') required this.accountsReset, @JsonKey(name: 'attempts_cleared') required this.attemptsCleared});
  factory _LockoutResetResult.fromJson(Map<String, dynamic> json) => _$LockoutResetResultFromJson(json);

@override@JsonKey(name: 'accounts_reset') final  int accountsReset;
@override@JsonKey(name: 'attempts_cleared') final  int attemptsCleared;

/// Create a copy of LockoutResetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockoutResetResultCopyWith<_LockoutResetResult> get copyWith => __$LockoutResetResultCopyWithImpl<_LockoutResetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LockoutResetResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockoutResetResult&&(identical(other.accountsReset, accountsReset) || other.accountsReset == accountsReset)&&(identical(other.attemptsCleared, attemptsCleared) || other.attemptsCleared == attemptsCleared));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountsReset,attemptsCleared);
}

@override
String toString() {
    return 'LockoutResetResult(accountsReset: $accountsReset, attemptsCleared: $attemptsCleared)';
}


}

/// @nodoc
abstract mixin class _$LockoutResetResultCopyWith<$Res> implements $LockoutResetResultCopyWith<$Res> {
  factory _$LockoutResetResultCopyWith(_LockoutResetResult value, $Res Function(_LockoutResetResult) _then) = __$LockoutResetResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'accounts_reset') int accountsReset,@JsonKey(name: 'attempts_cleared') int attemptsCleared
});




}
/// @nodoc
class __$LockoutResetResultCopyWithImpl<$Res>
    implements _$LockoutResetResultCopyWith<$Res> {
  __$LockoutResetResultCopyWithImpl(this._self, this._then);

  final _LockoutResetResult _self;
  final $Res Function(_LockoutResetResult) _then;

/// Create a copy of LockoutResetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountsReset = null,Object? attemptsCleared = null,}) {
  return _then(_LockoutResetResult(
accountsReset: null == accountsReset ? _self.accountsReset : accountsReset // ignore: cast_nullable_to_non_nullable
as int,attemptsCleared: null == attemptsCleared ? _self.attemptsCleared : attemptsCleared // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
