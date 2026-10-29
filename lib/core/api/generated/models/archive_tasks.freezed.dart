// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_tasks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveTasks {

 List<ArchiveTask> get tasks;
/// Create a copy of ArchiveTasks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveTasksCopyWith<ArchiveTasks> get copyWith => _$ArchiveTasksCopyWithImpl<ArchiveTasks>(this as ArchiveTasks, _$identity);

  /// Serializes this ArchiveTasks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveTasks;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveTasks&&const DeepCollectionEquality().equals(other.tasks, _this.tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveTasks;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tasks));
}

@override
String toString() {
  final _this = this as ArchiveTasks;
  return 'ArchiveTasks(tasks: ${_this.tasks})';
}


}

/// @nodoc
abstract mixin class $ArchiveTasksCopyWith<$Res>  {
  factory $ArchiveTasksCopyWith(ArchiveTasks value, $Res Function(ArchiveTasks) _then) = _$ArchiveTasksCopyWithImpl;
@useResult
$Res call({
 List<ArchiveTask> tasks
});




}
/// @nodoc
class _$ArchiveTasksCopyWithImpl<$Res>
    implements $ArchiveTasksCopyWith<$Res> {
  _$ArchiveTasksCopyWithImpl(this._self, this._then);

  final ArchiveTasks _self;
  final $Res Function(ArchiveTasks) _then;

/// Create a copy of ArchiveTasks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,}) {
  return _then(ArchiveTasks(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ArchiveTask>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveTasks].
extension ArchiveTasksPatterns on ArchiveTasks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveTasks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveTasks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveTasks value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveTasks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveTasks value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveTasks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ArchiveTask> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveTasks() when $default != null:
return $default(_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ArchiveTask> tasks)  $default,) {final _that = this;
switch (_that) {
case _ArchiveTasks():
return $default(_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ArchiveTask> tasks)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveTasks() when $default != null:
return $default(_that.tasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveTasks implements ArchiveTasks {
  const _ArchiveTasks({required  List<ArchiveTask> tasks}): _tasks = tasks;
  factory _ArchiveTasks.fromJson(Map<String, dynamic> json) => _$ArchiveTasksFromJson(json);

 final  List<ArchiveTask> _tasks;
@override List<ArchiveTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of ArchiveTasks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveTasksCopyWith<_ArchiveTasks> get copyWith => __$ArchiveTasksCopyWithImpl<_ArchiveTasks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveTasksToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveTasks&&const DeepCollectionEquality().equals(other.tasks, _tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks));
}

@override
String toString() {
    return 'ArchiveTasks(tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$ArchiveTasksCopyWith<$Res> implements $ArchiveTasksCopyWith<$Res> {
  factory _$ArchiveTasksCopyWith(_ArchiveTasks value, $Res Function(_ArchiveTasks) _then) = __$ArchiveTasksCopyWithImpl;
@override @useResult
$Res call({
 List<ArchiveTask> tasks
});




}
/// @nodoc
class __$ArchiveTasksCopyWithImpl<$Res>
    implements _$ArchiveTasksCopyWith<$Res> {
  __$ArchiveTasksCopyWithImpl(this._self, this._then);

  final _ArchiveTasks _self;
  final $Res Function(_ArchiveTasks) _then;

/// Create a copy of ArchiveTasks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,}) {
  return _then(_ArchiveTasks(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ArchiveTask>,
  ));
}


}

// dart format on
