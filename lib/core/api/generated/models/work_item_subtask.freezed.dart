// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_subtask.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemSubtask {

@JsonKey(name: 'subtask_id') String get subtaskId;@JsonKey(name: 'work_item_id') String get workItemId; String get title; bool get done;@JsonKey(name: 'created_by_account_id') String get createdByAccountId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'assignee_account_id') String? get assigneeAccountId;@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? get endOn;@JsonKey(name: 'done_at') DateTime? get doneAt;@JsonKey(name: 'done_by_account_id') String? get doneByAccountId;
/// Create a copy of WorkItemSubtask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemSubtaskCopyWith<WorkItemSubtask> get copyWith => _$WorkItemSubtaskCopyWithImpl<WorkItemSubtask>(this as WorkItemSubtask, _$identity);

  /// Serializes this WorkItemSubtask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemSubtask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemSubtask&&(identical(other.subtaskId, _this.subtaskId) || other.subtaskId == _this.subtaskId)&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.assigneeAccountId, _this.assigneeAccountId) || other.assigneeAccountId == _this.assigneeAccountId)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.doneAt, _this.doneAt) || other.doneAt == _this.doneAt)&&(identical(other.doneByAccountId, _this.doneByAccountId) || other.doneByAccountId == _this.doneByAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemSubtask;
  return Object.hash(runtimeType,_this.subtaskId,_this.workItemId,_this.title,_this.done,_this.createdByAccountId,_this.createdAt,_this.updatedAt,_this.assigneeAccountId,_this.startOn,_this.endOn,_this.doneAt,_this.doneByAccountId);
}

@override
String toString() {
  final _this = this as WorkItemSubtask;
  return 'WorkItemSubtask(subtaskId: ${_this.subtaskId}, workItemId: ${_this.workItemId}, title: ${_this.title}, done: ${_this.done}, createdByAccountId: ${_this.createdByAccountId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, assigneeAccountId: ${_this.assigneeAccountId}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, doneAt: ${_this.doneAt}, doneByAccountId: ${_this.doneByAccountId})';
}


}

