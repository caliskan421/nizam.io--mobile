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

@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'department_id') String get departmentId; String get title; WorkItemPriority get priority; WorkItemStatus get status;@JsonKey(name: 'assignee_account_ids') List<String> get assigneeAccountIds;/// Atananlar görünen adlarıyla; sıra `assignee_account_ids` ile aynıdır. `assignee_account_ids` geriye uyum için korunur.
 List<WorkItemAssignee> get assignees;/// Planlanan başlangıç günü (tarih kaydından; liste, oluşturma, güncelleme ve tekil uçta dolu).
@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime get startOn;/// Bitiş günü (tarih kaydından). Geç tamamlamada tamamlanma gününe itilmiş olabilir; özgün plan `planned_end_on`dadır.
@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime get endOn;@JsonKey(name: 'is_overdue') bool get isOverdue;@JsonKey(name: 'days_overdue') int get daysOverdue;@JsonKey(name: 'is_completed_late') bool get isCompletedLate;@JsonKey(name: 'days_late') int get daysLate;@JsonKey(name: 'is_completed_early') bool get isCompletedEarly;@JsonKey(name: 'days_early') int get daysEarly;/// Tamamlanma kanıtı bayrağı (ADR-0024): açıkken onaya sunma, doğrudan tamamlama ve onay en az bir ek dosya ister.
@JsonKey(name: 'completion_evidence_required') bool get completionEvidenceRequired;@JsonKey(name: 'subtask_counts') SubtaskCounts get subtaskCounts;@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? get plannedEndOn;@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? get completedOn;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItem&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _this.assigneeAccountIds)&&const DeepCollectionEquality().equals(other.assignees, _this.assignees)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.isCompletedLate, _this.isCompletedLate) || other.isCompletedLate == _this.isCompletedLate)&&(identical(other.daysLate, _this.daysLate) || other.daysLate == _this.daysLate)&&(identical(other.isCompletedEarly, _this.isCompletedEarly) || other.isCompletedEarly == _this.isCompletedEarly)&&(identical(other.daysEarly, _this.daysEarly) || other.daysEarly == _this.daysEarly)&&(identical(other.completionEvidenceRequired, _this.completionEvidenceRequired) || other.completionEvidenceRequired == _this.completionEvidenceRequired)&&(identical(other.subtaskCounts, _this.subtaskCounts) || other.subtaskCounts == _this.subtaskCounts)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItem;
  return Object.hashAll([runtimeType,_this.workItemId,_this.programId,_this.departmentId,_this.title,_this.priority,_this.status,const DeepCollectionEquality().hash(_this.assigneeAccountIds),const DeepCollectionEquality().hash(_this.assignees),_this.startOn,_this.endOn,_this.isOverdue,_this.daysOverdue,_this.isCompletedLate,_this.daysLate,_this.isCompletedEarly,_this.daysEarly,_this.completionEvidenceRequired,_this.subtaskCounts,_this.plannedEndOn,_this.completedOn]);
}

@override
String toString() {
  final _this = this as WorkItem;
  return 'WorkItem(workItemId: ${_this.workItemId}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, title: ${_this.title}, priority: ${_this.priority}, status: ${_this.status}, assigneeAccountIds: ${_this.assigneeAccountIds}, assignees: ${_this.assignees}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, isOverdue: ${_this.isOverdue}, daysOverdue: ${_this.daysOverdue}, isCompletedLate: ${_this.isCompletedLate}, daysLate: ${_this.daysLate}, isCompletedEarly: ${_this.isCompletedEarly}, daysEarly: ${_this.daysEarly}, completionEvidenceRequired: ${_this.completionEvidenceRequired}, subtaskCounts: ${_this.subtaskCounts}, plannedEndOn: ${_this.plannedEndOn}, completedOn: ${_this.completedOn})';
}


}

/// @nodoc
abstract mixin class $WorkItemCopyWith<$Res>  {
  factory $WorkItemCopyWith(WorkItem value, $Res Function(WorkItem) _then) = _$WorkItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, String title, WorkItemPriority priority, WorkItemStatus status,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds, List<WorkItemAssignee> assignees,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@JsonKey(name: 'completion_evidence_required') bool completionEvidenceRequired,@JsonKey(name: 'subtask_counts') SubtaskCounts subtaskCounts,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn
});


