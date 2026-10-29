// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_task_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportTaskDetail {

 ReportTask get task; String get description; List<ReportTaskRef> get dependencies;@JsonKey(name: 'recent_notes') List<ReportTaskNote> get recentNotes;
/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTaskDetailCopyWith<ReportTaskDetail> get copyWith => _$ReportTaskDetailCopyWithImpl<ReportTaskDetail>(this as ReportTaskDetail, _$identity);

  /// Serializes this ReportTaskDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportTaskDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTaskDetail&&(identical(other.task, _this.task) || other.task == _this.task)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.dependencies, _this.dependencies)&&const DeepCollectionEquality().equals(other.recentNotes, _this.recentNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportTaskDetail;
  return Object.hash(runtimeType,_this.task,_this.description,const DeepCollectionEquality().hash(_this.dependencies),const DeepCollectionEquality().hash(_this.recentNotes));
}

@override
String toString() {
  final _this = this as ReportTaskDetail;
  return 'ReportTaskDetail(task: ${_this.task}, description: ${_this.description}, dependencies: ${_this.dependencies}, recentNotes: ${_this.recentNotes})';
}


}

/// @nodoc
abstract mixin class $ReportTaskDetailCopyWith<$Res>  {
  factory $ReportTaskDetailCopyWith(ReportTaskDetail value, $Res Function(ReportTaskDetail) _then) = _$ReportTaskDetailCopyWithImpl;
@useResult
$Res call({
 ReportTask task, String description, List<ReportTaskRef> dependencies,@JsonKey(name: 'recent_notes') List<ReportTaskNote> recentNotes
});


$ReportTaskCopyWith<$Res> get task;

}
/// @nodoc
class _$ReportTaskDetailCopyWithImpl<$Res>
    implements $ReportTaskDetailCopyWith<$Res> {
  _$ReportTaskDetailCopyWithImpl(this._self, this._then);

  final ReportTaskDetail _self;
  final $Res Function(ReportTaskDetail) _then;

/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? description = null,Object? dependencies = null,Object? recentNotes = null,}) {
  return _then(ReportTaskDetail(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ReportTask,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<ReportTaskRef>,recentNotes: null == recentNotes ? _self.recentNotes : recentNotes // ignore: cast_nullable_to_non_nullable
as List<ReportTaskNote>,
  ));
}
/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTaskCopyWith<$Res> get task {
  
  return $ReportTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportTaskDetail].
extension ReportTaskDetailPatterns on ReportTaskDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTaskDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTaskDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTaskDetail value)  $default,){
final _that = this;
switch (_that) {
case _ReportTaskDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTaskDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTaskDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportTask task,  String description,  List<ReportTaskRef> dependencies, @JsonKey(name: 'recent_notes')  List<ReportTaskNote> recentNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTaskDetail() when $default != null:
return $default(_that.task,_that.description,_that.dependencies,_that.recentNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportTask task,  String description,  List<ReportTaskRef> dependencies, @JsonKey(name: 'recent_notes')  List<ReportTaskNote> recentNotes)  $default,) {final _that = this;
switch (_that) {
case _ReportTaskDetail():
return $default(_that.task,_that.description,_that.dependencies,_that.recentNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportTask task,  String description,  List<ReportTaskRef> dependencies, @JsonKey(name: 'recent_notes')  List<ReportTaskNote> recentNotes)?  $default,) {final _that = this;
switch (_that) {
case _ReportTaskDetail() when $default != null:
return $default(_that.task,_that.description,_that.dependencies,_that.recentNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTaskDetail implements ReportTaskDetail {
  const _ReportTaskDetail({required this.task, required this.description, required  List<ReportTaskRef> dependencies, @JsonKey(name: 'recent_notes') required  List<ReportTaskNote> recentNotes}): _dependencies = dependencies,_recentNotes = recentNotes;
  factory _ReportTaskDetail.fromJson(Map<String, dynamic> json) => _$ReportTaskDetailFromJson(json);

@override final  ReportTask task;
@override final  String description;
 final  List<ReportTaskRef> _dependencies;
@override List<ReportTaskRef> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

 final  List<ReportTaskNote> _recentNotes;
@override@JsonKey(name: 'recent_notes') List<ReportTaskNote> get recentNotes {
  if (_recentNotes is EqualUnmodifiableListView) return _recentNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentNotes);
}


/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTaskDetailCopyWith<_ReportTaskDetail> get copyWith => __$ReportTaskDetailCopyWithImpl<_ReportTaskDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTaskDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTaskDetail&&(identical(other.task, task) || other.task == task)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.dependencies, _dependencies)&&const DeepCollectionEquality().equals(other.recentNotes, _recentNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,task,description,const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_recentNotes));
}

@override
String toString() {
    return 'ReportTaskDetail(task: $task, description: $description, dependencies: $dependencies, recentNotes: $recentNotes)';
}


}

/// @nodoc
abstract mixin class _$ReportTaskDetailCopyWith<$Res> implements $ReportTaskDetailCopyWith<$Res> {
  factory _$ReportTaskDetailCopyWith(_ReportTaskDetail value, $Res Function(_ReportTaskDetail) _then) = __$ReportTaskDetailCopyWithImpl;
@override @useResult
$Res call({
 ReportTask task, String description, List<ReportTaskRef> dependencies,@JsonKey(name: 'recent_notes') List<ReportTaskNote> recentNotes
});


@override $ReportTaskCopyWith<$Res> get task;

}
/// @nodoc
class __$ReportTaskDetailCopyWithImpl<$Res>
    implements _$ReportTaskDetailCopyWith<$Res> {
  __$ReportTaskDetailCopyWithImpl(this._self, this._then);

  final _ReportTaskDetail _self;
  final $Res Function(_ReportTaskDetail) _then;

/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? description = null,Object? dependencies = null,Object? recentNotes = null,}) {
  return _then(_ReportTaskDetail(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ReportTask,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<ReportTaskRef>,recentNotes: null == recentNotes ? _self._recentNotes : recentNotes // ignore: cast_nullable_to_non_nullable
as List<ReportTaskNote>,
  ));
}

/// Create a copy of ReportTaskDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTaskCopyWith<$Res> get task {
  
  return $ReportTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
