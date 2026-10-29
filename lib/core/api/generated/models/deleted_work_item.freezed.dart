// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deleted_work_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletedWorkItem {

@JsonKey(name: 'work_item_id') String get workItemId; String get title;@JsonKey(name: 'department_id') String get departmentId; String get status;@JsonKey(name: 'deleted_at') DateTime get deletedAt;@JsonKey(name: 'file_count') int get fileCount;
/// Create a copy of DeletedWorkItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedWorkItemCopyWith<DeletedWorkItem> get copyWith => _$DeletedWorkItemCopyWithImpl<DeletedWorkItem>(this as DeletedWorkItem, _$identity);

  /// Serializes this DeletedWorkItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeletedWorkItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedWorkItem&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.fileCount, _this.fileCount) || other.fileCount == _this.fileCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeletedWorkItem;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.departmentId,_this.status,_this.deletedAt,_this.fileCount);
}

@override
String toString() {
  final _this = this as DeletedWorkItem;
  return 'DeletedWorkItem(workItemId: ${_this.workItemId}, title: ${_this.title}, departmentId: ${_this.departmentId}, status: ${_this.status}, deletedAt: ${_this.deletedAt}, fileCount: ${_this.fileCount})';
}


}

/// @nodoc
abstract mixin class $DeletedWorkItemCopyWith<$Res>  {
  factory $DeletedWorkItemCopyWith(DeletedWorkItem value, $Res Function(DeletedWorkItem) _then) = _$DeletedWorkItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId, String status,@JsonKey(name: 'deleted_at') DateTime deletedAt,@JsonKey(name: 'file_count') int fileCount
});




}
/// @nodoc
class _$DeletedWorkItemCopyWithImpl<$Res>
    implements $DeletedWorkItemCopyWith<$Res> {
  _$DeletedWorkItemCopyWithImpl(this._self, this._then);

  final DeletedWorkItem _self;
  final $Res Function(DeletedWorkItem) _then;

/// Create a copy of DeletedWorkItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? status = null,Object? deletedAt = null,Object? fileCount = null,}) {
  return _then(DeletedWorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedWorkItem].
extension DeletedWorkItemPatterns on DeletedWorkItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedWorkItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedWorkItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedWorkItem value)  $default,){
final _that = this;
switch (_that) {
case _DeletedWorkItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedWorkItem value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedWorkItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId,  String status, @JsonKey(name: 'deleted_at')  DateTime deletedAt, @JsonKey(name: 'file_count')  int fileCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedWorkItem() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.status,_that.deletedAt,_that.fileCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId,  String status, @JsonKey(name: 'deleted_at')  DateTime deletedAt, @JsonKey(name: 'file_count')  int fileCount)  $default,) {final _that = this;
switch (_that) {
case _DeletedWorkItem():
return $default(_that.workItemId,_that.title,_that.departmentId,_that.status,_that.deletedAt,_that.fileCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'department_id')  String departmentId,  String status, @JsonKey(name: 'deleted_at')  DateTime deletedAt, @JsonKey(name: 'file_count')  int fileCount)?  $default,) {final _that = this;
switch (_that) {
case _DeletedWorkItem() when $default != null:
return $default(_that.workItemId,_that.title,_that.departmentId,_that.status,_that.deletedAt,_that.fileCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedWorkItem implements DeletedWorkItem {
  const _DeletedWorkItem({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, @JsonKey(name: 'department_id') required this.departmentId, required this.status, @JsonKey(name: 'deleted_at') required this.deletedAt, @JsonKey(name: 'file_count') required this.fileCount});
  factory _DeletedWorkItem.fromJson(Map<String, dynamic> json) => _$DeletedWorkItemFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String status;
@override@JsonKey(name: 'deleted_at') final  DateTime deletedAt;
@override@JsonKey(name: 'file_count') final  int fileCount;

/// Create a copy of DeletedWorkItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedWorkItemCopyWith<_DeletedWorkItem> get copyWith => __$DeletedWorkItemCopyWithImpl<_DeletedWorkItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedWorkItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedWorkItem&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.fileCount, fileCount) || other.fileCount == fileCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,departmentId,status,deletedAt,fileCount);
}

@override
String toString() {
    return 'DeletedWorkItem(workItemId: $workItemId, title: $title, departmentId: $departmentId, status: $status, deletedAt: $deletedAt, fileCount: $fileCount)';
}


}

/// @nodoc
abstract mixin class _$DeletedWorkItemCopyWith<$Res> implements $DeletedWorkItemCopyWith<$Res> {
  factory _$DeletedWorkItemCopyWith(_DeletedWorkItem value, $Res Function(_DeletedWorkItem) _then) = __$DeletedWorkItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'department_id') String departmentId, String status,@JsonKey(name: 'deleted_at') DateTime deletedAt,@JsonKey(name: 'file_count') int fileCount
});




}
/// @nodoc
class __$DeletedWorkItemCopyWithImpl<$Res>
    implements _$DeletedWorkItemCopyWith<$Res> {
  __$DeletedWorkItemCopyWithImpl(this._self, this._then);

  final _DeletedWorkItem _self;
  final $Res Function(_DeletedWorkItem) _then;

/// Create a copy of DeletedWorkItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? departmentId = null,Object? status = null,Object? deletedAt = null,Object? fileCount = null,}) {
  return _then(_DeletedWorkItem(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
