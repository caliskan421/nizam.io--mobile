// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workload_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkloadTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title; String get status; WorkloadTaskPriority get priority;@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime get endOn;@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? get completedOn;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'department_name') String get departmentName;@JsonKey(name: 'is_overdue') bool get isOverdue;@JsonKey(name: 'days_overdue') int get daysOverdue;@JsonKey(name: 'attachment_count') int get attachmentCount;@JsonKey(name: 'has_attachment') bool get hasAttachment;/// Görevin son notu; not yoksa alan gönderilmez.
@JsonKey(name: 'latest_note') String? get latestNote;
/// Create a copy of WorkloadTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkloadTaskCopyWith<WorkloadTask> get copyWith => _$WorkloadTaskCopyWithImpl<WorkloadTask>(this as WorkloadTask, _$identity);

  /// Serializes this WorkloadTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkloadTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkloadTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.attachmentCount, _this.attachmentCount) || other.attachmentCount == _this.attachmentCount)&&(identical(other.hasAttachment, _this.hasAttachment) || other.hasAttachment == _this.hasAttachment)&&(identical(other.latestNote, _this.latestNote) || other.latestNote == _this.latestNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkloadTask;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.status,_this.priority,_this.startOn,_this.endOn,_this.completedOn,_this.departmentId,_this.departmentName,_this.isOverdue,_this.daysOverdue,_this.attachmentCount,_this.hasAttachment,_this.latestNote);
}

@override
String toString() {
  final _this = this as WorkloadTask;
  return 'WorkloadTask(workItemId: ${_this.workItemId}, title: ${_this.title}, status: ${_this.status}, priority: ${_this.priority}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, completedOn: ${_this.completedOn}, departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, isOverdue: ${_this.isOverdue}, daysOverdue: ${_this.daysOverdue}, attachmentCount: ${_this.attachmentCount}, hasAttachment: ${_this.hasAttachment}, latestNote: ${_this.latestNote})';
}


}

