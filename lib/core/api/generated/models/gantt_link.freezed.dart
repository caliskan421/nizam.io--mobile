// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gantt_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GanttLink {

@JsonKey(name: 'dependency_id') String get dependencyId;/// Ön görev.
 String get source;/// Bağımlı görev.
 String get target;@JsonKey(name: 'cross_department') bool get crossDepartment;
/// Create a copy of GanttLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GanttLinkCopyWith<GanttLink> get copyWith => _$GanttLinkCopyWithImpl<GanttLink>(this as GanttLink, _$identity);

  /// Serializes this GanttLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GanttLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GanttLink&&(identical(other.dependencyId, _this.dependencyId) || other.dependencyId == _this.dependencyId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.crossDepartment, _this.crossDepartment) || other.crossDepartment == _this.crossDepartment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GanttLink;
  return Object.hash(runtimeType,_this.dependencyId,_this.source,_this.target,_this.crossDepartment);
}

@override
String toString() {
  final _this = this as GanttLink;
  return 'GanttLink(dependencyId: ${_this.dependencyId}, source: ${_this.source}, target: ${_this.target}, crossDepartment: ${_this.crossDepartment})';
}


}

/// @nodoc
abstract mixin class $GanttLinkCopyWith<$Res>  {
  factory $GanttLinkCopyWith(GanttLink value, $Res Function(GanttLink) _then) = _$GanttLinkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'dependency_id') String dependencyId, String source, String target,@JsonKey(name: 'cross_department') bool crossDepartment
});




}
/// @nodoc
class _$GanttLinkCopyWithImpl<$Res>
    implements $GanttLinkCopyWith<$Res> {
  _$GanttLinkCopyWithImpl(this._self, this._then);

  final GanttLink _self;
  final $Res Function(GanttLink) _then;

/// Create a copy of GanttLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dependencyId = null,Object? source = null,Object? target = null,Object? crossDepartment = null,}) {
  return _then(GanttLink(
dependencyId: null == dependencyId ? _self.dependencyId : dependencyId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,crossDepartment: null == crossDepartment ? _self.crossDepartment : crossDepartment // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GanttLink].
extension GanttLinkPatterns on GanttLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GanttLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GanttLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GanttLink value)  $default,){
final _that = this;
switch (_that) {
case _GanttLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GanttLink value)?  $default,){
final _that = this;
switch (_that) {
case _GanttLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'dependency_id')  String dependencyId,  String source,  String target, @JsonKey(name: 'cross_department')  bool crossDepartment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GanttLink() when $default != null:
return $default(_that.dependencyId,_that.source,_that.target,_that.crossDepartment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'dependency_id')  String dependencyId,  String source,  String target, @JsonKey(name: 'cross_department')  bool crossDepartment)  $default,) {final _that = this;
switch (_that) {
case _GanttLink():
return $default(_that.dependencyId,_that.source,_that.target,_that.crossDepartment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'dependency_id')  String dependencyId,  String source,  String target, @JsonKey(name: 'cross_department')  bool crossDepartment)?  $default,) {final _that = this;
switch (_that) {
case _GanttLink() when $default != null:
return $default(_that.dependencyId,_that.source,_that.target,_that.crossDepartment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GanttLink implements GanttLink {
  const _GanttLink({@JsonKey(name: 'dependency_id') required this.dependencyId, required this.source, required this.target, @JsonKey(name: 'cross_department') required this.crossDepartment});
  factory _GanttLink.fromJson(Map<String, dynamic> json) => _$GanttLinkFromJson(json);

@override@JsonKey(name: 'dependency_id') final  String dependencyId;
/// Ön görev.
@override final  String source;
/// Bağımlı görev.
@override final  String target;
@override@JsonKey(name: 'cross_department') final  bool crossDepartment;

/// Create a copy of GanttLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GanttLinkCopyWith<_GanttLink> get copyWith => __$GanttLinkCopyWithImpl<_GanttLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GanttLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GanttLink&&(identical(other.dependencyId, dependencyId) || other.dependencyId == dependencyId)&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.crossDepartment, crossDepartment) || other.crossDepartment == crossDepartment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dependencyId,source,target,crossDepartment);
}

@override
String toString() {
    return 'GanttLink(dependencyId: $dependencyId, source: $source, target: $target, crossDepartment: $crossDepartment)';
}


}

/// @nodoc
abstract mixin class _$GanttLinkCopyWith<$Res> implements $GanttLinkCopyWith<$Res> {
  factory _$GanttLinkCopyWith(_GanttLink value, $Res Function(_GanttLink) _then) = __$GanttLinkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'dependency_id') String dependencyId, String source, String target,@JsonKey(name: 'cross_department') bool crossDepartment
});




}
/// @nodoc
class __$GanttLinkCopyWithImpl<$Res>
    implements _$GanttLinkCopyWith<$Res> {
  __$GanttLinkCopyWithImpl(this._self, this._then);

  final _GanttLink _self;
  final $Res Function(_GanttLink) _then;

/// Create a copy of GanttLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dependencyId = null,Object? source = null,Object? target = null,Object? crossDepartment = null,}) {
  return _then(_GanttLink(
dependencyId: null == dependencyId ? _self.dependencyId : dependencyId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,crossDepartment: null == crossDepartment ? _self.crossDepartment : crossDepartment // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