$SubtaskCountsCopyWith<$Res> get subtaskCounts;

}
/// @nodoc
class _$WorkItemCopyWithImpl<$Res>
    implements $WorkItemCopyWith<$Res> {
  _$WorkItemCopyWithImpl(this._self, this._then);

  final WorkItem _self;
  final $Res Function(WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? programId = null,Object? departmentId = null,Object? title = null,Object? priority = null,Object? status = null,Object? assigneeAccountIds = null,Object? assignees = null,Object? startOn = null,Object? endOn = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? completionEvidenceRequired = null,Object? subtaskCounts = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,}) {
  return _then(WorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkItemPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemStatus,assigneeAccountIds: null == assigneeAccountIds ? _self.assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<WorkItemAssignee>,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,completionEvidenceRequired: null == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool,subtaskCounts: null == subtaskCounts ? _self.subtaskCounts : subtaskCounts // ignore: cast_nullable_to_non_nullable
as SubtaskCounts,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubtaskCountsCopyWith<$Res> get subtaskCounts {
  
  return $SubtaskCountsCopyWith<$Res>(_self.subtaskCounts, (value) {
    return _then(_self.copyWith(subtaskCounts: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  List<WorkItemAssignee> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'completion_evidence_required')  bool completionEvidenceRequired, @JsonKey(name: 'subtask_counts')  SubtaskCounts subtaskCounts, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.assignees,_that.startOn,_that.endOn,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.completionEvidenceRequired,_that.subtaskCounts,_that.plannedEndOn,_that.completedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  List<WorkItemAssignee> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'completion_evidence_required')  bool completionEvidenceRequired, @JsonKey(name: 'subtask_counts')  SubtaskCounts subtaskCounts, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)  $default,) {final _that = this;
switch (_that) {
case _WorkItem():
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.assignees,_that.startOn,_that.endOn,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.completionEvidenceRequired,_that.subtaskCounts,_that.plannedEndOn,_that.completedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  String title,  WorkItemPriority priority,  WorkItemStatus status, @JsonKey(name: 'assignee_account_ids')  List<String> assigneeAccountIds,  List<WorkItemAssignee> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly, @JsonKey(name: 'completion_evidence_required')  bool completionEvidenceRequired, @JsonKey(name: 'subtask_counts')  SubtaskCounts subtaskCounts, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on')  DateTime? completedOn)?  $default,) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.workItemId,_that.programId,_that.departmentId,_that.title,_that.priority,_that.status,_that.assigneeAccountIds,_that.assignees,_that.startOn,_that.endOn,_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly,_that.completionEvidenceRequired,_that.subtaskCounts,_that.plannedEndOn,_that.completedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItem implements WorkItem {
  const _WorkItem({@JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.title, required this.priority, required this.status, @JsonKey(name: 'assignee_account_ids') required  List<String> assigneeAccountIds, required  List<WorkItemAssignee> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on') required this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') required this.endOn, @JsonKey(name: 'is_overdue') required this.isOverdue, @JsonKey(name: 'days_overdue') required this.daysOverdue, @JsonKey(name: 'is_completed_late') required this.isCompletedLate, @JsonKey(name: 'days_late') required this.daysLate, @JsonKey(name: 'is_completed_early') required this.isCompletedEarly, @JsonKey(name: 'days_early') required this.daysEarly, @JsonKey(name: 'completion_evidence_required') required this.completionEvidenceRequired, @JsonKey(name: 'subtask_counts') required this.subtaskCounts, @DateOnlyConverter()@JsonKey(name: 'planned_end_on') this.plannedEndOn, @DateOnlyConverter()@JsonKey(name: 'completed_on') this.completedOn}): _assigneeAccountIds = assigneeAccountIds,_assignees = assignees;
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

/// Atananlar görünen adlarıyla; sıra `assignee_account_ids` ile aynıdır. `assignee_account_ids` geriye uyum için korunur.
 final  List<WorkItemAssignee> _assignees;
/// Atananlar görünen adlarıyla; sıra `assignee_account_ids` ile aynıdır. `assignee_account_ids` geriye uyum için korunur.
@override List<WorkItemAssignee> get assignees {
  if (_assignees is EqualUnmodifiableListView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignees);
}

/// Planlanan başlangıç günü (tarih kaydından; liste, oluşturma, güncelleme ve tekil uçta dolu).
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime startOn;
/// Bitiş günü (tarih kaydından). Geç tamamlamada tamamlanma gününe itilmiş olabilir; özgün plan `planned_end_on`dadır.
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime endOn;
@override@JsonKey(name: 'is_overdue') final  bool isOverdue;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;
@override@JsonKey(name: 'is_completed_late') final  bool isCompletedLate;
@override@JsonKey(name: 'days_late') final  int daysLate;
@override@JsonKey(name: 'is_completed_early') final  bool isCompletedEarly;
@override@JsonKey(name: 'days_early') final  int daysEarly;
/// Tamamlanma kanıtı bayrağı (ADR-0024): açıkken onaya sunma, doğrudan tamamlama ve onay en az bir ek dosya ister.
@override@JsonKey(name: 'completion_evidence_required') final  bool completionEvidenceRequired;
@override@JsonKey(name: 'subtask_counts') final  SubtaskCounts subtaskCounts;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItem&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _assigneeAccountIds)&&const DeepCollectionEquality().equals(other.assignees, _assignees)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.isCompletedLate, isCompletedLate) || other.isCompletedLate == isCompletedLate)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.isCompletedEarly, isCompletedEarly) || other.isCompletedEarly == isCompletedEarly)&&(identical(other.daysEarly, daysEarly) || other.daysEarly == daysEarly)&&(identical(other.completionEvidenceRequired, completionEvidenceRequired) || other.completionEvidenceRequired == completionEvidenceRequired)&&(identical(other.subtaskCounts, subtaskCounts) || other.subtaskCounts == subtaskCounts)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,workItemId,programId,departmentId,title,priority,status,const DeepCollectionEquality().hash(_assigneeAccountIds),const DeepCollectionEquality().hash(_assignees),startOn,endOn,isOverdue,daysOverdue,isCompletedLate,daysLate,isCompletedEarly,daysEarly,completionEvidenceRequired,subtaskCounts,plannedEndOn,completedOn]);
}

