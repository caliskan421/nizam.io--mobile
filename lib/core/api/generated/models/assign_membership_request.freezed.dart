// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assign_membership_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignMembershipRequest {

@JsonKey(name: 'account_id') String get accountId; String get role;
/// Create a copy of AssignMembershipRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignMembershipRequestCopyWith<AssignMembershipRequest> get copyWith => _$AssignMembershipRequestCopyWithImpl<AssignMembershipRequest>(this as AssignMembershipRequest, _$identity);

  /// Serializes this AssignMembershipRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssignMembershipRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignMembershipRequest&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssignMembershipRequest;
  return Object.hash(runtimeType,_this.accountId,_this.role);
}

@override
String toString() {
  final _this = this as AssignMembershipRequest;
  return 'AssignMembershipRequest(accountId: ${_this.accountId}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $AssignMembershipRequestCopyWith<$Res>  {
  factory $AssignMembershipRequestCopyWith(AssignMembershipRequest value, $Res Function(AssignMembershipRequest) _then) = _$AssignMembershipRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId, String role
});




}
/// @nodoc
class _$AssignMembershipRequestCopyWithImpl<$Res>
    implements $AssignMembershipRequestCopyWith<$Res> {
  _$AssignMembershipRequestCopyWithImpl(this._self, this._then);

  final AssignMembershipRequest _self;
  final $Res Function(AssignMembershipRequest) _then;

/// Create a copy of AssignMembershipRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? role = null,}) {
  return _then(AssignMembershipRequest(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignMembershipRequest].
extension AssignMembershipRequestPatterns on AssignMembershipRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignMembershipRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignMembershipRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignMembershipRequest value)  $default,){
final _that = this;
switch (_that) {
case _AssignMembershipRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignMembershipRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AssignMembershipRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignMembershipRequest() when $default != null:
return $default(_that.accountId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId,  String role)  $default,) {final _that = this;
switch (_that) {
case _AssignMembershipRequest():
return $default(_that.accountId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId,  String role)?  $default,) {final _that = this;
switch (_that) {
case _AssignMembershipRequest() when $default != null:
return $default(_that.accountId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignMembershipRequest implements AssignMembershipRequest {
  const _AssignMembershipRequest({@JsonKey(name: 'account_id') required this.accountId, required this.role});
  factory _AssignMembershipRequest.fromJson(Map<String, dynamic> json) => _$AssignMembershipRequestFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override final  String role;

/// Create a copy of AssignMembershipRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignMembershipRequestCopyWith<_AssignMembershipRequest> get copyWith => __$AssignMembershipRequestCopyWithImpl<_AssignMembershipRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignMembershipRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignMembershipRequest&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,role);
}

@override
String toString() {
    return 'AssignMembershipRequest(accountId: $accountId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$AssignMembershipRequestCopyWith<$Res> implements $AssignMembershipRequestCopyWith<$Res> {
  factory _$AssignMembershipRequestCopyWith(_AssignMembershipRequest value, $Res Function(_AssignMembershipRequest) _then) = __$AssignMembershipRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId, String role
});




}
/// @nodoc
class __$AssignMembershipRequestCopyWithImpl<$Res>
    implements _$AssignMembershipRequestCopyWith<$Res> {
  __$AssignMembershipRequestCopyWithImpl(this._self, this._then);

  final _AssignMembershipRequest _self;
  final $Res Function(_AssignMembershipRequest) _then;

/// Create a copy of AssignMembershipRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? role = null,}) {
  return _then(_AssignMembershipRequest(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
