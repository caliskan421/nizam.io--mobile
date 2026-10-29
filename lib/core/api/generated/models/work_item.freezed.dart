// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItem {

@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'department_id') String get departmentId; String get title; WorkItemPriority get priority; WorkItemStatus get status;@JsonKey(name: 'assignee_account_ids') List<String> get assigneeAccountIds;@JsonKey(name: 'is_overdue') bool get isOverdue;@JsonKey(name: 'days_overdue') int get daysOverdue;@JsonKey(name: 'is_completed_late') bool get isCompletedLate;@JsonKey(name: 'days_late') int get daysLate;@JsonKey(name: 'is_completed_early') bool get isCompletedEarly;@JsonKey(name: 'days_early') int get daysEarly;@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? get plannedEndOn;@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? get completedOn;
/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemCopyWith<WorkItem> get copyWith => _$WorkItemCopyWithImpl<WorkItem>(this as WorkItem, _$identity);

  /// Serializes this WorkItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItem&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _this.assigneeAccountIds)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.isCompletedLate, _this.isCompletedLate) || other.isCompletedLate == _this.isCompletedLate)&&(identical(other.daysLate, _this.daysLate) || other.daysLate == _this.daysLate)&&(identical(other.isCompletedEarly, _this.isCompletedEarly) || other.isCompletedEarly == _this.isCompletedEarly)&&(identical(other.daysEarly, _this.daysEarly) || other.daysEarly == _this.daysEarly)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItem;
  return Object.hash(runtimeType,_this.workItemId,_this.programId,_this.departmentId,_this.title,_this.priority,_this.status,const DeepCollectionEquality().hash(_this.assigneeAccountIds),_this.isOverdue,_this.daysOverdue,_this.isCompletedLate,_this.daysLate,_this.isCompletedEarly,_this.daysEarly,_this.plannedEndOn,_this.completedOn);
}

@override
String toString() {
  final _this = this as WorkItem;
  return 'WorkItem(workItemId: ${_this.workItemId}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, title: ${_this.title}, priority: ${_this.priority}, status: ${_this.status}, assigneeAccountIds: ${_this.assigneeAccountIds}, isOverdue: ${_this.isOverdue}, daysOverdue: ${_this.daysOverdue}, isCompletedLate: ${_this.isCompletedLate}, daysLate: ${_this.daysLate}, isCompletedEarly: ${_this.isCompletedEarly}, daysEarly: ${_this.daysEarly}, plannedEndOn: ${_this.plannedEndOn}, completedOn: ${_this.completedOn})';
}


}

/// @nodoc
abstract mixin class $WorkItemCopyWith<$Res>  {
  factory $WorkItemCopyWith(WorkItem value, $Res Function(WorkItem) _then) = _$WorkItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, String title, WorkItemPriority priority, WorkItemStatus status,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn
});




}
/// @nodoc
class _$WorkItemCopyWithImpl<$Res>
    implements $WorkItemCopyWith<$Res> {
  _$WorkItemCopyWithImpl(this._self, this._then);

  final WorkItem _self;
  final $Res Function(WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? programId = null,Object? departmentId = null,Object? title = null,Object? priority = null,Object? status = null,Object? assigneeAccountIds = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,}) {
  return _then(WorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkItemPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemStatus,assigneeAccountIds: null == assigneeAccountIds ? _self.assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItem].
extension WorkItemPatterns on WorkItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.plannedEndOn,_that.completedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)  $default,) {final _that = this;
switch (_that) {
case _WorkItem():
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.plannedEndOn,_that.completedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)?  $default,) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.plannedEndOn,_that.completedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItem implements WorkItem {
  const _WorkItem({@JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.title, required this.priority, required this.status, @JsonKey(name: 'assignee_account_ids') required  List<String> assigneeAccountIds, @JsonKey(name: 'is_overdue') required this.isOverdue, @JsonKey(name: 'days_overdue') required this.daysOverdue, @JsonKey(name: 'is_completed_late') required this.isCompletedLate, @JsonKey(name: 'days_late') required this.daysLate, @JsonKey(name: 'is_completed_early') required this.isCompletedEarly, @JsonKey(name: 'days_early') required this.daysEarly, @DateOnlyConverter()@JsonKey(name: 'planned_end_on') this.plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on') this.completedOn}): _assigneeAccountIds = assigneeAccountIds;
  factory _WorkItem.fromJson(Map<String, dynamic> json) => _$WorkItemFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String title;
@override final  WorkItemPriority priority;
@override final  WorkItemStatus status;
 final  List<String> _assigneeAccountIds;
@override@JsonKey(name: 'assignee_account_ids') List<String> get assigneeAccountIds {
  if (_assigneeAccountIds is EqualUnmodifiableListView) return _assigneeAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assigneeAccountIds);
}

@override@JsonKey(name: 'is_overdue') final  bool isOverdue;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;
@override@JsonKey(name: 'is_completed_late') final  bool isCompletedLate;
@override@JsonKey(name: 'days_late') final  int daysLate;
@override@JsonKey(name: 'is_completed_early') final  bool isCompletedEarly;
@override@JsonKey(name: 'days_early') final  int daysEarly;
@override@DateOnlyConverter()@JsonKey(name: 'planned_end_on') final  DateTime? plannedEndOn;
@override@DateOnlyConverter()@JsonKey(name: 'completed_on') final  DateTime? completedOn;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemCopyWith<_WorkItem> get copyWith => __$WorkItemCopyWithImpl<_WorkItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItem&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _assigneeAccountIds)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.isCompletedLate, isCompletedLate) || other.isCompletedLate == isCompletedLate)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.isCompletedEarly, isCompletedEarly) || other.isCompletedEarly == isCompletedEarly)&&(identical(other.daysEarly, daysEarly) || other.daysEarly == daysEarly)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,programId,departmentId,title,priority,status,const DeepCollectionEquality().hash(_assigneeAccountIds),isOverdue,daysOverdue,isCompletedLate,daysLate,isCompletedEarly,daysEarly,plannedEndOn,completedOn);
}

@override
String toString() {
    return 'WorkItem(workItemId: $workItemId, programId: $programId, departmentId: $departmentId, title: $title, priority: $priority, status: $status, assigneeAccountIds: $assigneeAccountIds, isOverdue: $isOverdue, daysOverdue: $daysOverdue, isCompletedLate: $isCompletedLate, daysLate: $daysLate, isCompletedEarly: $isCompletedEarly, daysEarly: $daysEarly, plannedEndOn: $plannedEndOn, completedOn: $completedOn)';
}


}

/// @nodoc
abstract mixin class _$WorkItemCopyWith<$Res> implements $WorkItemCopyWith<$Res> {
  factory _$WorkItemCopyWith(_WorkItem value, $Res Function(_WorkItem) _then) = __$WorkItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, String title, WorkItemPriority priority, WorkItemStatus status,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn
});




}
/// @nodoc
class __$WorkItemCopyWithImpl<$Res>
    implements _$WorkItemCopyWith<$Res> {
  __$WorkItemCopyWithImpl(this._self, this._then);

  final _WorkItem _self;
  final $Res Function(_WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? programId = null,Object? departmentId = null,Object? title = null,Object? priority = null,Object? status = null,Object? assigneeAccountIds = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,}) {
  return _then(_WorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkItemPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemStatus,assigneeAccountIds: null == assigneeAccountIds ? _self._assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
