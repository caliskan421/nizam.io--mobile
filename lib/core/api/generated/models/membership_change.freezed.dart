// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MembershipChange {

@JsonKey(name: 'membership_id') String get membershipId;@JsonKey(name: 'unassigned_tasks') int get unassignedTasks; bool get warning;
/// Create a copy of MembershipChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipChangeCopyWith<MembershipChange> get copyWith => _$MembershipChangeCopyWithImpl<MembershipChange>(this as MembershipChange, _$identity);

  /// Serializes this MembershipChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MembershipChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipChange&&(identical(other.membershipId, _this.membershipId) || other.membershipId == _this.membershipId)&&(identical(other.unassignedTasks, _this.unassignedTasks) || other.unassignedTasks == _this.unassignedTasks)&&(identical(other.warning, _this.warning) || other.warning == _this.warning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MembershipChange;
  return Object.hash(runtimeType,_this.membershipId,_this.unassignedTasks,_this.warning);
}

@override
String toString() {
  final _this = this as MembershipChange;
  return 'MembershipChange(membershipId: ${_this.membershipId}, unassignedTasks: ${_this.unassignedTasks}, warning: ${_this.warning})';
}


}

/// @nodoc
abstract mixin class $MembershipChangeCopyWith<$Res>  {
  factory $MembershipChangeCopyWith(MembershipChange value, $Res Function(MembershipChange) _then) = _$MembershipChangeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'unassigned_tasks') int unassignedTasks, bool warning
});




}
/// @nodoc
class _$MembershipChangeCopyWithImpl<$Res>
    implements $MembershipChangeCopyWith<$Res> {
  _$MembershipChangeCopyWithImpl(this._self, this._then);

  final MembershipChange _self;
  final $Res Function(MembershipChange) _then;

/// Create a copy of MembershipChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? unassignedTasks = null,Object? warning = null,}) {
  return _then(MembershipChange(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,unassignedTasks: null == unassignedTasks ? _self.unassignedTasks : unassignedTasks // ignore: cast_nullable_to_non_nullable
as int,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipChange].
extension MembershipChangePatterns on MembershipChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipChange value)  $default,){
final _that = this;
switch (_that) {
case _MembershipChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipChange value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'unassigned_tasks')  int unassignedTasks,  bool warning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipChange() when $default != null:
return $default(_that.membershipId,_that.unassignedTasks,_that.warning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'unassigned_tasks')  int unassignedTasks,  bool warning)  $default,) {final _that = this;
switch (_that) {
case _MembershipChange():
return $default(_that.membershipId,_that.unassignedTasks,_that.warning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'membership_id')  String membershipId, @JsonKey(name: 'unassigned_tasks')  int unassignedTasks,  bool warning)?  $default,) {final _that = this;
switch (_that) {
case _MembershipChange() when $default != null:
return $default(_that.membershipId,_that.unassignedTasks,_that.warning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipChange implements MembershipChange {
  const _MembershipChange({@JsonKey(name: 'membership_id') required this.membershipId, @JsonKey(name: 'unassigned_tasks') required this.unassignedTasks, required this.warning});
  factory _MembershipChange.fromJson(Map<String, dynamic> json) => _$MembershipChangeFromJson(json);

@override@JsonKey(name: 'membership_id') final  String membershipId;
@override@JsonKey(name: 'unassigned_tasks') final  int unassignedTasks;
@override final  bool warning;

/// Create a copy of MembershipChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipChangeCopyWith<_MembershipChange> get copyWith => __$MembershipChangeCopyWithImpl<_MembershipChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipChange&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.unassignedTasks, unassignedTasks) || other.unassignedTasks == unassignedTasks)&&(identical(other.warning, warning) || other.warning == warning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,membershipId,unassignedTasks,warning);
}

@override
String toString() {
    return 'MembershipChange(membershipId: $membershipId, unassignedTasks: $unassignedTasks, warning: $warning)';
}


}

/// @nodoc
abstract mixin class _$MembershipChangeCopyWith<$Res> implements $MembershipChangeCopyWith<$Res> {
  factory _$MembershipChangeCopyWith(_MembershipChange value, $Res Function(_MembershipChange) _then) = __$MembershipChangeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'membership_id') String membershipId,@JsonKey(name: 'unassigned_tasks') int unassignedTasks, bool warning
});




}
/// @nodoc
class __$MembershipChangeCopyWithImpl<$Res>
    implements _$MembershipChangeCopyWith<$Res> {
  __$MembershipChangeCopyWithImpl(this._self, this._then);

  final _MembershipChange _self;
  final $Res Function(_MembershipChange) _then;

/// Create a copy of MembershipChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? unassignedTasks = null,Object? warning = null,}) {
  return _then(_MembershipChange(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,unassignedTasks: null == unassignedTasks ? _self.unassignedTasks : unassignedTasks // ignore: cast_nullable_to_non_nullable
as int,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
