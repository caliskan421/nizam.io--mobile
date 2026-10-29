// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardReport {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName;@JsonKey(name: 'total_coordinatorships') int get totalCoordinatorships;@JsonKey(name: 'total_tasks') int get totalTasks;@JsonKey(name: 'active_tasks') int get activeTasks;@JsonKey(name: 'completed_tasks') int get completedTasks;@JsonKey(name: 'overdue_tasks') int get overdueTasks;@JsonKey(name: 'pending_approvals') int get pendingApprovals;@JsonKey(name: 'pending_date_changes') int get pendingDateChanges;@JsonKey(name: 'task_status_distribution') Map<String, int> get taskStatusDistribution;@JsonKey(name: 'priority_distribution') Map<String, int> get priorityDistribution;@JsonKey(name: 'total_users') int get totalUsers;@JsonKey(name: 'total_admins') int get totalAdmins;@JsonKey(name: 'total_coordinators') int get totalCoordinators;@JsonKey(name: 'total_members') int get totalMembers;@JsonKey(name: 'deleted_records') int get deletedRecords;@JsonKey(name: 'coordinatorship_stats') List<CoordinatorshipStat> get coordinatorshipStats;@JsonKey(name: 'overdue_tasks_list') List<OverdueTask> get overdueTasksList;@JsonKey(name: 'generated_at') DateTime get generatedAt;
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<DashboardReport> get copyWith => _$DashboardReportCopyWithImpl<DashboardReport>(this as DashboardReport, _$identity);

  /// Serializes this DashboardReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReport&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.totalCoordinatorships, _this.totalCoordinatorships) || other.totalCoordinatorships == _this.totalCoordinatorships)&&(identical(other.totalTasks, _this.totalTasks) || other.totalTasks == _this.totalTasks)&&(identical(other.activeTasks, _this.activeTasks) || other.activeTasks == _this.activeTasks)&&(identical(other.completedTasks, _this.completedTasks) || other.completedTasks == _this.completedTasks)&&(identical(other.overdueTasks, _this.overdueTasks) || other.overdueTasks == _this.overdueTasks)&&(identical(other.pendingApprovals, _this.pendingApprovals) || other.pendingApprovals == _this.pendingApprovals)&&(identical(other.pendingDateChanges, _this.pendingDateChanges) || other.pendingDateChanges == _this.pendingDateChanges)&&const DeepCollectionEquality().equals(other.taskStatusDistribution, _this.taskStatusDistribution)&&const DeepCollectionEquality().equals(other.priorityDistribution, _this.priorityDistribution)&&(identical(other.totalUsers, _this.totalUsers) || other.totalUsers == _this.totalUsers)&&(identical(other.totalAdmins, _this.totalAdmins) || other.totalAdmins == _this.totalAdmins)&&(identical(other.totalCoordinators, _this.totalCoordinators) || other.totalCoordinators == _this.totalCoordinators)&&(identical(other.totalMembers, _this.totalMembers) || other.totalMembers == _this.totalMembers)&&(identical(other.deletedRecords, _this.deletedRecords) || other.deletedRecords == _this.deletedRecords)&&const DeepCollectionEquality().equals(other.coordinatorshipStats, _this.coordinatorshipStats)&&const DeepCollectionEquality().equals(other.overdueTasksList, _this.overdueTasksList)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardReport;
  return Object.hashAll([runtimeType,_this.programId,_this.programName,_this.totalCoordinatorships,_this.totalTasks,_this.activeTasks,_this.completedTasks,_this.overdueTasks,_this.pendingApprovals,_this.pendingDateChanges,const DeepCollectionEquality().hash(_this.taskStatusDistribution),const DeepCollectionEquality().hash(_this.priorityDistribution),_this.totalUsers,_this.totalAdmins,_this.totalCoordinators,_this.totalMembers,_this.deletedRecords,const DeepCollectionEquality().hash(_this.coordinatorshipStats),const DeepCollectionEquality().hash(_this.overdueTasksList),_this.generatedAt]);
}

