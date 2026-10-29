// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overdue_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OverdueTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'department_name') String get departmentName; List<ReportPerson> get assignees;@JsonKey(name: 'due_on') DateTime get dueOn;@JsonKey(name: 'days_overdue') int get daysOverdue;
/// Create a copy of OverdueTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverdueTaskCopyWith<OverdueTask> get copyWith => _$OverdueTaskCopyWithImpl<OverdueTask>(this as OverdueTask, _$identity);

  /// Serializes this OverdueTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OverdueTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverdueTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&const DeepCollectionEquality().equals(other.assignees, _this.assignees)&&(identical(other.dueOn, _this.dueOn) || other.dueOn == _this.dueOn)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OverdueTask;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.departmentId,_this.departmentName,const DeepCollectionEquality().hash(_this.assignees),_this.dueOn,_this.daysOverdue);
}

@override
String toString() {
  final _this = this as OverdueTask;
  return 'OverdueTask(workItemId: ${_this.workItemId}, title: ${_this.title}, departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, assignees: ${_this.assignees}, dueOn: ${_this.dueOn}, daysOverdue: ${_this.daysOverdue})';
}


}

/// @nodoc
abstract mixin class $OverdueTaskCopyWith<$Res>  {
  factory $OverdueTaskCopyWith(OverdueTask value, $Res Function(OverdueTask) _then) = _$OverdueTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, List<ReportPerson> assignees,@JsonKey(name: 'due_on') DateTime dueOn,@JsonKey(name: 'days_overdue') int daysOverdue
});




}
/// @nodoc
class _$OverdueTaskCopyWithImpl<$Res>
    implements $OverdueTaskCopyWith<$Res> {
  _$OverdueTaskCopyWithImpl(this._self, this._then);

  final OverdueTask _self;
  final $Res Function(OverdueTask) _then;

/// Create a copy of OverdueTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? departmentName = null,Object? assignees = null,Object? dueOn = null,Object? daysOverdue = null,}) {
  return _then(OverdueTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,dueOn: null == dueOn ? _self.dueOn : dueOn // ignore: cast_nullable_to_non_nullable
as DateTime,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OverdueTask].
extension OverdueTaskPatterns on OverdueTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverdueTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverdueTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverdueTask value)  $default,){
final _that = this;
switch (_that) {
case _OverdueTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverdueTask value)?  $default,){
final _that = this;
switch (_that) {
case _OverdueTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  List<ReportPerson> assignees, @JsonKey(name: 'due_on')  DateTime dueOn, @JsonKey(name: 'days_overdue')  int daysOverdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverdueTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.assignees,_that.dueOn,_that.daysOverdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  List<ReportPerson> assignees, @JsonKey(name: 'due_on')  DateTime dueOn, @JsonKey(name: 'days_overdue')  int daysOverdue)  $default,) {final _that = this;
switch (_that) {
case _OverdueTask():
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.assignees,_that.dueOn,_that.daysOverdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  List<ReportPerson> assignees, @JsonKey(name: 'due_on')  DateTime dueOn, @JsonKey(name: 'days_overdue')  int daysOverdue)?  $default,) {final _that = this;
switch (_that) {
case _OverdueTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.assignees,_that.dueOn,_that.daysOverdue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverdueTask implements OverdueTask {
  const _OverdueTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, required  List<ReportPerson> assignees, @JsonKey(name: 'due_on') required this.dueOn, @JsonKey(name: 'days_overdue') required this.daysOverdue}): _assignees = assignees;
  factory _OverdueTask.fromJson(Map<String, dynamic> json) => _$OverdueTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'department_name') final  String departmentName;
 final  List<ReportPerson> _assignees;
@override List<ReportPerson> get assignees {
  if (_assignees is EqualUnmodifiableListView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignees);
}

@override@JsonKey(name: 'due_on') final  DateTime dueOn;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;

/// Create a copy of OverdueTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverdueTaskCopyWith<_OverdueTask> get copyWith => __$OverdueTaskCopyWithImpl<_OverdueTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverdueTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverdueTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&const DeepCollectionEquality().equals(other.assignees, _assignees)&&(identical(other.dueOn, dueOn) || other.dueOn == dueOn)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,departmentId,departmentName,const DeepCollectionEquality().hash(_assignees),dueOn,daysOverdue);
}

@override
String toString() {
    return 'OverdueTask(workItemId: $workItemId, title: $title, departmentId: $departmentId, departmentName: $departmentName, assignees: $assignees, dueOn: $dueOn, daysOverdue: $daysOverdue)';
}


}

/// @nodoc
abstract mixin class _$OverdueTaskCopyWith<$Res> implements $OverdueTaskCopyWith<$Res> {
  factory _$OverdueTaskCopyWith(_OverdueTask value, $Res Function(_OverdueTask) _then) = __$OverdueTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, List<ReportPerson> assignees,@JsonKey(name: 'due_on') DateTime dueOn,@JsonKey(name: 'days_overdue') int daysOverdue
});




}
/// @nodoc
class __$OverdueTaskCopyWithImpl<$Res>
    implements _$OverdueTaskCopyWith<$Res> {
  __$OverdueTaskCopyWithImpl(this._self, this._then);

  final _OverdueTask _self;
  final $Res Function(_OverdueTask) _then;

/// Create a copy of OverdueTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? departmentName = null,Object? assignees = null,Object? dueOn = null,Object? daysOverdue = null,}) {
  return _then(_OverdueTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,dueOn: null == dueOn ? _self.dueOn : dueOn // ignore: cast_nullable_to_non_nullable
as DateTime,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
