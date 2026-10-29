// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gantt_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GanttTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'department_id') String get departmentId; GanttTaskPriority get priority; String get status;@JsonKey(name: 'start_on') String get startOn;@JsonKey(name: 'end_on') String get endOn;/// Boşsa planlanan bitiş `end_on`'dur.
@JsonKey(name: 'planned_end_on') String get plannedEndOn;/// Boşsa tamamlanmamış.
@JsonKey(name: 'completed_on') String get completedOn;@JsonKey(name: 'assignee_account_ids') List<String> get assigneeAccountIds; Lateness get lateness;
/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GanttTaskCopyWith<GanttTask> get copyWith => _$GanttTaskCopyWithImpl<GanttTask>(this as GanttTask, _$identity);

  /// Serializes this GanttTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GanttTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GanttTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _this.assigneeAccountIds)&&(identical(other.lateness, _this.lateness) || other.lateness == _this.lateness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GanttTask;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.programId,_this.departmentId,_this.priority,_this.status,_this.startOn,_this.endOn,_this.plannedEndOn,_this.completedOn,const DeepCollectionEquality().hash(_this.assigneeAccountIds),_this.lateness);
}

@override
String toString() {
  final _this = this as GanttTask;
  return 'GanttTask(workItemId: ${_this.workItemId}, title: ${_this.title}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, priority: ${_this.priority}, status: ${_this.status}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, plannedEndOn: ${_this.plannedEndOn}, completedOn: ${_this.completedOn}, assigneeAccountIds: ${_this.assigneeAccountIds}, lateness: ${_this.lateness})';
}


}

/// @nodoc
abstract mixin class $GanttTaskCopyWith<$Res>  {
  factory $GanttTaskCopyWith(GanttTask value, $Res Function(GanttTask) _then) = _$GanttTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, GanttTaskPriority priority, String status,@JsonKey(name: 'start_on') String startOn,@JsonKey(name: 'end_on') String endOn,@JsonKey(name: 'planned_end_on') String plannedEndOn,@JsonKey(name: 'completed_on') String completedOn,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds, Lateness lateness
});


$LatenessCopyWith<$Res> get lateness;

}
/// @nodoc
class _$GanttTaskCopyWithImpl<$Res>
    implements $GanttTaskCopyWith<$Res> {
  _$GanttTaskCopyWithImpl(this._self, this._then);

  final GanttTask _self;
  final $Res Function(GanttTask) _then;

/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? programId = null,Object? departmentId = null,Object? priority = null,Object? status = null,Object? startOn = null,Object? endOn = null,Object? plannedEndOn = null,Object? completedOn = null,Object? assigneeAccountIds = null,Object? lateness = null,}) {
  return _then(GanttTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as GanttTaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as String,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as String,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as String,completedOn: null == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as String,assigneeAccountIds: null == assigneeAccountIds ? _self.assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,lateness: null == lateness ? _self.lateness : lateness // ignore: cast_nullable_to_non_nullable
as Lateness,
  ));
}
/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatenessCopyWith<$Res> get lateness {
  
  return $LatenessCopyWith<$Res>(_self.lateness, (value) {
    return _then(_self.copyWith(lateness: value));
  });
}
}