@override
String toString() {
  final _this = this as DashboardReport;
  return 'DashboardReport(programId: ${_this.programId}, programName: ${_this.programName}, totalCoordinatorships: ${_this.totalCoordinatorships}, totalTasks: ${_this.totalTasks}, activeTasks: ${_this.activeTasks}, completedTasks: ${_this.completedTasks}, overdueTasks: ${_this.overdueTasks}, pendingApprovals: ${_this.pendingApprovals}, pendingDateChanges: ${_this.pendingDateChanges}, taskStatusDistribution: ${_this.taskStatusDistribution}, priorityDistribution: ${_this.priorityDistribution}, totalUsers: ${_this.totalUsers}, totalAdmins: ${_this.totalAdmins}, totalCoordinators: ${_this.totalCoordinators}, totalMembers: ${_this.totalMembers}, deletedRecords: ${_this.deletedRecords}, coordinatorshipStats: ${_this.coordinatorshipStats}, overdueTasksList: ${_this.overdueTasksList}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $DashboardReportCopyWith<$Res>  {
  factory $DashboardReportCopyWith(DashboardReport value, $Res Function(DashboardReport) _then) = _$DashboardReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'total_coordinatorships') int totalCoordinatorships,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'active_tasks') int activeTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'pending_approvals') int pendingApprovals,@JsonKey(name: 'pending_date_changes') int pendingDateChanges,@JsonKey(name: 'task_status_distribution') Map<String, int> taskStatusDistribution,@JsonKey(name: 'priority_distribution') Map<String, int> priorityDistribution,@JsonKey(name: 'total_users') int totalUsers,@JsonKey(name: 'total_admins') int totalAdmins,@JsonKey(name: 'total_coordinators') int totalCoordinators,@JsonKey(name: 'total_members') int totalMembers,@JsonKey(name: 'deleted_records') int deletedRecords,@JsonKey(name: 'coordinatorship_stats') List<CoordinatorshipStat> coordinatorshipStats,@JsonKey(name: 'overdue_tasks_list') List<OverdueTask> overdueTasksList,@JsonKey(name: 'generated_at') DateTime generatedAt
});




}
/// @nodoc
class _$DashboardReportCopyWithImpl<$Res>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._self, this._then);

  final DashboardReport _self;
  final $Res Function(DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? totalCoordinatorships = null,Object? totalTasks = null,Object? activeTasks = null,Object? completedTasks = null,Object? overdueTasks = null,Object? pendingApprovals = null,Object? pendingDateChanges = null,Object? taskStatusDistribution = null,Object? priorityDistribution = null,Object? totalUsers = null,Object? totalAdmins = null,Object? totalCoordinators = null,Object? totalMembers = null,Object? deletedRecords = null,Object? coordinatorshipStats = null,Object? overdueTasksList = null,Object? generatedAt = null,}) {
  return _then(DashboardReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,totalCoordinatorships: null == totalCoordinatorships ? _self.totalCoordinatorships : totalCoordinatorships // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,activeTasks: null == activeTasks ? _self.activeTasks : activeTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as int,pendingDateChanges: null == pendingDateChanges ? _self.pendingDateChanges : pendingDateChanges // ignore: cast_nullable_to_non_nullable
as int,taskStatusDistribution: null == taskStatusDistribution ? _self.taskStatusDistribution : taskStatusDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,priorityDistribution: null == priorityDistribution ? _self.priorityDistribution : priorityDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,totalAdmins: null == totalAdmins ? _self.totalAdmins : totalAdmins // ignore: cast_nullable_to_non_nullable
as int,totalCoordinators: null == totalCoordinators ? _self.totalCoordinators : totalCoordinators // ignore: cast_nullable_to_non_nullable
as int,totalMembers: null == totalMembers ? _self.totalMembers : totalMembers // ignore: cast_nullable_to_non_nullable
as int,deletedRecords: null == deletedRecords ? _self.deletedRecords : deletedRecords // ignore: cast_nullable_to_non_nullable
as int,coordinatorshipStats: null == coordinatorshipStats ? _self.coordinatorshipStats : coordinatorshipStats // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,overdueTasksList: null == overdueTasksList ? _self.overdueTasksList : overdueTasksList // ignore: cast_nullable_to_non_nullable
as List<OverdueTask>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardReport].
extension DashboardReportPatterns on DashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'active_tasks')  int activeTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'pending_approvals')  int pendingApprovals, @JsonKey(name: 'pending_date_changes')  int pendingDateChanges, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_admins')  int totalAdmins, @JsonKey(name: 'total_coordinators')  int totalCoordinators, @JsonKey(name: 'total_members')  int totalMembers, @JsonKey(name: 'deleted_records')  int deletedRecords, @JsonKey(name: 'coordinatorship_stats')  List<CoordinatorshipStat> coordinatorshipStats, @JsonKey(name: 'overdue_tasks_list')  List<OverdueTask> overdueTasksList, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.programId,_that.programName,_that.totalCoordinatorships,_that.totalTasks,_that.activeTasks,_that.completedTasks,_that.overdueTasks,_that.pendingApprovals,_that.pendingDateChanges,_that.taskStatusDistribution,_that.priorityDistribution,_that.totalUsers,_that.totalAdmins,_that.totalCoordinators,_that.totalMembers,_that.deletedRecords,_that.coordinatorshipStats,_that.overdueTasksList,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'active_tasks')  int activeTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'pending_approvals')  int pendingApprovals, @JsonKey(name: 'pending_date_changes')  int pendingDateChanges, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_admins')  int totalAdmins, @JsonKey(name: 'total_coordinators')  int totalCoordinators, @JsonKey(name: 'total_members')  int totalMembers, @JsonKey(name: 'deleted_records')  int deletedRecords, @JsonKey(name: 'coordinatorship_stats')  List<CoordinatorshipStat> coordinatorshipStats, @JsonKey(name: 'overdue_tasks_list')  List<OverdueTask> overdueTasksList, @JsonKey(name: 'generated_at')  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _DashboardReport():
return $default(_that.programId,_that.programName,_that.totalCoordinatorships,_that.totalTasks,_that.activeTasks,_that.completedTasks,_that.overdueTasks,_that.pendingApprovals,_that.pendingDateChanges,_that.taskStatusDistribution,_that.priorityDistribution,_that.totalUsers,_that.totalAdmins,_that.totalCoordinators,_that.totalMembers,_that.deletedRecords,_that.coordinatorshipStats,_that.overdueTasksList,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'active_tasks')  int activeTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'pending_approvals')  int pendingApprovals, @JsonKey(name: 'pending_date_changes')  int pendingDateChanges, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_admins')  int totalAdmins, @JsonKey(name: 'total_coordinators')  int totalCoordinators, @JsonKey(name: 'total_members')  int totalMembers, @JsonKey(name: 'deleted_records')  int deletedRecords, @JsonKey(name: 'coordinatorship_stats')  List<CoordinatorshipStat> coordinatorshipStats, @JsonKey(name: 'overdue_tasks_list')  List<OverdueTask> overdueTasksList, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.programId,_that.programName,_that.totalCoordinatorships,_that.totalTasks,_that.activeTasks,_that.completedTasks,_that.overdueTasks,_that.pendingApprovals,_that.pendingDateChanges,_that.taskStatusDistribution,_that.priorityDistribution,_that.totalUsers,_that.totalAdmins,_that.totalCoordinators,_that.totalMembers,_that.deletedRecords,_that.coordinatorshipStats,_that.overdueTasksList,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReport implements DashboardReport {
  const _DashboardReport({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, @JsonKey(name: 'total_coordinatorships') required this.totalCoordinatorships, @JsonKey(name: 'total_tasks') required this.totalTasks, @JsonKey(name: 'active_tasks') required this.activeTasks, @JsonKey(name: 'completed_tasks') required this.completedTasks, @JsonKey(name: 'overdue_tasks') required this.overdueTasks, @JsonKey(name: 'pending_approvals') required this.pendingApprovals, @JsonKey(name: 'pending_date_changes') required this.pendingDateChanges, @JsonKey(name: 'task_status_distribution') required  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution') required  Map<String, int> priorityDistribution, @JsonKey(name: 'total_users') required this.totalUsers, @JsonKey(name: 'total_admins') required this.totalAdmins, @JsonKey(name: 'total_coordinators') required this.totalCoordinators, @JsonKey(name: 'total_members') required this.totalMembers, @JsonKey(name: 'deleted_records') required this.deletedRecords, @JsonKey(name: 'coordinatorship_stats') required  List<CoordinatorshipStat> coordinatorshipStats, @JsonKey(name: 'overdue_tasks_list') required  List<OverdueTask> overdueTasksList, @JsonKey(name: 'generated_at') required this.generatedAt}): _taskStatusDistribution = taskStatusDistribution,_priorityDistribution = priorityDistribution,_coordinatorshipStats = coordinatorshipStats,_overdueTasksList = overdueTasksList;
  factory _DashboardReport.fromJson(Map<String, dynamic> json) => _$DashboardReportFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
@override@JsonKey(name: 'total_coordinatorships') final  int totalCoordinatorships;
@override@JsonKey(name: 'total_tasks') final  int totalTasks;
@override@JsonKey(name: 'active_tasks') final  int activeTasks;
@override@JsonKey(name: 'completed_tasks') final  int completedTasks;
@override@JsonKey(name: 'overdue_tasks') final  int overdueTasks;
@override@JsonKey(name: 'pending_approvals') final  int pendingApprovals;
@override@JsonKey(name: 'pending_date_changes') final  int pendingDateChanges;
 final  Map<String, int> _taskStatusDistribution;
@override@JsonKey(name: 'task_status_distribution') Map<String, int> get taskStatusDistribution {
  if (_taskStatusDistribution is EqualUnmodifiableMapView) return _taskStatusDistribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_taskStatusDistribution);
}

 final  Map<String, int> _priorityDistribution;
@override@JsonKey(name: 'priority_distribution') Map<String, int> get priorityDistribution {
  if (_priorityDistribution is EqualUnmodifiableMapView) return _priorityDistribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_priorityDistribution);
}

