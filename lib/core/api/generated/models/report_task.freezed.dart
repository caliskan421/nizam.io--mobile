// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'department_name') String get departmentName; String get status; ReportTaskPriority get priority;@JsonKey(name: 'start_on') DateTime get startOn;@JsonKey(name: 'end_on') DateTime get endOn;@JsonKey(name: 'planned_end_on') DateTime? get plannedEndOn;@JsonKey(name: 'completed_on') DateTime? get completedOn;@JsonKey(name: 'created_by') ReportPerson get createdBy; List<ReportPerson> get assignees;@JsonKey(name: 'is_overdue') bool get isOverdue;@JsonKey(name: 'days_overdue') int get daysOverdue;@JsonKey(name: 'is_completed_late') bool get isCompletedLate;@JsonKey(name: 'days_late') int get daysLate;@JsonKey(name: 'is_completed_early') bool get isCompletedEarly;@JsonKey(name: 'days_early') int get daysEarly;@JsonKey(name: 'has_pending_dependency') bool get hasPendingDependency;@JsonKey(name: 'dependency_count') int get dependencyCount;@JsonKey(name: 'note_count') int get noteCount;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTaskCopyWith<ReportTask> get copyWith => _$ReportTaskCopyWithImpl<ReportTask>(this as ReportTask, _$identity);

  /// Serializes this ReportTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&const DeepCollectionEquality().equals(other.assignees, _this.assignees)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.isCompletedLate, _this.isCompletedLate) || other.isCompletedLate == _this.isCompletedLate)&&(identical(other.daysLate, _this.daysLate) || other.daysLate == _this.daysLate)&&(identical(other.isCompletedEarly, _this.isCompletedEarly) || other.isCompletedEarly == _this.isCompletedEarly)&&(identical(other.daysEarly, _this.daysEarly) || other.daysEarly == _this.daysEarly)&&(identical(other.hasPendingDependency, _this.hasPendingDependency) || other.hasPendingDependency == _this.hasPendingDependency)&&(identical(other.dependencyCount, _this.dependencyCount) || other.dependencyCount == _this.dependencyCount)&&(identical(other.noteCount, _this.noteCount) || other.noteCount == _this.noteCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportTask;
  return Object.hashAll([runtimeType,_this.workItemId,_this.title,_this.departmentId,_this.departmentName,_this.status,_this.priority,_this.startOn,_this.endOn,_this.plannedEndOn,_this.completedOn,_this.createdBy,const DeepCollectionEquality().hash(_this.assignees),_this.isOverdue,_this.daysOverdue,_this.isCompletedLate,_this.daysLate,_this.isCompletedEarly,_this.daysEarly,_this.hasPendingDependency,_this.dependencyCount,_this.noteCount,_this.createdAt]);
}

@override
String toString() {
  final _this = this as ReportTask;
  return 'ReportTask(workItemId: ${_this.workItemId}, title: ${_this.title}, departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, status: ${_this.status}, priority: ${_this.priority}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, plannedEndOn: ${_this.plannedEndOn}, completedOn: ${_this.completedOn}, createdBy: ${_this.createdBy}, assignees: ${_this.assignees}, isOverdue: ${_this.isOverdue}, daysOverdue: ${_this.daysOverdue}, isCompletedLate: ${_this.isCompletedLate}, daysLate: ${_this.daysLate}, isCompletedEarly: ${_this.isCompletedEarly}, daysEarly: ${_this.daysEarly}, hasPendingDependency: ${_this.hasPendingDependency}, dependencyCount: ${_this.dependencyCount}, noteCount: ${_this.noteCount}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ReportTaskCopyWith<$Res>  {
  factory $ReportTaskCopyWith(ReportTask value, $Res Function(ReportTask) _then) = _$ReportTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, String status, ReportTaskPriority priority,@JsonKey(name: 'start_on') DateTime startOn,@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'created_by') ReportPerson createdBy, List<ReportPerson> assignees,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@JsonKey(name: 'has_pending_dependency') bool hasPendingDependency,@JsonKey(name: 'dependency_count') int dependencyCount,@JsonKey(name: 'note_count') int noteCount,@JsonKey(name: 'created_at') DateTime createdAt
});


