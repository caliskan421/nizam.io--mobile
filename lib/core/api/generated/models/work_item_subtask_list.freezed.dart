// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_subtask_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemSubtaskList {

 List<WorkItemSubtask> get subtasks; int get total;
/// Create a copy of WorkItemSubtaskList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemSubtaskListCopyWith<WorkItemSubtaskList> get copyWith => _$WorkItemSubtaskListCopyWithImpl<WorkItemSubtaskList>(this as WorkItemSubtaskList, _$identity);

  /// Serializes this WorkItemSubtaskList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemSubtaskList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemSubtaskList&&const DeepCollectionEquality().equals(other.subtasks, _this.subtasks)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemSubtaskList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.subtasks),_this.total);
}

@override
String toString() {
  final _this = this as WorkItemSubtaskList;
  return 'WorkItemSubtaskList(subtasks: ${_this.subtasks}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $WorkItemSubtaskListCopyWith<$Res>  {
  factory $WorkItemSubtaskListCopyWith(WorkItemSubtaskList value, $Res Function(WorkItemSubtaskList) _then) = _$WorkItemSubtaskListCopyWithImpl;
@useResult
$Res call({
 List<WorkItemSubtask> subtasks, int total
});




}
/// @nodoc
class _$WorkItemSubtaskListCopyWithImpl<$Res>
    implements $WorkItemSubtaskListCopyWith<$Res> {
  _$WorkItemSubtaskListCopyWithImpl(this._self, this._then);

  final WorkItemSubtaskList _self;
  final $Res Function(WorkItemSubtaskList) _then;

/// Create a copy of WorkItemSubtaskList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtasks = null,Object? total = null,}) {
  return _then(WorkItemSubtaskList(
subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<WorkItemSubtask>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemSubtaskList].
extension WorkItemSubtaskListPatterns on WorkItemSubtaskList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemSubtaskList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemSubtaskList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemSubtaskList value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemSubtaskList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemSubtaskList value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemSubtaskList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkItemSubtask> subtasks,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemSubtaskList() when $default != null:
return $default(_that.subtasks,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkItemSubtask> subtasks,  int total)  $default,) {final _that = this;
switch (_that) {
case _WorkItemSubtaskList():
return $default(_that.subtasks,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkItemSubtask> subtasks,  int total)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemSubtaskList() when $default != null:
return $default(_that.subtasks,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemSubtaskList implements WorkItemSubtaskList {
  const _WorkItemSubtaskList({required  List<WorkItemSubtask> subtasks, required this.total}): _subtasks = subtasks;
  factory _WorkItemSubtaskList.fromJson(Map<String, dynamic> json) => _$WorkItemSubtaskListFromJson(json);

 final  List<WorkItemSubtask> _subtasks;
@override List<WorkItemSubtask> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}

@override final  int total;

/// Create a copy of WorkItemSubtaskList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemSubtaskListCopyWith<_WorkItemSubtaskList> get copyWith => __$WorkItemSubtaskListCopyWithImpl<_WorkItemSubtaskList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemSubtaskListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemSubtaskList&&const DeepCollectionEquality().equals(other.subtasks, _subtasks)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_subtasks),total);
}

@override
String toString() {
    return 'WorkItemSubtaskList(subtasks: $subtasks, total: $total)';
}


}

/// @nodoc
abstract mixin class _$WorkItemSubtaskListCopyWith<$Res> implements $WorkItemSubtaskListCopyWith<$Res> {
  factory _$WorkItemSubtaskListCopyWith(_WorkItemSubtaskList value, $Res Function(_WorkItemSubtaskList) _then) = __$WorkItemSubtaskListCopyWithImpl;
@override @useResult
$Res call({
 List<WorkItemSubtask> subtasks, int total
});




}
/// @nodoc
class __$WorkItemSubtaskListCopyWithImpl<$Res>
    implements _$WorkItemSubtaskListCopyWith<$Res> {
  __$WorkItemSubtaskListCopyWithImpl(this._self, this._then);

  final _WorkItemSubtaskList _self;
  final $Res Function(_WorkItemSubtaskList) _then;

/// Create a copy of WorkItemSubtaskList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtasks = null,Object? total = null,}) {
  return _then(_WorkItemSubtaskList(
subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<WorkItemSubtask>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
