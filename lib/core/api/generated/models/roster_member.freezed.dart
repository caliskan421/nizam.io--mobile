// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roster_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RosterMember {

@JsonKey(name: 'membership_id') String get membershipId;@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; String get role; RosterMemberStatus get status;
/// Create a copy of RosterMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RosterMemberCopyWith<RosterMember> get copyWith => _$RosterMemberCopyWithImpl<RosterMember>(this as RosterMember, _$identity);

  /// Serializes this RosterMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RosterMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RosterMember&&(identical(other.membershipId, _this.membershipId) || other.membershipId == _this.membershipId)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RosterMember;
  return Object.hash(runtimeType,_this.membershipId,_this.accountId,_this.fullName,_this.role,_this.status);
}

@override
String toString() {
  final _this = this as RosterMember;
  return 'RosterMember(membershipId: ${_this.membershipId}, accountId: ${_this.accountId}, fullName: ${_this.fullName}, role: ${_this.role}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $RosterMemberCopyWith<$Res>  {
  factory $RosterMemberCopyWith(RosterMember value, $Res Function(RosterMember) _then) = _$RosterMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String role, RosterMemberStatus status
});




}
/// @nodoc
class _$RosterMemberCopyWithImpl<$Res>
    implements $RosterMemberCopyWith<$Res> {
  _$RosterMemberCopyWithImpl(this._self, this._then);

  final RosterMember _self;
  final $Res Function(RosterMember) _then;

/// Create a copy of RosterMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? accountId = null,Object? fullName = null,Object? role = null,Object? status = null,}) {
  return _then(RosterMember(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RosterMemberStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [RosterMember].
extension RosterMemberPatterns on RosterMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RosterMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RosterMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RosterMember value)  $default,){
final _that = this;
switch (_that) {
case _RosterMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RosterMember value)?  $default,){
final _that = this;
switch (_that) {
case _RosterMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role,  RosterMemberStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RosterMember() when $default != null:
return $default(_that.membershipId,_that.accountId,_that.fullName,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role,  RosterMemberStatus status)  $default,) {final _that = this;
switch (_that) {
case _RosterMember():
return $default(_that.membershipId,_that.accountId,_that.fullName,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role,  RosterMemberStatus status)?  $default,) {final _that = this;
switch (_that) {
case _RosterMember() when $default != null:
return $default(_that.membershipId,_that.accountId,_that.fullName,_that.role,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RosterMember implements RosterMember {
  const _RosterMember({@JsonKey(name: 'membership_id') required this.membershipId, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required this.role, required this.status});
  factory _RosterMember.fromJson(Map<String, dynamic> json) => _$RosterMemberFromJson(json);

@override@JsonKey(name: 'membership_id') final  String membershipId;
@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String role;
@override final  RosterMemberStatus status;

/// Create a copy of RosterMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RosterMemberCopyWith<_RosterMember> get copyWith => __$RosterMemberCopyWithImpl<_RosterMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RosterMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RosterMember&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,membershipId,accountId,fullName,role,status);
}

@override
String toString() {
    return 'RosterMember(membershipId: $membershipId, accountId: $accountId, fullName: $fullName, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RosterMemberCopyWith<$Res> implements $RosterMemberCopyWith<$Res> {
  factory _$RosterMemberCopyWith(_RosterMember value, $Res Function(_RosterMember) _then) = __$RosterMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String role, RosterMemberStatus status
});




}
/// @nodoc
class __$RosterMemberCopyWithImpl<$Res>
    implements _$RosterMemberCopyWith<$Res> {
  __$RosterMemberCopyWithImpl(this._self, this._then);

  final _RosterMember _self;
  final $Res Function(_RosterMember) _then;

/// Create a copy of RosterMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? accountId = null,Object? fullName = null,Object? role = null,Object? status = null,}) {
  return _then(_RosterMember(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RosterMemberStatus,
  ));
}


}

// dart format on
