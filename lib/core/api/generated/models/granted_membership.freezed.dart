// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'granted_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrantedMembership {

@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'account_id') String get accountId;
/// Create a copy of GrantedMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrantedMembershipCopyWith<GrantedMembership> get copyWith => _$GrantedMembershipCopyWithImpl<GrantedMembership>(this as GrantedMembership, _$identity);

  /// Serializes this GrantedMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GrantedMembership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrantedMembership&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GrantedMembership;
  return Object.hash(runtimeType,_this.departmentId,_this.accountId);
}

@override
String toString() {
  final _this = this as GrantedMembership;
  return 'GrantedMembership(departmentId: ${_this.departmentId}, accountId: ${_this.accountId})';
}


}

/// @nodoc
abstract mixin class $GrantedMembershipCopyWith<$Res>  {
  factory $GrantedMembershipCopyWith(GrantedMembership value, $Res Function(GrantedMembership) _then) = _$GrantedMembershipCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class _$GrantedMembershipCopyWithImpl<$Res>
    implements $GrantedMembershipCopyWith<$Res> {
  _$GrantedMembershipCopyWithImpl(this._self, this._then);

  final GrantedMembership _self;
  final $Res Function(GrantedMembership) _then;

/// Create a copy of GrantedMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? accountId = null,}) {
  return _then(GrantedMembership(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GrantedMembership].
extension GrantedMembershipPatterns on GrantedMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrantedMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrantedMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrantedMembership value)  $default,){
final _that = this;
switch (_that) {
case _GrantedMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrantedMembership value)?  $default,){
final _that = this;
switch (_that) {
case _GrantedMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrantedMembership() when $default != null:
return $default(_that.departmentId,_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId)  $default,) {final _that = this;
switch (_that) {
case _GrantedMembership():
return $default(_that.departmentId,_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId)?  $default,) {final _that = this;
switch (_that) {
case _GrantedMembership() when $default != null:
return $default(_that.departmentId,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrantedMembership implements GrantedMembership {
  const _GrantedMembership({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'account_id') required this.accountId});
  factory _GrantedMembership.fromJson(Map<String, dynamic> json) => _$GrantedMembershipFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'account_id') final  String accountId;

/// Create a copy of GrantedMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrantedMembershipCopyWith<_GrantedMembership> get copyWith => __$GrantedMembershipCopyWithImpl<_GrantedMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrantedMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrantedMembership&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,accountId);
}

@override
String toString() {
    return 'GrantedMembership(departmentId: $departmentId, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$GrantedMembershipCopyWith<$Res> implements $GrantedMembershipCopyWith<$Res> {
  factory _$GrantedMembershipCopyWith(_GrantedMembership value, $Res Function(_GrantedMembership) _then) = __$GrantedMembershipCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class __$GrantedMembershipCopyWithImpl<$Res>
    implements _$GrantedMembershipCopyWith<$Res> {
  __$GrantedMembershipCopyWithImpl(this._self, this._then);

  final _GrantedMembership _self;
  final $Res Function(_GrantedMembership) _then;

/// Create a copy of GrantedMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? accountId = null,}) {
  return _then(_GrantedMembership(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