@override@JsonKey(name: 'total_users') final  int totalUsers;
@override@JsonKey(name: 'total_admins') final  int totalAdmins;
@override@JsonKey(name: 'total_coordinators') final  int totalCoordinators;
@override@JsonKey(name: 'total_members') final  int totalMembers;
@override@JsonKey(name: 'deleted_records') final  int deletedRecords;
 final  List<CoordinatorshipStat> _coordinatorshipStats;
@override@JsonKey(name: 'coordinatorship_stats') List<CoordinatorshipStat> get coordinatorshipStats {
  if (_coordinatorshipStats is EqualUnmodifiableListView) return _coordinatorshipStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorshipStats);
}

 final  List<OverdueTask> _overdueTasksList;
@override@JsonKey(name: 'overdue_tasks_list') List<OverdueTask> get overdueTasksList {
  if (_overdueTasksList is EqualUnmodifiableListView) return _overdueTasksList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdueTasksList);
}

@override@JsonKey(name: 'generated_at') final  DateTime generatedAt;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportCopyWith<_DashboardReport> get copyWith => __$DashboardReportCopyWithImpl<_DashboardReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReport&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.totalCoordinatorships, totalCoordinatorships) || other.totalCoordinatorships == totalCoordinatorships)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.activeTasks, activeTasks) || other.activeTasks == activeTasks)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.overdueTasks, overdueTasks) || other.overdueTasks == overdueTasks)&&(identical(other.pendingApprovals, pendingApprovals) || other.pendingApprovals == pendingApprovals)&&(identical(other.pendingDateChanges, pendingDateChanges) || other.pendingDateChanges == pendingDateChanges)&&const DeepCollectionEquality().equals(other.taskStatusDistribution, _taskStatusDistribution)&&const DeepCollectionEquality().equals(other.priorityDistribution, _priorityDistribution)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.totalAdmins, totalAdmins) || other.totalAdmins == totalAdmins)&&(identical(other.totalCoordinators, totalCoordinators) || other.totalCoordinators == totalCoordinators)&&(identical(other.totalMembers, totalMembers) || other.totalMembers == totalMembers)&&(identical(other.deletedRecords, deletedRecords) || other.deletedRecords == deletedRecords)&&const DeepCollectionEquality().equals(other.coordinatorshipStats, _coordinatorshipStats)&&const DeepCollectionEquality().equals(other.overdueTasksList, _overdueTasksList)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,programId,programName,totalCoordinatorships,totalTasks,activeTasks,completedTasks,overdueTasks,pendingApprovals,pendingDateChanges,const DeepCollectionEquality().hash(_taskStatusDistribution),const DeepCollectionEquality().hash(_priorityDistribution),totalUsers,totalAdmins,totalCoordinators,totalMembers,deletedRecords,const DeepCollectionEquality().hash(_coordinatorshipStats),const DeepCollectionEquality().hash(_overdueTasksList),generatedAt]);
}

