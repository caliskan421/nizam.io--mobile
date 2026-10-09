// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coordinator_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoordinatorResult {

@JsonKey(name: 'membership_id') String get membershipId;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'account_id') String get accountId; String get role; bool get changed;
/// Create a copy of CoordinatorResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatorResultCopyWith<CoordinatorResult> get copyWith => _$CoordinatorResultCopyWithImpl<CoordinatorResult>(this as CoordinatorResult, _$identity);

  /// Serializes this CoordinatorResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CoordinatorResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoordinatorResult&&(identical(other.membershipId, _this.membershipId) || other.membershipId == _this.membershipId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.changed, _this.changed) || other.changed == _this.changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoordinatorResult;
  return Object.hash(runtimeType,_this.membershipId,_this.departmentId,_this.accountId,_this.role,_this.changed);
}

@override
String toString() {
  final _this = this as CoordinatorResult;
  return 'CoordinatorResult(membershipId: ${_this.membershipId}, departmentId: ${_this.departmentId}, accountId: ${_this.accountId}, role: ${_this.role}, changed: ${_this.changed})';
}


}

/// @nodoc
abstract mixin class $CoordinatorResultCopyWith<$Res>  {
  factory $CoordinatorResultCopyWith(CoordinatorResult value, $Res Function(CoordinatorResult) _then) = _$CoordinatorResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'account_id') String accountId, String role, bool changed
});




}
/// @nodoc
class _$CoordinatorResultCopyWithImpl<$Res>
    implements $CoordinatorResultCopyWith<$Res> {
  _$CoordinatorResultCopyWithImpl(this._self, this._then);

  final CoordinatorResult _self;
  final $Res Function(CoordinatorResult) _then;

/// Create a copy of CoordinatorResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? departmentId = null,Object? accountId = null,Object? role = null,Object? changed = null,}) {
  return _then(CoordinatorResult(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CoordinatorResult].
extension CoordinatorResultPatterns on CoordinatorResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoordinatorResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoordinatorResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoordinatorResult value)  $default,){
final _that = this;
switch (_that) {
case _CoordinatorResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoordinatorResult value)?  $default,){
final _that = this;
switch (_that) {
case _CoordinatorResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId,  String role,  bool changed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoordinatorResult() when $default != null:
return $default(_that.membershipId,_that.departmentId,_that.accountId,_that.role,_that.changed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId,  String role,  bool changed)  $default,) {final _that = this;
switch (_that) {
case _CoordinatorResult():
return $default(_that.membershipId,_that.departmentId,_that.accountId,_that.role,_that.changed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'account_id')  String accountId,  String role,  bool changed)?  $default,) {final _that = this;
switch (_that) {
case _CoordinatorResult() when $default != null:
return $default(_that.membershipId,_that.departmentId,_that.accountId,_that.role,_that.changed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoordinatorResult implements CoordinatorResult {
  const _CoordinatorResult({@JsonKey(name: 'membership_id') required this.membershipId, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'account_id') required this.accountId, required this.role, required this.changed});
  factory _CoordinatorResult.fromJson(Map<String, dynamic> json) => _$CoordinatorResultFromJson(json);

@override@JsonKey(name: 'membership_id') final  String membershipId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'account_id') final  String accountId;
@override final  String role;
@override final  bool changed;

/// Create a copy of CoordinatorResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatorResultCopyWith<_CoordinatorResult> get copyWith => __$CoordinatorResultCopyWithImpl<_CoordinatorResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatorResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoordinatorResult&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.role, role) || other.role == role)&&(identical(other.changed, changed) || other.changed == changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,membershipId,departmentId,accountId,role,changed);
}

@override
String toString() {
    return 'CoordinatorResult(membershipId: $membershipId, departmentId: $departmentId, accountId: $accountId, role: $role, changed: $changed)';
}


}

/// @nodoc
abstract mixin class _$CoordinatorResultCopyWith<$Res> implements $CoordinatorResultCopyWith<$Res> {
  factory _$CoordinatorResultCopyWith(_CoordinatorResult value, $Res Function(_CoordinatorResult) _then) = __$CoordinatorResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'account_id') String accountId, String role, bool changed
});




}
/// @nodoc
class __$CoordinatorResultCopyWithImpl<$Res>
    implements _$CoordinatorResultCopyWith<$Res> {
  __$CoordinatorResultCopyWithImpl(this._self, this._then);

  final _CoordinatorResult _self;
  final $Res Function(_CoordinatorResult) _then;

/// Create a copy of CoordinatorResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? departmentId = null,Object? accountId = null,Object? role = null,Object? changed = null,}) {
  return _then(_CoordinatorResult(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
