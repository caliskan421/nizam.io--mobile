// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coordinatorship_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoordinatorshipStat {

@JsonKey(name: 'department_id') String get departmentId; String get name; String get kind; List<ReportPerson> get coordinators;@JsonKey(name: 'total_tasks') int get totalTasks;@JsonKey(name: 'completed_tasks') int get completedTasks;@JsonKey(name: 'in_progress_tasks') int get inProgressTasks;@JsonKey(name: 'not_started_tasks') int get notStartedTasks;@JsonKey(name: 'overdue_tasks') int get overdueTasks;@JsonKey(name: 'completion_rate') double get completionRate;@JsonKey(name: 'member_count') int get memberCount;@JsonKey(name: 'meeting_count') int get meetingCount;@JsonKey(name: 'last_activity_at') String? get lastActivityAt; String? get description;
/// Create a copy of CoordinatorshipStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatorshipStatCopyWith<CoordinatorshipStat> get copyWith => _$CoordinatorshipStatCopyWithImpl<CoordinatorshipStat>(this as CoordinatorshipStat, _$identity);

  /// Serializes this CoordinatorshipStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CoordinatorshipStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoordinatorshipStat&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.coordinators, _this.coordinators)&&(identical(other.totalTasks, _this.totalTasks) || other.totalTasks == _this.totalTasks)&&(identical(other.completedTasks, _this.completedTasks) || other.completedTasks == _this.completedTasks)&&(identical(other.inProgressTasks, _this.inProgressTasks) || other.inProgressTasks == _this.inProgressTasks)&&(identical(other.notStartedTasks, _this.notStartedTasks) || other.notStartedTasks == _this.notStartedTasks)&&(identical(other.overdueTasks, _this.overdueTasks) || other.overdueTasks == _this.overdueTasks)&&(identical(other.completionRate, _this.completionRate) || other.completionRate == _this.completionRate)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.meetingCount, _this.meetingCount) || other.meetingCount == _this.meetingCount)&&(identical(other.lastActivityAt, _this.lastActivityAt) || other.lastActivityAt == _this.lastActivityAt)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoordinatorshipStat;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.kind,const DeepCollectionEquality().hash(_this.coordinators),_this.totalTasks,_this.completedTasks,_this.inProgressTasks,_this.notStartedTasks,_this.overdueTasks,_this.completionRate,_this.memberCount,_this.meetingCount,_this.lastActivityAt,_this.description);
}