$ReportPersonCopyWith<$Res> get createdBy;

}
/// @nodoc
class _$ReportTaskCopyWithImpl<$Res>
    implements $ReportTaskCopyWith<$Res> {
  _$ReportTaskCopyWithImpl(this._self, this._then);

  final ReportTask _self;
  final $Res Function(ReportTask) _then;

/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? departmentName = null,Object? status = null,Object? priority = null,Object? startOn = null,Object? endOn = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,Object? createdBy = null,Object? assignees = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? hasPendingDependency = null,Object? dependencyCount = null,Object? noteCount = null,Object? createdAt = null,}) {
  return _then(ReportTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReportTaskPriority,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ReportPerson,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,hasPendingDependency: null == hasPendingDependency ? _self.hasPendingDependency : hasPendingDependency // ignore: cast_nullable_to_non_nullable
as bool,dependencyCount: null == dependencyCount ? _self.dependencyCount : dependencyCount // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get createdBy {
  
  return $ReportPersonCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportTask].
extension ReportTaskPatterns on ReportTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTask value)  $default,){
final _that = this;
switch (_that) {
case _ReportTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTask value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  String status,  ReportTaskPriority priority, @JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'created_by')  ReportPerson createdBy,  List<ReportPerson> assignees, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'has_pending_dependency')  bool hasPendingDependency, @JsonKey(name: 'dependency_count')  int dependencyCount, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.status,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.createdBy,_that.assignees,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.hasPendingDependency,_that.dependencyCount,_that.noteCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  String status,  ReportTaskPriority priority, @JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'created_by')  ReportPerson createdBy,  List<ReportPerson> assignees, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'has_pending_dependency')  bool hasPendingDependency, @JsonKey(name: 'dependency_count')  int dependencyCount, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReportTask():
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.status,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.createdBy,_that.assignees,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.hasPendingDependency,_that.dependencyCount,_that.noteCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  String status,  ReportTaskPriority priority, @JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'created_by')  ReportPerson createdBy,  List<ReportPerson> assignees, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'has_pending_dependency')  bool hasPendingDependency, @JsonKey(name: 'dependency_count')  int dependencyCount, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.departmentName,_that.status,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.createdBy,_that.assignees,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.hasPendingDependency,_that.dependencyCount,_that.noteCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTask implements ReportTask {
  const _ReportTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, required this.status, required this.priority, @JsonKey(name: 'start_on') required this.startOn, @JsonKey(name: 'end_on') required this.endOn, @JsonKey(name: 'planned_end_on') required this.plannedEndOn, @JsonKey(name: 'completed_on') required this.completedOn, @JsonKey(name: 'created_by') required this.createdBy, required  List<ReportPerson> assignees, @JsonKey(name: 'is_overdue') required this.isOverdue, @JsonKey(name: 'days_overdue') required this.daysOverdue, @JsonKey(name: 'is_completed_late') required this.isCompletedLate, @JsonKey(name: 'days_late') required this.daysLate, @JsonKey(name: 'is_completed_early') required this.isCompletedEarly, @JsonKey(name: 'days_early') required this.daysEarly, @JsonKey(name: 'has_pending_dependency') required this.hasPendingDependency, @JsonKey(name: 'dependency_count') required this.dependencyCount, @JsonKey(name: 'note_count') required this.noteCount, @JsonKey(name: 'created_at') required this.createdAt}): _assignees = assignees;
  factory _ReportTask.fromJson(Map<String, dynamic> json) => _$ReportTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'department_name') final  String departmentName;
@override final  String status;
@override final  ReportTaskPriority priority;
@override@JsonKey(name: 'start_on') final  DateTime startOn;
@override@JsonKey(name: 'end_on') final  DateTime endOn;
@override@JsonKey(name: 'planned_end_on') final  DateTime? plannedEndOn;
@override@JsonKey(name: 'completed_on') final  DateTime? completedOn;
@override@JsonKey(name: 'created_by') final  ReportPerson createdBy;
 final  List<ReportPerson> _assignees;
