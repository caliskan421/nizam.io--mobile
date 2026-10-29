// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency_edge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DependencyEdge {

@JsonKey(name: 'dependency_id') String get dependencyId;@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'depends_on_work_item_id') String get dependsOnWorkItemId;
/// Create a copy of DependencyEdge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyEdgeCopyWith<DependencyEdge> get copyWith => _$DependencyEdgeCopyWithImpl<DependencyEdge>(this as DependencyEdge, _$identity);

  /// Serializes this DependencyEdge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DependencyEdge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DependencyEdge&&(identical(other.dependencyId, _this.dependencyId) || other.dependencyId == _this.dependencyId)&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.dependsOnWorkItemId, _this.dependsOnWorkItemId) || other.dependsOnWorkItemId == _this.dependsOnWorkItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DependencyEdge;
  return Object.hash(runtimeType,_this.dependencyId,_this.workItemId,_this.dependsOnWorkItemId);
}

@override
String toString() {
  final _this = this as DependencyEdge;
  return 'DependencyEdge(dependencyId: ${_this.dependencyId}, workItemId: ${_this.workItemId}, dependsOnWorkItemId: ${_this.dependsOnWorkItemId})';
}


}

/// @nodoc
abstract mixin class $DependencyEdgeCopyWith<$Res>  {
  factory $DependencyEdgeCopyWith(DependencyEdge value, $Res Function(DependencyEdge) _then) = _$DependencyEdgeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'dependency_id') String dependencyId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'depends_on_work_item_id') String dependsOnWorkItemId
});




}
/// @nodoc
class _$DependencyEdgeCopyWithImpl<$Res>
    implements $DependencyEdgeCopyWith<$Res> {
  _$DependencyEdgeCopyWithImpl(this._self, this._then);

  final DependencyEdge _self;
  final $Res Function(DependencyEdge) _then;

/// Create a copy of DependencyEdge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dependencyId = null,Object? workItemId = null,Object? dependsOnWorkItemId = null,}) {
  return _then(DependencyEdge(
dependencyId: null == dependencyId ? _self.dependencyId : dependencyId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,dependsOnWorkItemId: null == dependsOnWorkItemId ? _self.dependsOnWorkItemId : dependsOnWorkItemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DependencyEdge].
extension DependencyEdgePatterns on DependencyEdge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DependencyEdge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DependencyEdge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DependencyEdge value)  $default,){
final _that = this;
switch (_that) {
case _DependencyEdge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DependencyEdge value)?  $default,){
final _that = this;
switch (_that) {
case _DependencyEdge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'dependency_id')  String dependencyId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DependencyEdge() when $default != null:
return $default(_that.dependencyId,_that.workItemId,_that.dependsOnWorkItemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'dependency_id')  String dependencyId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)  $default,) {final _that = this;
switch (_that) {
case _DependencyEdge():
return $default(_that.dependencyId,_that.workItemId,_that.dependsOnWorkItemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'dependency_id')  String dependencyId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)?  $default,) {final _that = this;
switch (_that) {
case _DependencyEdge() when $default != null:
return $default(_that.dependencyId,_that.workItemId,_that.dependsOnWorkItemId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DependencyEdge implements DependencyEdge {
  const _DependencyEdge({@JsonKey(name: 'dependency_id') required this.dependencyId, @JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'depends_on_work_item_id') required this.dependsOnWorkItemId});
  factory _DependencyEdge.fromJson(Map<String, dynamic> json) => _$DependencyEdgeFromJson(json);

@override@JsonKey(name: 'dependency_id') final  String dependencyId;
@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override@JsonKey(name: 'depends_on_work_item_id') final  String dependsOnWorkItemId;

/// Create a copy of DependencyEdge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DependencyEdgeCopyWith<_DependencyEdge> get copyWith => __$DependencyEdgeCopyWithImpl<_DependencyEdge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DependencyEdgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DependencyEdge&&(identical(other.dependencyId, dependencyId) || other.dependencyId == dependencyId)&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.dependsOnWorkItemId, dependsOnWorkItemId) || other.dependsOnWorkItemId == dependsOnWorkItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dependencyId,workItemId,dependsOnWorkItemId);
}

@override
String toString() {
    return 'DependencyEdge(dependencyId: $dependencyId, workItemId: $workItemId, dependsOnWorkItemId: $dependsOnWorkItemId)';
}


}

/// @nodoc
abstract mixin class _$DependencyEdgeCopyWith<$Res> implements $DependencyEdgeCopyWith<$Res> {
  factory _$DependencyEdgeCopyWith(_DependencyEdge value, $Res Function(_DependencyEdge) _then) = __$DependencyEdgeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'dependency_id') String dependencyId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'depends_on_work_item_id') String dependsOnWorkItemId
});




}
/// @nodoc
class __$DependencyEdgeCopyWithImpl<$Res>
    implements _$DependencyEdgeCopyWith<$Res> {
  __$DependencyEdgeCopyWithImpl(this._self, this._then);

  final _DependencyEdge _self;
  final $Res Function(_DependencyEdge) _then;

/// Create a copy of DependencyEdge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dependencyId = null,Object? workItemId = null,Object? dependsOnWorkItemId = null,}) {
  return _then(_DependencyEdge(
dependencyId: null == dependencyId ? _self.dependencyId : dependencyId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,dependsOnWorkItemId: null == dependsOnWorkItemId ? _self.dependsOnWorkItemId : dependsOnWorkItemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
