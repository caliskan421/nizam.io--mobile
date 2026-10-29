// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferHistoryItem {

@JsonKey(name: 'transfer_id') String get transferId;@JsonKey(name: 'source_program_id') String get sourceProgramId;@JsonKey(name: 'target_program_id') String get targetProgramId;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'work_item_ids') List<String>? get workItemIds;@JsonKey(name: 'moved_item_count') int get movedItemCount;@JsonKey(name: 'moved_file_count') int get movedFileCount;@JsonKey(name: 'cut_dependency_count') int get cutDependencyCount;@JsonKey(name: 'restored_dependency_count') int get restoredDependencyCount;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'skipped_work_item_ids') List<String>? get skippedWorkItemIds;@JsonKey(name: 'reverses_transfer_id') String? get reversesTransferId;
/// Create a copy of TransferHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferHistoryItemCopyWith<TransferHistoryItem> get copyWith => _$TransferHistoryItemCopyWithImpl<TransferHistoryItem>(this as TransferHistoryItem, _$identity);

  /// Serializes this TransferHistoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferHistoryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferHistoryItem&&(identical(other.transferId, _this.transferId) || other.transferId == _this.transferId)&&(identical(other.sourceProgramId, _this.sourceProgramId) || other.sourceProgramId == _this.sourceProgramId)&&(identical(other.targetProgramId, _this.targetProgramId) || other.targetProgramId == _this.targetProgramId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _this.workItemIds)&&(identical(other.movedItemCount, _this.movedItemCount) || other.movedItemCount == _this.movedItemCount)&&(identical(other.movedFileCount, _this.movedFileCount) || other.movedFileCount == _this.movedFileCount)&&(identical(other.cutDependencyCount, _this.cutDependencyCount) || other.cutDependencyCount == _this.cutDependencyCount)&&(identical(other.restoredDependencyCount, _this.restoredDependencyCount) || other.restoredDependencyCount == _this.restoredDependencyCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.skippedWorkItemIds, _this.skippedWorkItemIds)&&(identical(other.reversesTransferId, _this.reversesTransferId) || other.reversesTransferId == _this.reversesTransferId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferHistoryItem;
  return Object.hash(runtimeType,_this.transferId,_this.sourceProgramId,_this.targetProgramId,_this.departmentId,const DeepCollectionEquality().hash(_this.workItemIds),_this.movedItemCount,_this.movedFileCount,_this.cutDependencyCount,_this.restoredDependencyCount,_this.createdAt,const DeepCollectionEquality().hash(_this.skippedWorkItemIds),_this.reversesTransferId);
}

@override
String toString() {
  final _this = this as TransferHistoryItem;
  return 'TransferHistoryItem(transferId: ${_this.transferId}, sourceProgramId: ${_this.sourceProgramId}, targetProgramId: ${_this.targetProgramId}, departmentId: ${_this.departmentId}, workItemIds: ${_this.workItemIds}, movedItemCount: ${_this.movedItemCount}, movedFileCount: ${_this.movedFileCount}, cutDependencyCount: ${_this.cutDependencyCount}, restoredDependencyCount: ${_this.restoredDependencyCount}, createdAt: ${_this.createdAt}, skippedWorkItemIds: ${_this.skippedWorkItemIds}, reversesTransferId: ${_this.reversesTransferId})';
}


}