@override List<ReportPerson> get assignees {
  if (_assignees is EqualUnmodifiableListView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignees);
}

@override@JsonKey(name: 'is_overdue') final  bool isOverdue;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;
@override@JsonKey(name: 'is_completed_late') final  bool isCompletedLate;
@override@JsonKey(name: 'days_late') final  int daysLate;
@override@JsonKey(name: 'is_completed_early') final  bool isCompletedEarly;
@override@JsonKey(name: 'days_early') final  int daysEarly;
@override@JsonKey(name: 'has_pending_dependency') final  bool hasPendingDependency;
@override@JsonKey(name: 'dependency_count') final  int dependencyCount;
@override@JsonKey(name: 'note_count') final  int noteCount;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTaskCopyWith<_ReportTask> get copyWith => __$ReportTaskCopyWithImpl<_ReportTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.assignees, _assignees)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.isCompletedLate, isCompletedLate) || other.isCompletedLate == isCompletedLate)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.isCompletedEarly, isCompletedEarly) || other.isCompletedEarly == isCompletedEarly)&&(identical(other.daysEarly, daysEarly) || other.daysEarly == daysEarly)&&(identical(other.hasPendingDependency, hasPendingDependency) || other.hasPendingDependency == hasPendingDependency)&&(identical(other.dependencyCount, dependencyCount) || other.dependencyCount == dependencyCount)&&(identical(other.noteCount, noteCount) || other.noteCount == noteCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,workItemId,title,departmentId,departmentName,status,priority,startOn,endOn,plannedEndOn,completedOn,createdBy,const DeepCollectionEquality().hash(_assignees),isOverdue,daysOverdue,isCompletedLate,daysLate,isCompletedEarly,daysEarly,hasPendingDependency,dependencyCount,noteCount,createdAt]);
}

@override
String toString() {
    return 'ReportTask(workItemId: $workItemId, title: $title, departmentId: $departmentId, departmentName: $departmentName, status: $status, priority: $priority, startOn: $startOn, endOn: $endOn, plannedEndOn: $plannedEndOn, completedOn: $completedOn, createdBy: $createdBy, assignees: $assignees, isOverdue: $isOverdue, daysOverdue: $daysOverdue, isCompletedLate: $isCompletedLate, daysLate: $daysLate, isCompletedEarly: $isCompletedEarly, daysEarly: $daysEarly, hasPendingDependency: $hasPendingDependency, dependencyCount: $dependencyCount, noteCount: $noteCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportTaskCopyWith<$Res> implements $ReportTaskCopyWith<$Res> {
  factory _$ReportTaskCopyWith(_ReportTask value, $Res Function(_ReportTask) _then) = __$ReportTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, String status, ReportTaskPriority priority,@JsonKey(name: 'start_on') DateTime startOn,@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'created_by') ReportPerson createdBy, List<ReportPerson> assignees,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@JsonKey(name: 'has_pending_dependency') bool hasPendingDependency,@JsonKey(name: 'dependency_count') int dependencyCount,@JsonKey(name: 'note_count') int noteCount,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $ReportPersonCopyWith<$Res> get createdBy;

}
/// @nodoc
class __$ReportTaskCopyWithImpl<$Res>
    implements _$ReportTaskCopyWith<$Res> {
  __$ReportTaskCopyWithImpl(this._self, this._then);

  final _ReportTask _self;
  final $Res Function(_ReportTask) _then;

/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? departmentName = null,Object? status = null,Object? priority = null,Object? startOn = null,Object? endOn = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,Object? createdBy = null,Object? assignees = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? hasPendingDependency = null,Object? dependencyCount = null,Object? noteCount = null,Object? createdAt = null,}) {
  return _then(_ReportTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReportTaskPriority,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ReportPerson,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,hasPendingDependency: null == hasPendingDependency ? _self.hasPendingDependency : hasPendingDependency // ignore: cast_nullable_to_non_nullable
as bool,dependencyCount: null == dependencyCount ? _self.dependencyCount : dependencyCount // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReportTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get createdBy {
  
  return $ReportPersonCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}

// dart format on
