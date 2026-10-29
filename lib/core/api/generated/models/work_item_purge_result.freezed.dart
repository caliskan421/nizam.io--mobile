// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_purge_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemPurgeResult {

@JsonKey(name: 'work_item_id') String get workItemId; WorkItemPurgeResultStatus get status;@JsonKey(name: 'files_deleted') int get filesDeleted;
/// Create a copy of WorkItemPurgeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemPurgeResultCopyWith<WorkItemPurgeResult> get copyWith => _$WorkItemPurgeResultCopyWithImpl<WorkItemPurgeResult>(this as WorkItemPurgeResult, _$identity);

  /// Serializes this WorkItemPurgeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemPurgeResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemPurgeResult&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.filesDeleted, _this.filesDeleted) || other.filesDeleted == _this.filesDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemPurgeResult;
  return Object.hash(runtimeType,_this.workItemId,_this.status,_this.filesDeleted);
}

@override
String toString() {
  final _this = this as WorkItemPurgeResult;
  return 'WorkItemPurgeResult(workItemId: ${_this.workItemId}, status: ${_this.status}, filesDeleted: ${_this.filesDeleted})';
}


}

/// @nodoc
abstract mixin class $WorkItemPurgeResultCopyWith<$Res>  {
  factory $WorkItemPurgeResultCopyWith(WorkItemPurgeResult value, $Res Function(WorkItemPurgeResult) _then) = _$WorkItemPurgeResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, WorkItemPurgeResultStatus status,@JsonKey(name: 'files_deleted') int filesDeleted
});




}
/// @nodoc
class _$WorkItemPurgeResultCopyWithImpl<$Res>
    implements $WorkItemPurgeResultCopyWith<$Res> {
  _$WorkItemPurgeResultCopyWithImpl(this._self, this._then);

  final WorkItemPurgeResult _self;
  final $Res Function(WorkItemPurgeResult) _then;

/// Create a copy of WorkItemPurgeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? status = null,Object? filesDeleted = null,}) {
  return _then(WorkItemPurgeResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemPurgeResultStatus,filesDeleted: null == filesDeleted ? _self.filesDeleted : filesDeleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemPurgeResult].
extension WorkItemPurgeResultPatterns on WorkItemPurgeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemPurgeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemPurgeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemPurgeResult value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemPurgeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemPurgeResult value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemPurgeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemPurgeResultStatus status, @JsonKey(name: 'files_deleted')  int filesDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemPurgeResult() when $default != null:
return $default(_that.workItemId,_that.status,_that.filesDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemPurgeResultStatus status, @JsonKey(name: 'files_deleted')  int filesDeleted)  $default,) {final _that = this;
switch (_that) {
case _WorkItemPurgeResult():
return $default(_that.workItemId,_that.status,_that.filesDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemPurgeResultStatus status, @JsonKey(name: 'files_deleted')  int filesDeleted)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemPurgeResult() when $default != null:
return $default(_that.workItemId,_that.status,_that.filesDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemPurgeResult implements WorkItemPurgeResult {
  const _WorkItemPurgeResult({@JsonKey(name: 'work_item_id') required this.workItemId, required this.status, @JsonKey(name: 'files_deleted') required this.filesDeleted});
  factory _WorkItemPurgeResult.fromJson(Map<String, dynamic> json) => _$WorkItemPurgeResultFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  WorkItemPurgeResultStatus status;
@override@JsonKey(name: 'files_deleted') final  int filesDeleted;

/// Create a copy of WorkItemPurgeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemPurgeResultCopyWith<_WorkItemPurgeResult> get copyWith => __$WorkItemPurgeResultCopyWithImpl<_WorkItemPurgeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemPurgeResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemPurgeResult&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.status, status) || other.status == status)&&(identical(other.filesDeleted, filesDeleted) || other.filesDeleted == filesDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,status,filesDeleted);
}

@override
String toString() {
    return 'WorkItemPurgeResult(workItemId: $workItemId, status: $status, filesDeleted: $filesDeleted)';
}


}

/// @nodoc
abstract mixin class _$WorkItemPurgeResultCopyWith<$Res> implements $WorkItemPurgeResultCopyWith<$Res> {
  factory _$WorkItemPurgeResultCopyWith(_WorkItemPurgeResult value, $Res Function(_WorkItemPurgeResult) _then) = __$WorkItemPurgeResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, WorkItemPurgeResultStatus status,@JsonKey(name: 'files_deleted') int filesDeleted
});




}
/// @nodoc
class __$WorkItemPurgeResultCopyWithImpl<$Res>
    implements _$WorkItemPurgeResultCopyWith<$Res> {
  __$WorkItemPurgeResultCopyWithImpl(this._self, this._then);

  final _WorkItemPurgeResult _self;
  final $Res Function(_WorkItemPurgeResult) _then;

/// Create a copy of WorkItemPurgeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? status = null,Object? filesDeleted = null,}) {
  return _then(_WorkItemPurgeResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemPurgeResultStatus,filesDeleted: null == filesDeleted ? _self.filesDeleted : filesDeleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
