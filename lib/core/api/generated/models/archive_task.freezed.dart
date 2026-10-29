// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title;@JsonKey(name: 'file_count') int get fileCount;
/// Create a copy of ArchiveTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveTaskCopyWith<ArchiveTask> get copyWith => _$ArchiveTaskCopyWithImpl<ArchiveTask>(this as ArchiveTask, _$identity);

  /// Serializes this ArchiveTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.fileCount, _this.fileCount) || other.fileCount == _this.fileCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveTask;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.fileCount);
}

@override
String toString() {
  final _this = this as ArchiveTask;
  return 'ArchiveTask(workItemId: ${_this.workItemId}, title: ${_this.title}, fileCount: ${_this.fileCount})';
}


}

/// @nodoc
abstract mixin class $ArchiveTaskCopyWith<$Res>  {
  factory $ArchiveTaskCopyWith(ArchiveTask value, $Res Function(ArchiveTask) _then) = _$ArchiveTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'file_count') int fileCount
});




}
/// @nodoc
class _$ArchiveTaskCopyWithImpl<$Res>
    implements $ArchiveTaskCopyWith<$Res> {
  _$ArchiveTaskCopyWithImpl(this._self, this._then);

  final ArchiveTask _self;
  final $Res Function(ArchiveTask) _then;

/// Create a copy of ArchiveTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? fileCount = null,}) {
  return _then(ArchiveTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveTask].
extension ArchiveTaskPatterns on ArchiveTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveTask value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveTask value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'file_count')  int fileCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.fileCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'file_count')  int fileCount)  $default,) {final _that = this;
switch (_that) {
case _ArchiveTask():
return $default(_that.workItemId,_that.title,_that.fileCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title, @JsonKey(name: 'file_count')  int fileCount)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.fileCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveTask implements ArchiveTask {
  const _ArchiveTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, @JsonKey(name: 'file_count') required this.fileCount});
  factory _ArchiveTask.fromJson(Map<String, dynamic> json) => _$ArchiveTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override@JsonKey(name: 'file_count') final  int fileCount;

/// Create a copy of ArchiveTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveTaskCopyWith<_ArchiveTask> get copyWith => __$ArchiveTaskCopyWithImpl<_ArchiveTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileCount, fileCount) || other.fileCount == fileCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,fileCount);
}

@override
String toString() {
    return 'ArchiveTask(workItemId: $workItemId, title: $title, fileCount: $fileCount)';
}


}

/// @nodoc
abstract mixin class _$ArchiveTaskCopyWith<$Res> implements $ArchiveTaskCopyWith<$Res> {
  factory _$ArchiveTaskCopyWith(_ArchiveTask value, $Res Function(_ArchiveTask) _then) = __$ArchiveTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title,@JsonKey(name: 'file_count') int fileCount
});




}
/// @nodoc
class __$ArchiveTaskCopyWithImpl<$Res>
    implements _$ArchiveTaskCopyWith<$Res> {
  __$ArchiveTaskCopyWithImpl(this._self, this._then);

  final _ArchiveTask _self;
  final $Res Function(_ArchiveTask) _then;

/// Create a copy of ArchiveTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? fileCount = null,}) {
  return _then(_ArchiveTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
