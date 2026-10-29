// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gantt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Gantt {

 List<GanttTask> get tasks; List<GanttLink> get links;
/// Create a copy of Gantt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GanttCopyWith<Gantt> get copyWith => _$GanttCopyWithImpl<Gantt>(this as Gantt, _$identity);

  /// Serializes this Gantt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Gantt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Gantt&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&const DeepCollectionEquality().equals(other.links, _this.links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Gantt;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tasks),const DeepCollectionEquality().hash(_this.links));
}

@override
String toString() {
  final _this = this as Gantt;
  return 'Gantt(tasks: ${_this.tasks}, links: ${_this.links})';
}


}

/// @nodoc
abstract mixin class $GanttCopyWith<$Res>  {
  factory $GanttCopyWith(Gantt value, $Res Function(Gantt) _then) = _$GanttCopyWithImpl;
@useResult
$Res call({
 List<GanttTask> tasks, List<GanttLink> links
});




}
/// @nodoc
class _$GanttCopyWithImpl<$Res>
    implements $GanttCopyWith<$Res> {
  _$GanttCopyWithImpl(this._self, this._then);

  final Gantt _self;
  final $Res Function(Gantt) _then;

/// Create a copy of Gantt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? links = null,}) {
  return _then(Gantt(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<GanttTask>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<GanttLink>,
  ));
}

}


/// Adds pattern-matching-related methods to [Gantt].
extension GanttPatterns on Gantt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Gantt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Gantt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Gantt value)  $default,){
final _that = this;
switch (_that) {
case _Gantt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Gantt value)?  $default,){
final _that = this;
switch (_that) {
case _Gantt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GanttTask> tasks,  List<GanttLink> links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Gantt() when $default != null:
return $default(_that.tasks,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GanttTask> tasks,  List<GanttLink> links)  $default,) {final _that = this;
switch (_that) {
case _Gantt():
return $default(_that.tasks,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GanttTask> tasks,  List<GanttLink> links)?  $default,) {final _that = this;
switch (_that) {
case _Gantt() when $default != null:
return $default(_that.tasks,_that.links);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Gantt implements Gantt {
  const _Gantt({required  List<GanttTask> tasks, required  List<GanttLink> links}): _tasks = tasks,_links = links;
  factory _Gantt.fromJson(Map<String, dynamic> json) => _$GanttFromJson(json);

 final  List<GanttTask> _tasks;
@override List<GanttTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

 final  List<GanttLink> _links;
@override List<GanttLink> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}


/// Create a copy of Gantt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GanttCopyWith<_Gantt> get copyWith => __$GanttCopyWithImpl<_Gantt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GanttToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Gantt&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&const DeepCollectionEquality().equals(other.links, _links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),const DeepCollectionEquality().hash(_links));
}

@override
String toString() {
    return 'Gantt(tasks: $tasks, links: $links)';
}


}

/// @nodoc
abstract mixin class _$GanttCopyWith<$Res> implements $GanttCopyWith<$Res> {
  factory _$GanttCopyWith(_Gantt value, $Res Function(_Gantt) _then) = __$GanttCopyWithImpl;
@override @useResult
$Res call({
 List<GanttTask> tasks, List<GanttLink> links
});




}
/// @nodoc
class __$GanttCopyWithImpl<$Res>
    implements _$GanttCopyWith<$Res> {
  __$GanttCopyWithImpl(this._self, this._then);

  final _Gantt _self;
  final $Res Function(_Gantt) _then;

/// Create a copy of Gantt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? links = null,}) {
  return _then(_Gantt(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<GanttTask>,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<GanttLink>,
  ));
}


}

// dart format on