@override
String toString() {
    return 'WorkItem(workItemId: $workItemId, programId: $programId, departmentId: $departmentId, title: $title, priority: $priority, status: $status, assigneeAccountIds: $assigneeAccountIds, assignees: $assignees, startOn: $startOn, endOn: $endOn, isOverdue: $isOverdue, daysOverdue: $daysOverdue, isCompletedLate: $isCompletedLate, daysLate: $daysLate, isCompletedEarly: $isCompletedEarly, daysEarly: $daysEarly, completionEvidenceRequired: $completionEvidenceRequired, subtaskCounts: $subtaskCounts, plannedEndOn: $plannedEndOn, completedOn: $completedOn)';
}


}

/// @nodoc
abstract mixin class _$WorkItemCopyWith<$Res> implements $WorkItemCopyWith<$Res> {
  factory _$WorkItemCopyWith(_WorkItem value, $Res Function(_WorkItem) _then) = __$WorkItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, String title, WorkItemPriority priority, WorkItemStatus status,@JsonKey(name: 'assignee_account_ids') List<String> assigneeAccountIds, List<WorkItemAssignee> assignees,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly,@JsonKey(name: 'completion_evidence_required') bool completionEvidenceRequired,@JsonKey(name: 'subtask_counts') SubtaskCounts subtaskCounts,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@DateOnlyConverter()@JsonKey(name: 'completed_on') DateTime? completedOn
});


@override $SubtaskCountsCopyWith<$Res> get subtaskCounts;

}
/// @nodoc
class __$WorkItemCopyWithImpl<$Res>
    implements _$WorkItemCopyWith<$Res> {
  __$WorkItemCopyWithImpl(this._self, this._then);

  final _WorkItem _self;
  final $Res Function(_WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? programId = null,Object? departmentId = null,Object? title = null,Object? priority = null,Object? status = null,Object? assigneeAccountIds = null,Object? assignees = null,Object? startOn = null,Object? endOn = null,Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,Object? completionEvidenceRequired = null,Object? subtaskCounts = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,}) {
  return _then(_WorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as WorkItemPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemStatus,assigneeAccountIds: null == assigneeAccountIds ? _self._assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<WorkItemAssignee>,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,completionEvidenceRequired: null == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool,subtaskCounts: null == subtaskCounts ? _self.subtaskCounts : subtaskCounts // ignore: cast_nullable_to_non_nullable
as SubtaskCounts,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubtaskCountsCopyWith<$Res> get subtaskCounts {
  
  return $SubtaskCountsCopyWith<$Res>(_self.subtaskCounts, (value) {
    return _then(_self.copyWith(subtaskCounts: value));
  });
}
}

// dart format on
