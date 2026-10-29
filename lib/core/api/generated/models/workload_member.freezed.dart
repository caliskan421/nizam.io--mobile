// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workload_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkloadMember {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; List<ReportDepartment> get coordinatorships; List<WorkloadTask> get tasks;
/// Create a copy of WorkloadMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkloadMemberCopyWith<WorkloadMember> get copyWith => _$WorkloadMemberCopyWithImpl<WorkloadMember>(this as WorkloadMember, _$identity);

  /// Serializes this WorkloadMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkloadMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkloadMember&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&const DeepCollectionEquality().equals(other.coordinatorships, _this.coordinatorships)&&const DeepCollectionEquality().equals(other.tasks, _this.tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkloadMember;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,const DeepCollectionEquality().hash(_this.coordinatorships),const DeepCollectionEquality().hash(_this.tasks));
}

@override
String toString() {
  final _this = this as WorkloadMember;
  return 'WorkloadMember(accountId: ${_this.accountId}, fullName: ${_this.fullName}, coordinatorships: ${_this.coordinatorships}, tasks: ${_this.tasks})';
}


}

/// @nodoc
abstract mixin class $WorkloadMemberCopyWith<$Res>  {
  factory $WorkloadMemberCopyWith(WorkloadMember value, $Res Function(WorkloadMember) _then) = _$WorkloadMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<ReportDepartment> coordinatorships, List<WorkloadTask> tasks
});




}
/// @nodoc
class _$WorkloadMemberCopyWithImpl<$Res>
    implements $WorkloadMemberCopyWith<$Res> {
  _$WorkloadMemberCopyWithImpl(this._self, this._then);

  final WorkloadMember _self;
  final $Res Function(WorkloadMember) _then;

/// Create a copy of WorkloadMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? coordinatorships = null,Object? tasks = null,}) {
  return _then(WorkloadMember(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,coordinatorships: null == coordinatorships ? _self.coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportDepartment>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<WorkloadTask>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkloadMember].
extension WorkloadMemberPatterns on WorkloadMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkloadMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkloadMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkloadMember value)  $default,){
final _that = this;
switch (_that) {
case _WorkloadMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkloadMember value)?  $default,){
final _that = this;
switch (_that) {
case _WorkloadMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ReportDepartment> coordinatorships,  List<WorkloadTask> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkloadMember() when $default != null:
return $default(_that.accountId,_that.fullName,_that.coordinatorships,_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ReportDepartment> coordinatorships,  List<WorkloadTask> tasks)  $default,) {final _that = this;
switch (_that) {
case _WorkloadMember():
return $default(_that.accountId,_that.fullName,_that.coordinatorships,_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ReportDepartment> coordinatorships,  List<WorkloadTask> tasks)?  $default,) {final _that = this;
switch (_that) {
case _WorkloadMember() when $default != null:
return $default(_that.accountId,_that.fullName,_that.coordinatorships,_that.tasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkloadMember implements WorkloadMember {
  const _WorkloadMember({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required  List<ReportDepartment> coordinatorships, required  List<WorkloadTask> tasks}): _coordinatorships = coordinatorships,_tasks = tasks;
  factory _WorkloadMember.fromJson(Map<String, dynamic> json) => _$WorkloadMemberFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
 final  List<ReportDepartment> _coordinatorships;
@override List<ReportDepartment> get coordinatorships {
  if (_coordinatorships is EqualUnmodifiableListView) return _coordinatorships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorships);
}

 final  List<WorkloadTask> _tasks;
@override List<WorkloadTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of WorkloadMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkloadMemberCopyWith<_WorkloadMember> get copyWith => __$WorkloadMemberCopyWithImpl<_WorkloadMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkloadMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkloadMember&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.coordinatorships, _coordinatorships)&&const DeepCollectionEquality().equals(other.tasks, _tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,const DeepCollectionEquality().hash(_coordinatorships),const DeepCollectionEquality().hash(_tasks));
}

@override
String toString() {
    return 'WorkloadMember(accountId: $accountId, fullName: $fullName, coordinatorships: $coordinatorships, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$WorkloadMemberCopyWith<$Res> implements $WorkloadMemberCopyWith<$Res> {
  factory _$WorkloadMemberCopyWith(_WorkloadMember value, $Res Function(_WorkloadMember) _then) = __$WorkloadMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<ReportDepartment> coordinatorships, List<WorkloadTask> tasks
});




}
/// @nodoc
class __$WorkloadMemberCopyWithImpl<$Res>
    implements _$WorkloadMemberCopyWith<$Res> {
  __$WorkloadMemberCopyWithImpl(this._self, this._then);

  final _WorkloadMember _self;
  final $Res Function(_WorkloadMember) _then;

/// Create a copy of WorkloadMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? coordinatorships = null,Object? tasks = null,}) {
  return _then(_WorkloadMember(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,coordinatorships: null == coordinatorships ? _self._coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportDepartment>,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<WorkloadTask>,
  ));
}


}

// dart format on