@override
String toString() {
  final _this = this as CoordinatorshipStat;
  return 'CoordinatorshipStat(departmentId: ${_this.departmentId}, name: ${_this.name}, kind: ${_this.kind}, coordinators: ${_this.coordinators}, totalTasks: ${_this.totalTasks}, completedTasks: ${_this.completedTasks}, inProgressTasks: ${_this.inProgressTasks}, notStartedTasks: ${_this.notStartedTasks}, overdueTasks: ${_this.overdueTasks}, completionRate: ${_this.completionRate}, memberCount: ${_this.memberCount}, meetingCount: ${_this.meetingCount}, lastActivityAt: ${_this.lastActivityAt}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CoordinatorshipStatCopyWith<$Res>  {
  factory $CoordinatorshipStatCopyWith(CoordinatorshipStat value, $Res Function(CoordinatorshipStat) _then) = _$CoordinatorshipStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String kind, List<ReportPerson> coordinators,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'in_progress_tasks') int inProgressTasks,@JsonKey(name: 'not_started_tasks') int notStartedTasks,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'completion_rate') double completionRate,@JsonKey(name: 'member_count') int memberCount,@JsonKey(name: 'meeting_count') int meetingCount,@JsonKey(name: 'last_activity_at') String? lastActivityAt, String? description
});




}
/// @nodoc
class _$CoordinatorshipStatCopyWithImpl<$Res>
    implements $CoordinatorshipStatCopyWith<$Res> {
  _$CoordinatorshipStatCopyWithImpl(this._self, this._then);

  final CoordinatorshipStat _self;
  final $Res Function(CoordinatorshipStat) _then;

/// Create a copy of CoordinatorshipStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? kind = null,Object? coordinators = null,Object? totalTasks = null,Object? completedTasks = null,Object? inProgressTasks = null,Object? notStartedTasks = null,Object? overdueTasks = null,Object? completionRate = null,Object? memberCount = null,Object? meetingCount = null,Object? lastActivityAt = freezed,Object? description = freezed,}) {
  return _then(CoordinatorshipStat(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,coordinators: null == coordinators ? _self.coordinators : coordinators // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,inProgressTasks: null == inProgressTasks ? _self.inProgressTasks : inProgressTasks // ignore: cast_nullable_to_non_nullable
as int,notStartedTasks: null == notStartedTasks ? _self.notStartedTasks : notStartedTasks // ignore: cast_nullable_to_non_nullable
as int,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,meetingCount: null == meetingCount ? _self.meetingCount : meetingCount // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoordinatorshipStat].
extension CoordinatorshipStatPatterns on CoordinatorshipStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoordinatorshipStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoordinatorshipStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoordinatorshipStat value)  $default,){
final _that = this;
switch (_that) {
case _CoordinatorshipStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoordinatorshipStat value)?  $default,){
final _that = this;
switch (_that) {
case _CoordinatorshipStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind,  List<ReportPerson> coordinators, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'in_progress_tasks')  int inProgressTasks, @JsonKey(name: 'not_started_tasks')  int notStartedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoordinatorshipStat() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind,_that.coordinators,_that.totalTasks,_that.completedTasks,_that.inProgressTasks,_that.notStartedTasks,_that.overdueTasks,_that.completionRate,_that.memberCount,_that.meetingCount,_that.lastActivityAt,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind,  List<ReportPerson> coordinators, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'in_progress_tasks')  int inProgressTasks, @JsonKey(name: 'not_started_tasks')  int notStartedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CoordinatorshipStat():
return $default(_that.departmentId,_that.name,_that.kind,_that.coordinators,_that.totalTasks,_that.completedTasks,_that.inProgressTasks,_that.notStartedTasks,_that.overdueTasks,_that.completionRate,_that.memberCount,_that.meetingCount,_that.lastActivityAt,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind,  List<ReportPerson> coordinators, @JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'in_progress_tasks')  int inProgressTasks, @JsonKey(name: 'not_started_tasks')  int notStartedTasks, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CoordinatorshipStat() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind,_that.coordinators,_that.totalTasks,_that.completedTasks,_that.inProgressTasks,_that.notStartedTasks,_that.overdueTasks,_that.completionRate,_that.memberCount,_that.meetingCount,_that.lastActivityAt,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoordinatorshipStat implements CoordinatorshipStat {
  const _CoordinatorshipStat({@JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.kind, required  List<ReportPerson> coordinators, @JsonKey(name: 'total_tasks') required this.totalTasks, @JsonKey(name: 'completed_tasks') required this.completedTasks, @JsonKey(name: 'in_progress_tasks') required this.inProgressTasks, @JsonKey(name: 'not_started_tasks') required this.notStartedTasks, @JsonKey(name: 'overdue_tasks') required this.overdueTasks, @JsonKey(name: 'completion_rate') required this.completionRate, @JsonKey(name: 'member_count') required this.memberCount, @JsonKey(name: 'meeting_count') required this.meetingCount, @JsonKey(name: 'last_activity_at') required this.lastActivityAt, this.description}): _coordinators = coordinators;
  factory _CoordinatorshipStat.fromJson(Map<String, dynamic> json) => _$CoordinatorshipStatFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
@override final  String kind;
 final  List<ReportPerson> _coordinators;
@override List<ReportPerson> get coordinators {
  if (_coordinators is EqualUnmodifiableListView) return _coordinators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinators);
}

@override@JsonKey(name: 'total_tasks') final  int totalTasks;
@override@JsonKey(name: 'completed_tasks') final  int completedTasks;
@override@JsonKey(name: 'in_progress_tasks') final  int inProgressTasks;
@override@JsonKey(name: 'not_started_tasks') final  int notStartedTasks;
@override@JsonKey(name: 'overdue_tasks') final  int overdueTasks;
@override@JsonKey(name: 'completion_rate') final  double completionRate;
@override@JsonKey(name: 'member_count') final  int memberCount;
@override@JsonKey(name: 'meeting_count') final  int meetingCount;
@override@JsonKey(name: 'last_activity_at') final  String? lastActivityAt;
@override final  String? description;

/// Create a copy of CoordinatorshipStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatorshipStatCopyWith<_CoordinatorshipStat> get copyWith => __$CoordinatorshipStatCopyWithImpl<_CoordinatorshipStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatorshipStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoordinatorshipStat&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.coordinators, _coordinators)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.inProgressTasks, inProgressTasks) || other.inProgressTasks == inProgressTasks)&&(identical(other.notStartedTasks, notStartedTasks) || other.notStartedTasks == notStartedTasks)&&(identical(other.overdueTasks, overdueTasks) || other.overdueTasks == overdueTasks)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.meetingCount, meetingCount) || other.meetingCount == meetingCount)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,kind,const DeepCollectionEquality().hash(_coordinators),totalTasks,completedTasks,inProgressTasks,notStartedTasks,overdueTasks,completionRate,memberCount,meetingCount,lastActivityAt,description);
}

