// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DependencyList {

/// Ön görevler.
 List<DependencyEdge> get dependencies;/// Bu göreve bağımlı görevler.
 List<DependencyEdge> get dependents;
/// Create a copy of DependencyList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyListCopyWith<DependencyList> get copyWith => _$DependencyListCopyWithImpl<DependencyList>(this as DependencyList, _$identity);

  /// Serializes this DependencyList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DependencyList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DependencyList&&const DeepCollectionEquality().equals(other.dependencies, _this.dependencies)&&const DeepCollectionEquality().equals(other.dependents, _this.dependents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DependencyList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.dependencies),const DeepCollectionEquality().hash(_this.dependents));
}

@override
String toString() {
  final _this = this as DependencyList;
  return 'DependencyList(dependencies: ${_this.dependencies}, dependents: ${_this.dependents})';
}


}

/// @nodoc
abstract mixin class $DependencyListCopyWith<$Res>  {
  factory $DependencyListCopyWith(DependencyList value, $Res Function(DependencyList) _then) = _$DependencyListCopyWithImpl;
@useResult
$Res call({
 List<DependencyEdge> dependencies, List<DependencyEdge> dependents
});




}
/// @nodoc
class _$DependencyListCopyWithImpl<$Res>
    implements $DependencyListCopyWith<$Res> {
  _$DependencyListCopyWithImpl(this._self, this._then);

  final DependencyList _self;
  final $Res Function(DependencyList) _then;

/// Create a copy of DependencyList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dependencies = null,Object? dependents = null,}) {
  return _then(DependencyList(
dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<DependencyEdge>,dependents: null == dependents ? _self.dependents : dependents // ignore: cast_nullable_to_non_nullable
as List<DependencyEdge>,
  ));
}

}


/// Adds pattern-matching-related methods to [DependencyList].
extension DependencyListPatterns on DependencyList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DependencyList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DependencyList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DependencyList value)  $default,){
final _that = this;
switch (_that) {
case _DependencyList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DependencyList value)?  $default,){
final _that = this;
switch (_that) {
case _DependencyList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DependencyEdge> dependencies,  List<DependencyEdge> dependents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DependencyList() when $default != null:
return $default(_that.dependencies,_that.dependents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DependencyEdge> dependencies,  List<DependencyEdge> dependents)  $default,) {final _that = this;
switch (_that) {
case _DependencyList():
return $default(_that.dependencies,_that.dependents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DependencyEdge> dependencies,  List<DependencyEdge> dependents)?  $default,) {final _that = this;
switch (_that) {
case _DependencyList() when $default != null:
return $default(_that.dependencies,_that.dependents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DependencyList implements DependencyList {
  const _DependencyList({required  List<DependencyEdge> dependencies, required  List<DependencyEdge> dependents}): _dependencies = dependencies,_dependents = dependents;
  factory _DependencyList.fromJson(Map<String, dynamic> json) => _$DependencyListFromJson(json);

/// Ön görevler.
 final  List<DependencyEdge> _dependencies;
/// Ön görevler.
@override List<DependencyEdge> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

/// Bu göreve bağımlı görevler.
 final  List<DependencyEdge> _dependents;
/// Bu göreve bağımlı görevler.
@override List<DependencyEdge> get dependents {
  if (_dependents is EqualUnmodifiableListView) return _dependents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependents);
}


/// Create a copy of DependencyList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DependencyListCopyWith<_DependencyList> get copyWith => __$DependencyListCopyWithImpl<_DependencyList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DependencyListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DependencyList&&const DeepCollectionEquality().equals(other.dependencies, _dependencies)&&const DeepCollectionEquality().equals(other.dependents, _dependents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_dependents));
}

@override
String toString() {
    return 'DependencyList(dependencies: $dependencies, dependents: $dependents)';
}


}

/// @nodoc
abstract mixin class _$DependencyListCopyWith<$Res> implements $DependencyListCopyWith<$Res> {
  factory _$DependencyListCopyWith(_DependencyList value, $Res Function(_DependencyList) _then) = __$DependencyListCopyWithImpl;
@override @useResult
$Res call({
 List<DependencyEdge> dependencies, List<DependencyEdge> dependents
});




}
/// @nodoc
class __$DependencyListCopyWithImpl<$Res>
    implements _$DependencyListCopyWith<$Res> {
  __$DependencyListCopyWithImpl(this._self, this._then);

  final _DependencyList _self;
  final $Res Function(_DependencyList) _then;

/// Create a copy of DependencyList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dependencies = null,Object? dependents = null,}) {
  return _then(_DependencyList(
dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<DependencyEdge>,dependents: null == dependents ? _self._dependents : dependents // ignore: cast_nullable_to_non_nullable
as List<DependencyEdge>,
  ));
}


}

// dart format on
