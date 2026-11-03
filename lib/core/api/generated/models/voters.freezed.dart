// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Voters {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String? get fullName;
/// Create a copy of Voters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VotersCopyWith<Voters> get copyWith => _$VotersCopyWithImpl<Voters>(this as Voters, _$identity);

  /// Serializes this Voters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Voters;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Voters&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Voters;
  return Object.hash(runtimeType,_this.accountId,_this.fullName);
}

@override
String toString() {
  final _this = this as Voters;
  return 'Voters(accountId: ${_this.accountId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $VotersCopyWith<$Res>  {
  factory $VotersCopyWith(Voters value, $Res Function(Voters) _then) = _$VotersCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String? fullName
});




}
/// @nodoc
class _$VotersCopyWithImpl<$Res>
    implements $VotersCopyWith<$Res> {
  _$VotersCopyWithImpl(this._self, this._then);

  final Voters _self;
  final $Res Function(Voters) _then;

/// Create a copy of Voters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = freezed,}) {
  return _then(Voters(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Voters].
extension VotersPatterns on Voters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Voters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Voters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Voters value)  $default,){
final _that = this;
switch (_that) {
case _Voters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Voters value)?  $default,){
final _that = this;
switch (_that) {
case _Voters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Voters() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)  $default,) {final _that = this;
switch (_that) {
case _Voters():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)?  $default,) {final _that = this;
switch (_that) {
case _Voters() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Voters implements Voters {
  const _Voters({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName});
  factory _Voters.fromJson(Map<String, dynamic> json) => _$VotersFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String? fullName;

/// Create a copy of Voters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VotersCopyWith<_Voters> get copyWith => __$VotersCopyWithImpl<_Voters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VotersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Voters&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName);
}

@override
String toString() {
    return 'Voters(accountId: $accountId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$VotersCopyWith<$Res> implements $VotersCopyWith<$Res> {
  factory _$VotersCopyWith(_Voters value, $Res Function(_Voters) _then) = __$VotersCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String? fullName
});




}
/// @nodoc
class __$VotersCopyWithImpl<$Res>
    implements _$VotersCopyWith<$Res> {
  __$VotersCopyWithImpl(this._self, this._then);

  final _Voters _self;
  final $Res Function(_Voters) _then;

/// Create a copy of Voters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = freezed,}) {
  return _then(_Voters(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