@override
String toString() {
    return 'CoordinatorshipStat(departmentId: $departmentId, name: $name, kind: $kind, coordinators: $coordinators, totalTasks: $totalTasks, completedTasks: $completedTasks, inProgressTasks: $inProgressTasks, notStartedTasks: $notStartedTasks, overdueTasks: $overdueTasks, completionRate: $completionRate, memberCount: $memberCount, meetingCount: $meetingCount, lastActivityAt: $lastActivityAt, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CoordinatorshipStatCopyWith<$Res> implements $CoordinatorshipStatCopyWith<$Res> {
  factory _$CoordinatorshipStatCopyWith(_CoordinatorshipStat value, $Res Function(_CoordinatorshipStat) _then) = __$CoordinatorshipStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String kind, List<ReportPerson> coordinators,@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'in_progress_tasks') int inProgressTasks,@JsonKey(name: 'not_started_tasks') int notStartedTasks,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'completion_rate') double completionRate,@JsonKey(name: 'member_count') int memberCount,@JsonKey(name: 'meeting_count') int meetingCount,@JsonKey(name: 'last_activity_at') String? lastActivityAt, String? description
});




}
/// @nodoc
class __$CoordinatorshipStatCopyWithImpl<$Res>
    implements _$CoordinatorshipStatCopyWith<$Res> {
  __$CoordinatorshipStatCopyWithImpl(this._self, this._then);

  final _CoordinatorshipStat _self;
  final $Res Function(_CoordinatorshipStat) _then;

/// Create a copy of CoordinatorshipStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? kind = null,Object? coordinators = null,Object? totalTasks = null,Object? completedTasks = null,Object? inProgressTasks = null,Object? notStartedTasks = null,Object? overdueTasks = null,Object? completionRate = null,Object? memberCount = null,Object? meetingCount = null,Object? lastActivityAt = freezed,Object? description = freezed,}) {
  return _then(_CoordinatorshipStat(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,coordinators: null == coordinators ? _self._coordinators : coordinators // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,inProgressTasks: null == inProgressTasks ? _self.inProgressTasks : inProgressTasks // ignore: cast_nullable_to_non_nullable
as int,notStartedTasks: null == notStartedTasks ? _self.notStartedTasks : notStartedTasks // ignore: cast_nullable_to_non_nullable
as int,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,meetingCount: null == meetingCount ? _self.meetingCount : meetingCount // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
