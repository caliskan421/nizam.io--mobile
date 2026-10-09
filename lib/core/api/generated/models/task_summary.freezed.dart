// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskSummary {

@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'active_items') int get activeItems;@JsonKey(name: 'completed_items') int get completedItems;
/// Create a copy of TaskSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSummaryCopyWith<TaskSummary> get copyWith => _$TaskSummaryCopyWithImpl<TaskSummary>(this as TaskSummary, _$identity);

  /// Serializes this TaskSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSummary&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.activeItems, _this.activeItems) || other.activeItems == _this.activeItems)&&(identical(other.completedItems, _this.completedItems) || other.completedItems == _this.completedItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskSummary;
  return Object.hash(runtimeType,_this.departmentId,_this.activeItems,_this.completedItems);
}

@override
String toString() {
  final _this = this as TaskSummary;
  return 'TaskSummary(departmentId: ${_this.departmentId}, activeItems: ${_this.activeItems}, completedItems: ${_this.completedItems})';
}


}

/// @nodoc
abstract mixin class $TaskSummaryCopyWith<$Res>  {
  factory $TaskSummaryCopyWith(TaskSummary value, $Res Function(TaskSummary) _then) = _$TaskSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems
});




}
/// @nodoc
class _$TaskSummaryCopyWithImpl<$Res>
    implements $TaskSummaryCopyWith<$Res> {
  _$TaskSummaryCopyWithImpl(this._self, this._then);

  final TaskSummary _self;
  final $Res Function(TaskSummary) _then;

/// Create a copy of TaskSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? activeItems = null,Object? completedItems = null,}) {
  return _then(TaskSummary(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSummary].
extension TaskSummaryPatterns on TaskSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSummary value)  $default,){
final _that = this;
switch (_that) {
case _TaskSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSummary() when $default != null:
return $default(_that.departmentId,_that.activeItems,_that.completedItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems)  $default,) {final _that = this;
switch (_that) {
case _TaskSummary():
return $default(_that.departmentId,_that.activeItems,_that.completedItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems)?  $default,) {final _that = this;
switch (_that) {
case _TaskSummary() when $default != null:
return $default(_that.departmentId,_that.activeItems,_that.completedItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSummary implements TaskSummary {
  const _TaskSummary({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'active_items') required this.activeItems, @JsonKey(name: 'completed_items') required this.completedItems});
  factory _TaskSummary.fromJson(Map<String, dynamic> json) => _$TaskSummaryFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'active_items') final  int activeItems;
@override@JsonKey(name: 'completed_items') final  int completedItems;

/// Create a copy of TaskSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSummaryCopyWith<_TaskSummary> get copyWith => __$TaskSummaryCopyWithImpl<_TaskSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSummary&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.activeItems, activeItems) || other.activeItems == activeItems)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,activeItems,completedItems);
}

@override
String toString() {
    return 'TaskSummary(departmentId: $departmentId, activeItems: $activeItems, completedItems: $completedItems)';
}


}

/// @nodoc
abstract mixin class _$TaskSummaryCopyWith<$Res> implements $TaskSummaryCopyWith<$Res> {
  factory _$TaskSummaryCopyWith(_TaskSummary value, $Res Function(_TaskSummary) _then) = __$TaskSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems
});




}
/// @nodoc
class __$TaskSummaryCopyWithImpl<$Res>
    implements _$TaskSummaryCopyWith<$Res> {
  __$TaskSummaryCopyWithImpl(this._self, this._then);

  final _TaskSummary _self;
  final $Res Function(_TaskSummary) _then;

/// Create a copy of TaskSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? activeItems = null,Object? completedItems = null,}) {
  return _then(_TaskSummary(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
