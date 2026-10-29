// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyTask {

@JsonKey(name: 'work_item_id') String get workItemId; String get title; String get status;
/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTaskCopyWith<MyTask> get copyWith => _$MyTaskCopyWithImpl<MyTask>(this as MyTask, _$identity);

  /// Serializes this MyTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTask&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyTask;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.status);
}

@override
String toString() {
  final _this = this as MyTask;
  return 'MyTask(workItemId: ${_this.workItemId}, title: ${_this.title}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MyTaskCopyWith<$Res>  {
  factory $MyTaskCopyWith(MyTask value, $Res Function(MyTask) _then) = _$MyTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status
});




}
/// @nodoc
class _$MyTaskCopyWithImpl<$Res>
    implements $MyTaskCopyWith<$Res> {
  _$MyTaskCopyWithImpl(this._self, this._then);

  final MyTask _self;
  final $Res Function(MyTask) _then;

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? status = null,}) {
  return _then(MyTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MyTask].
extension MyTaskPatterns on MyTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyTask value)  $default,){
final _that = this;
switch (_that) {
case _MyTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyTask value)?  $default,){
final _that = this;
switch (_that) {
case _MyTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status)  $default,) {final _that = this;
switch (_that) {
case _MyTask():
return $default(_that.workItemId,_that.title,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status)?  $default,) {final _that = this;
switch (_that) {
case _MyTask() when $default != null:
return $default(_that.workItemId,_that.title,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyTask implements MyTask {
  const _MyTask({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, required this.status});
  factory _MyTask.fromJson(Map<String, dynamic> json) => _$MyTaskFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override final  String status;

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyTaskCopyWith<_MyTask> get copyWith => __$MyTaskCopyWithImpl<_MyTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyTask&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,status);
}

@override
String toString() {
    return 'MyTask(workItemId: $workItemId, title: $title, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MyTaskCopyWith<$Res> implements $MyTaskCopyWith<$Res> {
  factory _$MyTaskCopyWith(_MyTask value, $Res Function(_MyTask) _then) = __$MyTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status
});




}
/// @nodoc
class __$MyTaskCopyWithImpl<$Res>
    implements _$MyTaskCopyWith<$Res> {
  __$MyTaskCopyWithImpl(this._self, this._then);

  final _MyTask _self;
  final $Res Function(_MyTask) _then;

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? status = null,}) {
  return _then(_MyTask(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
