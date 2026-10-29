// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_lifecycle_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemLifecycleResult {

@JsonKey(name: 'work_item_id') String get workItemId; WorkItemLifecycleResultStatus get status;
/// Create a copy of WorkItemLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemLifecycleResultCopyWith<WorkItemLifecycleResult> get copyWith => _$WorkItemLifecycleResultCopyWithImpl<WorkItemLifecycleResult>(this as WorkItemLifecycleResult, _$identity);

  /// Serializes this WorkItemLifecycleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemLifecycleResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemLifecycleResult&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemLifecycleResult;
  return Object.hash(runtimeType,_this.workItemId,_this.status);
}

@override
String toString() {
  final _this = this as WorkItemLifecycleResult;
  return 'WorkItemLifecycleResult(workItemId: ${_this.workItemId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $WorkItemLifecycleResultCopyWith<$Res>  {
  factory $WorkItemLifecycleResultCopyWith(WorkItemLifecycleResult value, $Res Function(WorkItemLifecycleResult) _then) = _$WorkItemLifecycleResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, WorkItemLifecycleResultStatus status
});




}
/// @nodoc
class _$WorkItemLifecycleResultCopyWithImpl<$Res>
    implements $WorkItemLifecycleResultCopyWith<$Res> {
  _$WorkItemLifecycleResultCopyWithImpl(this._self, this._then);

  final WorkItemLifecycleResult _self;
  final $Res Function(WorkItemLifecycleResult) _then;

/// Create a copy of WorkItemLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? status = null,}) {
  return _then(WorkItemLifecycleResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemLifecycleResultStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemLifecycleResult].
extension WorkItemLifecycleResultPatterns on WorkItemLifecycleResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemLifecycleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemLifecycleResult value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemLifecycleResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemLifecycleResult value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemLifecycleResultStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemLifecycleResult() when $default != null:
return $default(_that.workItemId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemLifecycleResultStatus status)  $default,) {final _that = this;
switch (_that) {
case _WorkItemLifecycleResult():
return $default(_that.workItemId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  WorkItemLifecycleResultStatus status)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemLifecycleResult() when $default != null:
return $default(_that.workItemId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemLifecycleResult implements WorkItemLifecycleResult {
  const _WorkItemLifecycleResult({@JsonKey(name: 'work_item_id') required this.workItemId, required this.status});
  factory _WorkItemLifecycleResult.fromJson(Map<String, dynamic> json) => _$WorkItemLifecycleResultFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  WorkItemLifecycleResultStatus status;

/// Create a copy of WorkItemLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemLifecycleResultCopyWith<_WorkItemLifecycleResult> get copyWith => __$WorkItemLifecycleResultCopyWithImpl<_WorkItemLifecycleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemLifecycleResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemLifecycleResult&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,status);
}

@override
String toString() {
    return 'WorkItemLifecycleResult(workItemId: $workItemId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$WorkItemLifecycleResultCopyWith<$Res> implements $WorkItemLifecycleResultCopyWith<$Res> {
  factory _$WorkItemLifecycleResultCopyWith(_WorkItemLifecycleResult value, $Res Function(_WorkItemLifecycleResult) _then) = __$WorkItemLifecycleResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, WorkItemLifecycleResultStatus status
});




}
/// @nodoc
class __$WorkItemLifecycleResultCopyWithImpl<$Res>
    implements _$WorkItemLifecycleResultCopyWith<$Res> {
  __$WorkItemLifecycleResultCopyWithImpl(this._self, this._then);

  final _WorkItemLifecycleResult _self;
  final $Res Function(_WorkItemLifecycleResult) _then;

/// Create a copy of WorkItemLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? status = null,}) {
  return _then(_WorkItemLifecycleResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkItemLifecycleResultStatus,
  ));
}


}

// dart format on
