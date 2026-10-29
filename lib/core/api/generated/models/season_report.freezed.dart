// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeasonReport {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName; Stats get stats;@JsonKey(name: 'coordinatorship_performance') List<CoordinatorshipStat> get coordinatorshipPerformance;@JsonKey(name: 'task_status_distribution') Map<String, int> get taskStatusDistribution;@JsonKey(name: 'priority_distribution') Map<String, int> get priorityDistribution; List<ReportTask> get tasks;@JsonKey(name: 'meeting_stats') MeetingStats get meetingStats;@JsonKey(name: 'message_stats') MessageStats get messageStats;@JsonKey(name: 'date_change_stats') DateChangeStats get dateChangeStats;@JsonKey(name: 'monthly_activity') List<MonthlyActivity> get monthlyActivity;@JsonKey(name: 'generated_at') DateTime get generatedAt;
/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonReportCopyWith<SeasonReport> get copyWith => _$SeasonReportCopyWithImpl<SeasonReport>(this as SeasonReport, _$identity);

  /// Serializes this SeasonReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SeasonReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonReport&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.stats, _this.stats) || other.stats == _this.stats)&&const DeepCollectionEquality().equals(other.coordinatorshipPerformance, _this.coordinatorshipPerformance)&&const DeepCollectionEquality().equals(other.taskStatusDistribution, _this.taskStatusDistribution)&&const DeepCollectionEquality().equals(other.priorityDistribution, _this.priorityDistribution)&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&(identical(other.meetingStats, _this.meetingStats) || other.meetingStats == _this.meetingStats)&&(identical(other.messageStats, _this.messageStats) || other.messageStats == _this.messageStats)&&(identical(other.dateChangeStats, _this.dateChangeStats) || other.dateChangeStats == _this.dateChangeStats)&&const DeepCollectionEquality().equals(other.monthlyActivity, _this.monthlyActivity)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SeasonReport;
  return Object.hash(runtimeType,_this.programId,_this.programName,_this.stats,const DeepCollectionEquality().hash(_this.coordinatorshipPerformance),const DeepCollectionEquality().hash(_this.taskStatusDistribution),const DeepCollectionEquality().hash(_this.priorityDistribution),const DeepCollectionEquality().hash(_this.tasks),_this.meetingStats,_this.messageStats,_this.dateChangeStats,const DeepCollectionEquality().hash(_this.monthlyActivity),_this.generatedAt);
}

@override
String toString() {
  final _this = this as SeasonReport;
  return 'SeasonReport(programId: ${_this.programId}, programName: ${_this.programName}, stats: ${_this.stats}, coordinatorshipPerformance: ${_this.coordinatorshipPerformance}, taskStatusDistribution: ${_this.taskStatusDistribution}, priorityDistribution: ${_this.priorityDistribution}, tasks: ${_this.tasks}, meetingStats: ${_this.meetingStats}, messageStats: ${_this.messageStats}, dateChangeStats: ${_this.dateChangeStats}, monthlyActivity: ${_this.monthlyActivity}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $SeasonReportCopyWith<$Res>  {
  factory $SeasonReportCopyWith(SeasonReport value, $Res Function(SeasonReport) _then) = _$SeasonReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName, Stats stats,@JsonKey(name: 'coordinatorship_performance') List<CoordinatorshipStat> coordinatorshipPerformance,@JsonKey(name: 'task_status_distribution') Map<String, int> taskStatusDistribution,@JsonKey(name: 'priority_distribution') Map<String, int> priorityDistribution, List<ReportTask> tasks,@JsonKey(name: 'meeting_stats') MeetingStats meetingStats,@JsonKey(name: 'message_stats') MessageStats messageStats,@JsonKey(name: 'date_change_stats') DateChangeStats dateChangeStats,@JsonKey(name: 'monthly_activity') List<MonthlyActivity> monthlyActivity,@JsonKey(name: 'generated_at') DateTime generatedAt
});