/// @nodoc
abstract mixin class $WorkItemSubtaskCopyWith<$Res>  {
  factory $WorkItemSubtaskCopyWith(WorkItemSubtask value, $Res Function(WorkItemSubtask) _then) = _$WorkItemSubtaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subtask_id') String subtaskId,@JsonKey(name: 'work_item_id') String workItemId, String title, bool done,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn,@JsonKey(name: 'done_at') DateTime? doneAt,@JsonKey(name: 'done_by_account_id') String? doneByAccountId
});




}
/// @nodoc
class _$WorkItemSubtaskCopyWithImpl<$Res>
    implements $WorkItemSubtaskCopyWith<$Res> {
  _$WorkItemSubtaskCopyWithImpl(this._self, this._then);

  final WorkItemSubtask _self;
  final $Res Function(WorkItemSubtask) _then;

/// Create a copy of WorkItemSubtask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtaskId = null,Object? workItemId = null,Object? title = null,Object? done = null,Object? createdByAccountId = null,Object? createdAt = null,Object? updatedAt = null,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? doneAt = freezed,Object? doneByAccountId = freezed,}) {
  return _then(WorkItemSubtask(
subtaskId: null == subtaskId ? _self.subtaskId : subtaskId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneByAccountId: freezed == doneByAccountId ? _self.doneByAccountId : doneByAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemSubtask].
extension WorkItemSubtaskPatterns on WorkItemSubtask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemSubtask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemSubtask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemSubtask value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemSubtask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemSubtask value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemSubtask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subtask_id')  String subtaskId, @JsonKey(name: 'work_item_id')  String workItemId,  String title,  bool done, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @JsonKey(name: 'done_at')  DateTime? doneAt, @JsonKey(name: 'done_by_account_id')  String? doneByAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemSubtask() when $default != null:
return $default(_that.subtaskId,_that.workItemId,_that.title,_that.done,_that.createdByAccountId,_that.createdAt,_that.updatedAt,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.doneAt,_that.doneByAccountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subtask_id')  String subtaskId, @JsonKey(name: 'work_item_id')  String workItemId,  String title,  bool done, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @JsonKey(name: 'done_at')  DateTime? doneAt, @JsonKey(name: 'done_by_account_id')  String? doneByAccountId)  $default,) {final _that = this;
switch (_that) {
case _WorkItemSubtask():
return $default(_that.subtaskId,_that.workItemId,_that.title,_that.done,_that.createdByAccountId,_that.createdAt,_that.updatedAt,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.doneAt,_that.doneByAccountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subtask_id')  String subtaskId, @JsonKey(name: 'work_item_id')  String workItemId,  String title,  bool done, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @JsonKey(name: 'done_at')  DateTime? doneAt, @JsonKey(name: 'done_by_account_id')  String? doneByAccountId)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemSubtask() when $default != null:
return $default(_that.subtaskId,_that.workItemId,_that.title,_that.done,_that.createdByAccountId,_that.createdAt,_that.updatedAt,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.doneAt,_that.doneByAccountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemSubtask implements WorkItemSubtask {
  const _WorkItemSubtask({@JsonKey(name: 'subtask_id') required this.subtaskId, @JsonKey(name: 'work_item_id') required this.workItemId, required this.title, required this.done, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'assignee_account_id') this.assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on') this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') this.endOn, @JsonKey(name: 'done_at') this.doneAt, @JsonKey(name: 'done_by_account_id') this.doneByAccountId});
  factory _WorkItemSubtask.fromJson(Map<String, dynamic> json) => _$WorkItemSubtaskFromJson(json);

@override@JsonKey(name: 'subtask_id') final  String subtaskId;
@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override final  bool done;
@override@JsonKey(name: 'created_by_account_id') final  String createdByAccountId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'assignee_account_id') final  String? assigneeAccountId;
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime? startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime? endOn;
@override@JsonKey(name: 'done_at') final  DateTime? doneAt;
@override@JsonKey(name: 'done_by_account_id') final  String? doneByAccountId;

/// Create a copy of WorkItemSubtask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemSubtaskCopyWith<_WorkItemSubtask> get copyWith => __$WorkItemSubtaskCopyWithImpl<_WorkItemSubtask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemSubtaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemSubtask&&(identical(other.subtaskId, subtaskId) || other.subtaskId == subtaskId)&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.assigneeAccountId, assigneeAccountId) || other.assigneeAccountId == assigneeAccountId)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.doneByAccountId, doneByAccountId) || other.doneByAccountId == doneByAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,subtaskId,workItemId,title,done,createdByAccountId,createdAt,updatedAt,assigneeAccountId,startOn,endOn,doneAt,doneByAccountId);
}

@override
String toString() {
    return 'WorkItemSubtask(subtaskId: $subtaskId, workItemId: $workItemId, title: $title, done: $done, createdByAccountId: $createdByAccountId, createdAt: $createdAt, updatedAt: $updatedAt, assigneeAccountId: $assigneeAccountId, startOn: $startOn, endOn: $endOn, doneAt: $doneAt, doneByAccountId: $doneByAccountId)';
}


}

/// @nodoc
abstract mixin class _$WorkItemSubtaskCopyWith<$Res> implements $WorkItemSubtaskCopyWith<$Res> {
  factory _$WorkItemSubtaskCopyWith(_WorkItemSubtask value, $Res Function(_WorkItemSubtask) _then) = __$WorkItemSubtaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subtask_id') String subtaskId,@JsonKey(name: 'work_item_id') String workItemId, String title, bool done,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn,@JsonKey(name: 'done_at') DateTime? doneAt,@JsonKey(name: 'done_by_account_id') String? doneByAccountId
});




}
/// @nodoc
class __$WorkItemSubtaskCopyWithImpl<$Res>
    implements _$WorkItemSubtaskCopyWith<$Res> {
  __$WorkItemSubtaskCopyWithImpl(this._self, this._then);

  final _WorkItemSubtask _self;
  final $Res Function(_WorkItemSubtask) _then;

/// Create a copy of WorkItemSubtask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtaskId = null,Object? workItemId = null,Object? title = null,Object? done = null,Object? createdByAccountId = null,Object? createdAt = null,Object? updatedAt = null,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? doneAt = freezed,Object? doneByAccountId = freezed,}) {
  return _then(_WorkItemSubtask(
subtaskId: null == subtaskId ? _self.subtaskId : subtaskId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneByAccountId: freezed == doneByAccountId ? _self.doneByAccountId : doneByAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