/// Adds pattern-matching-related methods to [GanttTask].
extension GanttTaskPatterns on GanttTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GanttTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GanttTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GanttTask value)  $default,){
final _that = this;
switch (_that) {
case _GanttTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GanttTask value)?  $default,){
final _that = this;
switch (_that) {
case _GanttTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  GanttTaskPriority priority,  String status, @JsonKey(name: 'start_on')  String startOn, @JsonKey(name: 'end_on')  String endOn, @JsonKey(name: 'planned_end_on')  String plannedEndOn, @JsonKey(name: 'completed_on')  String completedOn, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  Lateness lateness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GanttTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.programId,_that.departmentId,_that.priority,_that.status,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.assigneeAccountIds,_that.lateness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  GanttTaskPriority priority,  String status, @JsonKey(name: 'start_on')  String startOn, @JsonKey(name: 'end_on')  String endOn, @JsonKey(name: 'planned_end_on')  String plannedEndOn, @JsonKey(name: 'completed_on')  String completedOn, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  Lateness lateness)  $default,) {final _that = this;
switch (_that) {
case _GanttTask():
return $default(_that.workItemId,_that.title,_that.programId,_that.departmentId,_that.priority,_that.status,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.assigneeAccountIds,_that.lateness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  GanttTaskPriority priority,  String status, @JsonKey(name: 'start_on')  String startOn, @JsonKey(name: 'end_on')  String endOn, @JsonKey(name: 'planned_end_on')  String plannedEndOn, @JsonKey(name: 'completed_on')  String completedOn, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  Lateness lateness)?  $default,) {final _that = this;
switch (_that) {
case _GanttTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.programId,_that.departmentId,_that.priority,_that.status,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.assigneeAccountIds,_that.lateness);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GanttTask implements GanttTask {
  const _GanttTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.priority, required this.status, @JsonKey(name: 'start_on') required this.startOn, @JsonKey(name: 'end_on') required this.endOn, @JsonKey(name: 'planned_end_on') required this.plannedEndOn, @JsonKey(name: 'completed_on') required this.completedOn, @JsonKey(name: 'assignee_account_ids') required  List<String> assigneeAccountIds, required this.lateness}): _assigneeAccountIds = assigneeAccountIds;
  factory _GanttTask.fromJson(Map<String, dynamic> json) => _$GanttTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  GanttTaskPriority priority;
@override final  String status;
@override@JsonKey(name: 'start_on') final  String startOn;
@override@JsonKey(name: 'end_on') final  String endOn;
/// Boşsa planlanan bitiş `end_on`'dur.
@override@JsonKey(name: 'planned_end_on') final  String plannedEndOn;
/// Boşsa tamamlanmamış.
@override@JsonKey(name: 'completed_on') final  String completedOn;
 final  List<String> _assigneeAccountIds;
@override@JsonKey(name: 'assignee_account_ids') List<String> get assigneeAccountIds {
  if (_assigneeAccountIds is EqualUnmodifiableListView) return _assigneeAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assigneeAccountIds);
}

@override final  Lateness lateness;

/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GanttTaskCopyWith<_GanttTask> get copyWith => __$GanttTaskCopyWithImpl<_GanttTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GanttTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GanttTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _assigneeAccountIds)&&(identical(other.lateness, lateness) || other.lateness == lateness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,programId,departmentId,priority,status,startOn,endOn,plannedEndOn,completedOn,const DeepCollectionEquality().hash(_assigneeAccountIds),lateness);
}

@override
String toString() {
    return 'GanttTask(workItemId: $workItemId, title: $title, programId: $programId, departmentId: $departmentId, priority: $priority, status: $status, startOn: $startOn, endOn: $endOn, plannedEndOn: $plannedEndOn, completedOn: $completedOn, assigneeAccountIds: $assigneeAccountIds, lateness: $lateness)';
}


}

/// @nodoc
abstract mixin class _$GanttTaskCopyWith<$Res> implements $GanttTaskCopyWith<$Res> {
  factory _$GanttTaskCopyWith(_GanttTask value, $Res Function(_GanttTask) _then) = __$GanttTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, GanttTaskPriority priority, String status,@JsonKey(name: 'start_on') String startOn,@JsonKey(name: 'end_on') String endOn,@JsonKey(name: 'planned_end_on') String plannedEndOn,@JsonKey(name: 'completed_on') String completedOn,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds, Lateness lateness
});


@override $LatenessCopyWith<$Res> get lateness;

}
/// @nodoc
class __$GanttTaskCopyWithImpl<$Res>
    implements _$GanttTaskCopyWith<$Res> {
  __$GanttTaskCopyWithImpl(this._self, this._then);

  final _GanttTask _self;
  final $Res Function(_GanttTask) _then;

/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? programId = null,Object? departmentId = null,Object? priority = null,Object? status = null,Object? startOn = null,Object? endOn = null,Object? plannedEndOn = null,Object? completedOn = null,Object? assigneeAccountIds = null,Object? lateness = null,}) {
  return _then(_GanttTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as GanttTaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as String,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as String,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as String,completedOn: null == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as String,assigneeAccountIds: null == assigneeAccountIds ? _self._assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,lateness: null == lateness ? _self.lateness : lateness // ignore: cast_nullable_to_non_nullable
as Lateness,
  ));
}

/// Create a copy of GanttTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatenessCopyWith<$Res> get lateness {
  
  return $LatenessCopyWith<$Res>(_self.lateness, (value) {
    return _then(_self.copyWith(lateness: value));
  });
}
}

// dart format on