/// @nodoc
abstract mixin class $WorkloadTaskCopyWith<$Res>  {
  factory $WorkloadTaskCopyWith(WorkloadTask value, $Res Function(WorkloadTask) _then) = _$WorkloadTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status, WorkloadTaskPriority priority,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'attachment_count') int attachmentCount,@JsonKey(name: 'has_attachment') bool hasAttachment,@JsonKey(name: 'latest_note') String? latestNote
});




}
/// @nodoc
class _$WorkloadTaskCopyWithImpl<$Res>
    implements $WorkloadTaskCopyWith<$Res> {
  _$WorkloadTaskCopyWithImpl(this._self, this._then);

  final WorkloadTask _self;
  final $Res Function(WorkloadTask) _then;

/// Create a copy of WorkloadTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? status = null,Object? priority = null,Object? startOn = null,Object? endOn = null,Object? completedOn = freezed,Object? departmentId = null,Object? departmentName = null,Object? isOverdue = null,Object? daysOverdue = null,Object? attachmentCount = null,Object? hasAttachment = null,Object? latestNote = freezed,}) {
  return _then(WorkloadTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkloadTaskPriority,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,hasAttachment: null == hasAttachment ? _self.hasAttachment : hasAttachment // ignore: cast_nullable_to_non_nullable
as bool,latestNote: freezed == latestNote ? _self.latestNote : latestNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkloadTask].
extension WorkloadTaskPatterns on WorkloadTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkloadTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkloadTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkloadTask value)  $default,){
final _that = this;
switch (_that) {
case _WorkloadTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkloadTask value)?  $default,){
final _that = this;
switch (_that) {
case _WorkloadTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status,  WorkloadTaskPriority priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'attachment_count')  int attachmentCount, @JsonKey(name: 'has_attachment')  bool hasAttachment, @JsonKey(name: 'latest_note')  String? latestNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkloadTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.status,_that.priority,_that.startOn,_that.endOn,_that.completedOn,_that.departmentId,_that.departmentName,_that.isOverdue,_that.daysOverdue,_that.attachmentCount,_that.hasAttachment,_that.latestNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status,  WorkloadTaskPriority priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'attachment_count')  int attachmentCount, @JsonKey(name: 'has_attachment')  bool hasAttachment, @JsonKey(name: 'latest_note')  String? latestNote)  $default,) {final _that = this;
switch (_that) {
case _WorkloadTask():
return $default(_that.workItemId,_that.title,_that.status,_that.priority,_that.startOn,_that.endOn,_that.completedOn,_that.departmentId,_that.departmentName,_that.isOverdue,_that.daysOverdue,_that.attachmentCount,_that.hasAttachment,_that.latestNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status,  WorkloadTaskPriority priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'attachment_count')  int attachmentCount, @JsonKey(name: 'has_attachment')  bool hasAttachment, @JsonKey(name: 'latest_note')  String? latestNote)?  $default,) {final _that = this;
switch (_that) {
case _WorkloadTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.status,_that.priority,_that.startOn,_that.endOn,_that.completedOn,_that.departmentId,_that.departmentName,_that.isOverdue,_that.daysOverdue,_that.attachmentCount,_that.hasAttachment,_that.latestNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkloadTask implements WorkloadTask {
  const _WorkloadTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, required this.status, required this.priority, @DateOnlyConverter()@JsonKey(name: 'start_on') required this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') required this.endOn, @DateOnlyConverter()@JsonKey(name: 'completed_on') required this.completedOn, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, @JsonKey(name: 'is_overdue') required this.isOverdue, @JsonKey(name: 'days_overdue') required this.daysOverdue, @JsonKey(name: 'attachment_count') required this.attachmentCount, @JsonKey(name: 'has_attachment') required this.hasAttachment, @JsonKey(name: 'latest_note') this.latestNote});
  factory _WorkloadTask.fromJson(Map<String, dynamic> json) => _$WorkloadTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override final  String status;
@override final  WorkloadTaskPriority priority;
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime endOn;
@override@DateOnlyConverter()@JsonKey(name: 'completed_on') final  DateTime? completedOn;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'department_name') final  String departmentName;
@override@JsonKey(name: 'is_overdue') final  bool isOverdue;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;
@override@JsonKey(name: 'attachment_count') final  int attachmentCount;
@override@JsonKey(name: 'has_attachment') final  bool hasAttachment;
/// Görevin son notu; not yoksa alan gönderilmez.
@override@JsonKey(name: 'latest_note') final  String? latestNote;

/// Create a copy of WorkloadTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkloadTaskCopyWith<_WorkloadTask> get copyWith => __$WorkloadTaskCopyWithImpl<_WorkloadTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkloadTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkloadTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.attachmentCount, attachmentCount) || other.attachmentCount == attachmentCount)&&(identical(other.hasAttachment, hasAttachment) || other.hasAttachment == hasAttachment)&&(identical(other.latestNote, latestNote) || other.latestNote == latestNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,status,priority,startOn,endOn,completedOn,departmentId,departmentName,isOverdue,daysOverdue,attachmentCount,hasAttachment,latestNote);
}

@override
String toString() {
    return 'WorkloadTask(workItemId: $workItemId, title: $title, status: $status, priority: $priority, startOn: $startOn, endOn: $endOn, completedOn: $completedOn, departmentId: $departmentId, departmentName: $departmentName, isOverdue: $isOverdue, daysOverdue: $daysOverdue, attachmentCount: $attachmentCount, hasAttachment: $hasAttachment, latestNote: $latestNote)';
}


}

/// @nodoc
abstract mixin class _$WorkloadTaskCopyWith<$Res> implements $WorkloadTaskCopyWith<$Res> {
  factory _$WorkloadTaskCopyWith(_WorkloadTask value, $Res Function(_WorkloadTask) _then) = __$WorkloadTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status, WorkloadTaskPriority priority,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'attachment_count') int attachmentCount,@JsonKey(name: 'has_attachment') bool hasAttachment,@JsonKey(name: 'latest_note') String? latestNote
});




}
/// @nodoc
class __$WorkloadTaskCopyWithImpl<$Res>
    implements _$WorkloadTaskCopyWith<$Res> {
  __$WorkloadTaskCopyWithImpl(this._self, this._then);

  final _WorkloadTask _self;
  final $Res Function(_WorkloadTask) _then;

/// Create a copy of WorkloadTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? status = null,Object? priority = null,Object? startOn = null,Object? endOn = null,Object? completedOn = freezed,Object? departmentId = null,Object? departmentName = null,Object? isOverdue = null,Object? daysOverdue = null,Object? attachmentCount = null,Object? hasAttachment = null,Object? latestNote = freezed,}) {
  return _then(_WorkloadTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkloadTaskPriority,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,hasAttachment: null == hasAttachment ? _self.hasAttachment : hasAttachment // ignore: cast_nullable_to_non_nullable
as bool,latestNote: freezed == latestNote ? _self.latestNote : latestNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