@override
String toString() {
    return 'DashboardReport(programId: $programId, programName: $programName, totalCoordinatorships: $totalCoordinatorships, totalTasks: $totalTasks, activeTasks: $activeTasks, completedTasks: $completedTasks, overdueTasks: $overdueTasks, pendingApprovals: $pendingApprovals, pendingDateChanges: $pendingDateChanges, taskStatusDistribution: $taskStatusDistribution, priorityDistribution: $priorityDistribution, totalUsers: $totalUsers, totalAdmins: $totalAdmins, totalCoordinators: $totalCoordinators, totalMembers: $totalMembers, deletedRecords: $deletedRecords, coordinatorshipStats: $coordinatorshipStats, overdueTasksList: $overdueTasksList, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportCopyWith<$Res> implements $DashboardReportCopyWith<$Res> {
  factory _$DashboardReportCopyWith(_DashboardReport value, $Res Function(_DashboardReport) _then) = __$DashboardReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'total_coordinatorships') int totalCoordinatorships,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'active_tasks') int activeTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'pending_approvals') int pendingApprovals,@JsonKey(name: 'pending_date_changes') int pendingDateChanges,@JsonKey(name: 'task_status_distribution') Map<String, int> taskStatusDistribution,@JsonKey(name: 'priority_distribution') Map<String, int> priorityDistribution,@JsonKey(name: 'total_users') int totalUsers,@JsonKey(name: 'total_admins') int totalAdmins,@JsonKey(name: 'total_coordinators') int totalCoordinators,@JsonKey(name: 'total_members') int totalMembers,@JsonKey(name: 'deleted_records') int deletedRecords,@JsonKey(name: 'coordinatorship_stats') List<CoordinatorshipStat> coordinatorshipStats,@JsonKey(name: 'overdue_tasks_list') List<OverdueTask> overdueTasksList,@JsonKey(name: 'generated_at') DateTime generatedAt
});




}
/// @nodoc
class __$DashboardReportCopyWithImpl<$Res>
    implements _$DashboardReportCopyWith<$Res> {
  __$DashboardReportCopyWithImpl(this._self, this._then);

  final _DashboardReport _self;
  final $Res Function(_DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? totalCoordinatorships = null,Object? totalTasks = null,Object? activeTasks = null,Object? completedTasks = null,Object? overdueTasks = null,Object? pendingApprovals = null,Object? pendingDateChanges = null,Object? taskStatusDistribution = null,Object? priorityDistribution = null,Object? totalUsers = null,Object? totalAdmins = null,Object? totalCoordinators = null,Object? totalMembers = null,Object? deletedRecords = null,Object? coordinatorshipStats = null,Object? overdueTasksList = null,Object? generatedAt = null,}) {
  return _then(_DashboardReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,totalCoordinatorships: null == totalCoordinatorships ? _self.totalCoordinatorships : totalCoordinatorships // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,activeTasks: null == activeTasks ? _self.activeTasks : activeTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as int,pendingDateChanges: null == pendingDateChanges ? _self.pendingDateChanges : pendingDateChanges // ignore: cast_nullable_to_non_nullable
as int,taskStatusDistribution: null == taskStatusDistribution ? _self._taskStatusDistribution : taskStatusDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,priorityDistribution: null == priorityDistribution ? _self._priorityDistribution : priorityDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,totalAdmins: null == totalAdmins ? _self.totalAdmins : totalAdmins // ignore: cast_nullable_to_non_nullable
as int,totalCoordinators: null == totalCoordinators ? _self.totalCoordinators : totalCoordinators // ignore: cast_nullable_to_non_nullable
as int,totalMembers: null == totalMembers ? _self.totalMembers : totalMembers // ignore: cast_nullable_to_non_nullable
as int,deletedRecords: null == deletedRecords ? _self.deletedRecords : deletedRecords // ignore: cast_nullable_to_non_nullable
as int,coordinatorshipStats: null == coordinatorshipStats ? _self._coordinatorshipStats : coordinatorshipStats // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,overdueTasksList: null == overdueTasksList ? _self._overdueTasksList : overdueTasksList // ignore: cast_nullable_to_non_nullable
as List<OverdueTask>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