/// @nodoc
abstract mixin class $TransferHistoryItemCopyWith<$Res>  {
  factory $TransferHistoryItemCopyWith(TransferHistoryItem value, $Res Function(TransferHistoryItem) _then) = _$TransferHistoryItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'transfer_id') String transferId,@JsonKey(name: 'source_program_id') String sourceProgramId,@JsonKey(name: 'target_program_id') String targetProgramId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds,@JsonKey(name: 'moved_item_count') int movedItemCount,@JsonKey(name: 'moved_file_count') int movedFileCount,@JsonKey(name: 'cut_dependency_count') int cutDependencyCount,@JsonKey(name: 'restored_dependency_count') int restoredDependencyCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds,@JsonKey(name: 'reverses_transfer_id') String? reversesTransferId
});




}
/// @nodoc
class _$TransferHistoryItemCopyWithImpl<$Res>
    implements $TransferHistoryItemCopyWith<$Res> {
  _$TransferHistoryItemCopyWithImpl(this._self, this._then);

  final TransferHistoryItem _self;
  final $Res Function(TransferHistoryItem) _then;

/// Create a copy of TransferHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? sourceProgramId = null,Object? targetProgramId = null,Object? departmentId = null,Object? workItemIds = freezed,Object? movedItemCount = null,Object? movedFileCount = null,Object? cutDependencyCount = null,Object? restoredDependencyCount = null,Object? createdAt = null,Object? skippedWorkItemIds = freezed,Object? reversesTransferId = freezed,}) {
  return _then(TransferHistoryItem(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,sourceProgramId: null == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String,targetProgramId: null == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,workItemIds: freezed == workItemIds ? _self.workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,movedItemCount: null == movedItemCount ? _self.movedItemCount : movedItemCount // ignore: cast_nullable_to_non_nullable
as int,movedFileCount: null == movedFileCount ? _self.movedFileCount : movedFileCount // ignore: cast_nullable_to_non_nullable
as int,cutDependencyCount: null == cutDependencyCount ? _self.cutDependencyCount : cutDependencyCount // ignore: cast_nullable_to_non_nullable
as int,restoredDependencyCount: null == restoredDependencyCount ? _self.restoredDependencyCount : restoredDependencyCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,skippedWorkItemIds: freezed == skippedWorkItemIds ? _self.skippedWorkItemIds : skippedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,reversesTransferId: freezed == reversesTransferId ? _self.reversesTransferId : reversesTransferId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferHistoryItem].
extension TransferHistoryItemPatterns on TransferHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _TransferHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransferHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'source_program_id')  String sourceProgramId, @JsonKey(name: 'target_program_id')  String targetProgramId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'moved_item_count')  int movedItemCount, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferHistoryItem() when $default != null:
return $default(_that.transferId,_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.movedItemCount,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.createdAt,_that.skippedWorkItemIds,_that.reversesTransferId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'source_program_id')  String sourceProgramId, @JsonKey(name: 'target_program_id')  String targetProgramId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'moved_item_count')  int movedItemCount, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId)  $default,) {final _that = this;
switch (_that) {
case _TransferHistoryItem():
return $default(_that.transferId,_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.movedItemCount,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.createdAt,_that.skippedWorkItemIds,_that.reversesTransferId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'source_program_id')  String sourceProgramId, @JsonKey(name: 'target_program_id')  String targetProgramId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'moved_item_count')  int movedItemCount, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId)?  $default,) {final _that = this;
switch (_that) {
case _TransferHistoryItem() when $default != null:
return $default(_that.transferId,_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.movedItemCount,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.createdAt,_that.skippedWorkItemIds,_that.reversesTransferId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferHistoryItem implements TransferHistoryItem {
  const _TransferHistoryItem({@JsonKey(name: 'transfer_id') required this.transferId, @JsonKey(name: 'source_program_id') required this.sourceProgramId, @JsonKey(name: 'target_program_id') required this.targetProgramId, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'work_item_ids') required  List<String>? workItemIds, @JsonKey(name: 'moved_item_count') required this.movedItemCount, @JsonKey(name: 'moved_file_count') required this.movedFileCount, @JsonKey(name: 'cut_dependency_count') required this.cutDependencyCount, @JsonKey(name: 'restored_dependency_count') required this.restoredDependencyCount, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds, @JsonKey(name: 'reverses_transfer_id') this.reversesTransferId}): _workItemIds = workItemIds,_skippedWorkItemIds = skippedWorkItemIds;
  factory _TransferHistoryItem.fromJson(Map<String, dynamic> json) => _$TransferHistoryItemFromJson(json);

@override@JsonKey(name: 'transfer_id') final  String transferId;
@override@JsonKey(name: 'source_program_id') final  String sourceProgramId;
@override@JsonKey(name: 'target_program_id') final  String targetProgramId;
@override@JsonKey(name: 'department_id') final  String departmentId;
 final  List<String>? _workItemIds;
@override@JsonKey(name: 'work_item_ids') List<String>? get workItemIds {
  final value = _workItemIds;
  if (value == null) return null;
  if (_workItemIds is EqualUnmodifiableListView) return _workItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'moved_item_count') final  int movedItemCount;
@override@JsonKey(name: 'moved_file_count') final  int movedFileCount;
@override@JsonKey(name: 'cut_dependency_count') final  int cutDependencyCount;
@override@JsonKey(name: 'restored_dependency_count') final  int restoredDependencyCount;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
 final  List<String>? _skippedWorkItemIds;
@override@JsonKey(name: 'skipped_work_item_ids') List<String>? get skippedWorkItemIds {
  final value = _skippedWorkItemIds;
  if (value == null) return null;
  if (_skippedWorkItemIds is EqualUnmodifiableListView) return _skippedWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'reverses_transfer_id') final  String? reversesTransferId;

/// Create a copy of TransferHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferHistoryItemCopyWith<_TransferHistoryItem> get copyWith => __$TransferHistoryItemCopyWithImpl<_TransferHistoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferHistoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferHistoryItem&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.sourceProgramId, sourceProgramId) || other.sourceProgramId == sourceProgramId)&&(identical(other.targetProgramId, targetProgramId) || other.targetProgramId == targetProgramId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _workItemIds)&&(identical(other.movedItemCount, movedItemCount) || other.movedItemCount == movedItemCount)&&(identical(other.movedFileCount, movedFileCount) || other.movedFileCount == movedFileCount)&&(identical(other.cutDependencyCount, cutDependencyCount) || other.cutDependencyCount == cutDependencyCount)&&(identical(other.restoredDependencyCount, restoredDependencyCount) || other.restoredDependencyCount == restoredDependencyCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.skippedWorkItemIds, _skippedWorkItemIds)&&(identical(other.reversesTransferId, reversesTransferId) || other.reversesTransferId == reversesTransferId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,transferId,sourceProgramId,targetProgramId,departmentId,const DeepCollectionEquality().hash(_workItemIds),movedItemCount,movedFileCount,cutDependencyCount,restoredDependencyCount,createdAt,const DeepCollectionEquality().hash(_skippedWorkItemIds),reversesTransferId);
}

@override
String toString() {
    return 'TransferHistoryItem(transferId: $transferId, sourceProgramId: $sourceProgramId, targetProgramId: $targetProgramId, departmentId: $departmentId, workItemIds: $workItemIds, movedItemCount: $movedItemCount, movedFileCount: $movedFileCount, cutDependencyCount: $cutDependencyCount, restoredDependencyCount: $restoredDependencyCount, createdAt: $createdAt, skippedWorkItemIds: $skippedWorkItemIds, reversesTransferId: $reversesTransferId)';
}


}

/// @nodoc
abstract mixin class _$TransferHistoryItemCopyWith<$Res> implements $TransferHistoryItemCopyWith<$Res> {
  factory _$TransferHistoryItemCopyWith(_TransferHistoryItem value, $Res Function(_TransferHistoryItem) _then) = __$TransferHistoryItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'transfer_id') String transferId,@JsonKey(name: 'source_program_id') String sourceProgramId,@JsonKey(name: 'target_program_id') String targetProgramId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds,@JsonKey(name: 'moved_item_count') int movedItemCount,@JsonKey(name: 'moved_file_count') int movedFileCount,@JsonKey(name: 'cut_dependency_count') int cutDependencyCount,@JsonKey(name: 'restored_dependency_count') int restoredDependencyCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds,@JsonKey(name: 'reverses_transfer_id') String? reversesTransferId
});




}
/// @nodoc
class __$TransferHistoryItemCopyWithImpl<$Res>
    implements _$TransferHistoryItemCopyWith<$Res> {
  __$TransferHistoryItemCopyWithImpl(this._self, this._then);

  final _TransferHistoryItem _self;
  final $Res Function(_TransferHistoryItem) _then;

/// Create a copy of TransferHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? sourceProgramId = null,Object? targetProgramId = null,Object? departmentId = null,Object? workItemIds = freezed,Object? movedItemCount = null,Object? movedFileCount = null,Object? cutDependencyCount = null,Object? restoredDependencyCount = null,Object? createdAt = null,Object? skippedWorkItemIds = freezed,Object? reversesTransferId = freezed,}) {
  return _then(_TransferHistoryItem(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,sourceProgramId: null == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String,targetProgramId: null == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,workItemIds: freezed == workItemIds ? _self._workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,movedItemCount: null == movedItemCount ? _self.movedItemCount : movedItemCount // ignore: cast_nullable_to_non_nullable
as int,movedFileCount: null == movedFileCount ? _self.movedFileCount : movedFileCount // ignore: cast_nullable_to_non_nullable
as int,cutDependencyCount: null == cutDependencyCount ? _self.cutDependencyCount : cutDependencyCount // ignore: cast_nullable_to_non_nullable
as int,restoredDependencyCount: null == restoredDependencyCount ? _self.restoredDependencyCount : restoredDependencyCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,skippedWorkItemIds: freezed == skippedWorkItemIds ? _self._skippedWorkItemIds : skippedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,reversesTransferId: freezed == reversesTransferId ? _self.reversesTransferId : reversesTransferId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