$StatsCopyWith<$Res> get stats;$MeetingStatsCopyWith<$Res> get meetingStats;$MessageStatsCopyWith<$Res> get messageStats;$DateChangeStatsCopyWith<$Res> get dateChangeStats;

}
/// @nodoc
class _$SeasonReportCopyWithImpl<$Res>
    implements $SeasonReportCopyWith<$Res> {
  _$SeasonReportCopyWithImpl(this._self, this._then);

  final SeasonReport _self;
  final $Res Function(SeasonReport) _then;

/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? stats = null,Object? coordinatorshipPerformance = null,Object? taskStatusDistribution = null,Object? priorityDistribution = null,Object? tasks = null,Object? meetingStats = null,Object? messageStats = null,Object? dateChangeStats = null,Object? monthlyActivity = null,Object? generatedAt = null,}) {
  return _then(SeasonReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Stats,coordinatorshipPerformance: null == coordinatorshipPerformance ? _self.coordinatorshipPerformance : coordinatorshipPerformance // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,taskStatusDistribution: null == taskStatusDistribution ? _self.taskStatusDistribution : taskStatusDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,priorityDistribution: null == priorityDistribution ? _self.priorityDistribution : priorityDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ReportTask>,meetingStats: null == meetingStats ? _self.meetingStats : meetingStats // ignore: cast_nullable_to_non_nullable
as MeetingStats,messageStats: null == messageStats ? _self.messageStats : messageStats // ignore: cast_nullable_to_non_nullable
as MessageStats,dateChangeStats: null == dateChangeStats ? _self.dateChangeStats : dateChangeStats // ignore: cast_nullable_to_non_nullable
as DateChangeStats,monthlyActivity: null == monthlyActivity ? _self.monthlyActivity : monthlyActivity // ignore: cast_nullable_to_non_nullable
as List<MonthlyActivity>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsCopyWith<$Res> get stats {
  
  return $StatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingStatsCopyWith<$Res> get meetingStats {
  
  return $MeetingStatsCopyWith<$Res>(_self.meetingStats, (value) {
    return _then(_self.copyWith(meetingStats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageStatsCopyWith<$Res> get messageStats {
  
  return $MessageStatsCopyWith<$Res>(_self.messageStats, (value) {
    return _then(_self.copyWith(messageStats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateChangeStatsCopyWith<$Res> get dateChangeStats {
  
  return $DateChangeStatsCopyWith<$Res>(_self.dateChangeStats, (value) {
    return _then(_self.copyWith(dateChangeStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonReport].
extension SeasonReportPatterns on SeasonReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonReport value)  $default,){
final _that = this;
switch (_that) {
case _SeasonReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonReport value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  Stats stats, @JsonKey(name: 'coordinatorship_performance')  List<CoordinatorshipStat> coordinatorshipPerformance, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution,  List<ReportTask> tasks, @JsonKey(name: 'meeting_stats')  MeetingStats meetingStats, @JsonKey(name: 'message_stats')  MessageStats messageStats, @JsonKey(name: 'date_change_stats')  DateChangeStats dateChangeStats, @JsonKey(name: 'monthly_activity')  List<MonthlyActivity> monthlyActivity, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonReport() when $default != null:
return $default(_that.programId,_that.programName,_that.stats,_that.coordinatorshipPerformance,_that.taskStatusDistribution,_that.priorityDistribution,_that.tasks,_that.meetingStats,_that.messageStats,_that.dateChangeStats,_that.monthlyActivity,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  Stats stats, @JsonKey(name: 'coordinatorship_performance')  List<CoordinatorshipStat> coordinatorshipPerformance, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution,  List<ReportTask> tasks, @JsonKey(name: 'meeting_stats')  MeetingStats meetingStats, @JsonKey(name: 'message_stats')  MessageStats messageStats, @JsonKey(name: 'date_change_stats')  DateChangeStats dateChangeStats, @JsonKey(name: 'monthly_activity')  List<MonthlyActivity> monthlyActivity, @JsonKey(name: 'generated_at')  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _SeasonReport():
return $default(_that.programId,_that.programName,_that.stats,_that.coordinatorshipPerformance,_that.taskStatusDistribution,_that.priorityDistribution,_that.tasks,_that.meetingStats,_that.messageStats,_that.dateChangeStats,_that.monthlyActivity,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  Stats stats, @JsonKey(name: 'coordinatorship_performance')  List<CoordinatorshipStat> coordinatorshipPerformance, @JsonKey(name: 'task_status_distribution')  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution')  Map<String, int> priorityDistribution,  List<ReportTask> tasks, @JsonKey(name: 'meeting_stats')  MeetingStats meetingStats, @JsonKey(name: 'message_stats')  MessageStats messageStats, @JsonKey(name: 'date_change_stats')  DateChangeStats dateChangeStats, @JsonKey(name: 'monthly_activity')  List<MonthlyActivity> monthlyActivity, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeasonReport() when $default != null:
return $default(_that.programId,_that.programName,_that.stats,_that.coordinatorshipPerformance,_that.taskStatusDistribution,_that.priorityDistribution,_that.tasks,_that.meetingStats,_that.messageStats,_that.dateChangeStats,_that.monthlyActivity,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeasonReport implements SeasonReport {
  const _SeasonReport({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, required this.stats, @JsonKey(name: 'coordinatorship_performance') required  List<CoordinatorshipStat> coordinatorshipPerformance, @JsonKey(name: 'task_status_distribution') required  Map<String, int> taskStatusDistribution, @JsonKey(name: 'priority_distribution') required  Map<String, int> priorityDistribution, required  List<ReportTask> tasks, @JsonKey(name: 'meeting_stats') required this.meetingStats, @JsonKey(name: 'message_stats') required this.messageStats, @JsonKey(name: 'date_change_stats') required this.dateChangeStats, @JsonKey(name: 'monthly_activity') required  List<MonthlyActivity> monthlyActivity, @JsonKey(name: 'generated_at') required this.generatedAt}): _coordinatorshipPerformance = coordinatorshipPerformance,_taskStatusDistribution = taskStatusDistribution,_priorityDistribution = priorityDistribution,_tasks = tasks,_monthlyActivity = monthlyActivity;
  factory _SeasonReport.fromJson(Map<String, dynamic> json) => _$SeasonReportFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
@override final  Stats stats;
 final  List<CoordinatorshipStat> _coordinatorshipPerformance;
@override@JsonKey(name: 'coordinatorship_performance') List<CoordinatorshipStat> get coordinatorshipPerformance {
  if (_coordinatorshipPerformance is EqualUnmodifiableListView) return _coordinatorshipPerformance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorshipPerformance);
}

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

 final  List<ReportTask> _tasks;
@override List<ReportTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override@JsonKey(name: 'meeting_stats') final  MeetingStats meetingStats;
@override@JsonKey(name: 'message_stats') final  MessageStats messageStats;
@override@JsonKey(name: 'date_change_stats') final  DateChangeStats dateChangeStats;
 final  List<MonthlyActivity> _monthlyActivity;
@override@JsonKey(name: 'monthly_activity') List<MonthlyActivity> get monthlyActivity {
  if (_monthlyActivity is EqualUnmodifiableListView) return _monthlyActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthlyActivity);
}

@override@JsonKey(name: 'generated_at') final  DateTime generatedAt;

/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonReportCopyWith<_SeasonReport> get copyWith => __$SeasonReportCopyWithImpl<_SeasonReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonReport&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.coordinatorshipPerformance, _coordinatorshipPerformance)&&const DeepCollectionEquality().equals(other.taskStatusDistribution, _taskStatusDistribution)&&const DeepCollectionEquality().equals(other.priorityDistribution, _priorityDistribution)&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&(identical(other.meetingStats, meetingStats) || other.meetingStats == meetingStats)&&(identical(other.messageStats, messageStats) || other.messageStats == messageStats)&&(identical(other.dateChangeStats, dateChangeStats) || other.dateChangeStats == dateChangeStats)&&const DeepCollectionEquality().equals(other.monthlyActivity, _monthlyActivity)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,stats,const DeepCollectionEquality().hash(_coordinatorshipPerformance),const DeepCollectionEquality().hash(_taskStatusDistribution),const DeepCollectionEquality().hash(_priorityDistribution),const DeepCollectionEquality().hash(_tasks),meetingStats,messageStats,dateChangeStats,const DeepCollectionEquality().hash(_monthlyActivity),generatedAt);
}

@override
String toString() {
    return 'SeasonReport(programId: $programId, programName: $programName, stats: $stats, coordinatorshipPerformance: $coordinatorshipPerformance, taskStatusDistribution: $taskStatusDistribution, priorityDistribution: $priorityDistribution, tasks: $tasks, meetingStats: $meetingStats, messageStats: $messageStats, dateChangeStats: $dateChangeStats, monthlyActivity: $monthlyActivity, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$SeasonReportCopyWith<$Res> implements $SeasonReportCopyWith<$Res> {
  factory _$SeasonReportCopyWith(_SeasonReport value, $Res Function(_SeasonReport) _then) = __$SeasonReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName, Stats stats,@JsonKey(name: 'coordinatorship_performance') List<CoordinatorshipStat> coordinatorshipPerformance,@JsonKey(name: 'task_status_distribution') Map<String, int> taskStatusDistribution,@JsonKey(name: 'priority_distribution') Map<String, int> priorityDistribution, List<ReportTask> tasks,@JsonKey(name: 'meeting_stats') MeetingStats meetingStats,@JsonKey(name: 'message_stats') MessageStats messageStats,@JsonKey(name: 'date_change_stats') DateChangeStats dateChangeStats,@JsonKey(name: 'monthly_activity') List<MonthlyActivity> monthlyActivity,@JsonKey(name: 'generated_at') DateTime generatedAt
});


@override $StatsCopyWith<$Res> get stats;@override $MeetingStatsCopyWith<$Res> get meetingStats;@override $MessageStatsCopyWith<$Res> get messageStats;@override $DateChangeStatsCopyWith<$Res> get dateChangeStats;

}
/// @nodoc
class __$SeasonReportCopyWithImpl<$Res>
    implements _$SeasonReportCopyWith<$Res> {
  __$SeasonReportCopyWithImpl(this._self, this._then);

  final _SeasonReport _self;
  final $Res Function(_SeasonReport) _then;

/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? stats = null,Object? coordinatorshipPerformance = null,Object? taskStatusDistribution = null,Object? priorityDistribution = null,Object? tasks = null,Object? meetingStats = null,Object? messageStats = null,Object? dateChangeStats = null,Object? monthlyActivity = null,Object? generatedAt = null,}) {
  return _then(_SeasonReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Stats,coordinatorshipPerformance: null == coordinatorshipPerformance ? _self._coordinatorshipPerformance : coordinatorshipPerformance // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,taskStatusDistribution: null == taskStatusDistribution ? _self._taskStatusDistribution : taskStatusDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,priorityDistribution: null == priorityDistribution ? _self._priorityDistribution : priorityDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ReportTask>,meetingStats: null == meetingStats ? _self.meetingStats : meetingStats // ignore: cast_nullable_to_non_nullable
as MeetingStats,messageStats: null == messageStats ? _self.messageStats : messageStats // ignore: cast_nullable_to_non_nullable
as MessageStats,dateChangeStats: null == dateChangeStats ? _self.dateChangeStats : dateChangeStats // ignore: cast_nullable_to_non_nullable
as DateChangeStats,monthlyActivity: null == monthlyActivity ? _self._monthlyActivity : monthlyActivity // ignore: cast_nullable_to_non_nullable
as List<MonthlyActivity>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsCopyWith<$Res> get stats {
  
  return $StatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingStatsCopyWith<$Res> get meetingStats {
  
  return $MeetingStatsCopyWith<$Res>(_self.meetingStats, (value) {
    return _then(_self.copyWith(meetingStats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageStatsCopyWith<$Res> get messageStats {
  
  return $MessageStatsCopyWith<$Res>(_self.messageStats, (value) {
    return _then(_self.copyWith(messageStats: value));
  });
}/// Create a copy of SeasonReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateChangeStatsCopyWith<$Res> get dateChangeStats {
  
  return $DateChangeStatsCopyWith<$Res>(_self.dateChangeStats, (value) {
    return _then(_self.copyWith(dateChangeStats: value));
  });
}
}

// dart format on
