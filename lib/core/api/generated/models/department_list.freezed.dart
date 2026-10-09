// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentList {

 List<Department> get departments;
/// Create a copy of DepartmentList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentListCopyWith<DepartmentList> get copyWith => _$DepartmentListCopyWithImpl<DepartmentList>(this as DepartmentList, _$identity);

  /// Serializes this DepartmentList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentList&&const DeepCollectionEquality().equals(other.departments, _this.departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.departments));
}

@override
String toString() {
  final _this = this as DepartmentList;
  return 'DepartmentList(departments: ${_this.departments})';
}


}

/// @nodoc
abstract mixin class $DepartmentListCopyWith<$Res>  {
  factory $DepartmentListCopyWith(DepartmentList value, $Res Function(DepartmentList) _then) = _$DepartmentListCopyWithImpl;
@useResult
$Res call({
 List<Department> departments
});




}
/// @nodoc
class _$DepartmentListCopyWithImpl<$Res>
    implements $DepartmentListCopyWith<$Res> {
  _$DepartmentListCopyWithImpl(this._self, this._then);

  final DepartmentList _self;
  final $Res Function(DepartmentList) _then;

/// Create a copy of DepartmentList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departments = null,}) {
  return _then(DepartmentList(
departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<Department>,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentList].
extension DepartmentListPatterns on DepartmentList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentList value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentList value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Department> departments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentList() when $default != null:
return $default(_that.departments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Department> departments)  $default,) {final _that = this;
switch (_that) {
case _DepartmentList():
return $default(_that.departments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Department> departments)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentList() when $default != null:
return $default(_that.departments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentList implements DepartmentList {
  const _DepartmentList({required  List<Department> departments}): _departments = departments;
  factory _DepartmentList.fromJson(Map<String, dynamic> json) => _$DepartmentListFromJson(json);

 final  List<Department> _departments;
@override List<Department> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}


/// Create a copy of DepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentListCopyWith<_DepartmentList> get copyWith => __$DepartmentListCopyWithImpl<_DepartmentList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentList&&const DeepCollectionEquality().equals(other.departments, _departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_departments));
}

@override
String toString() {
    return 'DepartmentList(departments: $departments)';
}


}

/// @nodoc
abstract mixin class _$DepartmentListCopyWith<$Res> implements $DepartmentListCopyWith<$Res> {
  factory _$DepartmentListCopyWith(_DepartmentList value, $Res Function(_DepartmentList) _then) = __$DepartmentListCopyWithImpl;
@override @useResult
$Res call({
 List<Department> departments
});




}
/// @nodoc
class __$DepartmentListCopyWithImpl<$Res>
    implements _$DepartmentListCopyWith<$Res> {
  __$DepartmentListCopyWithImpl(this._self, this._then);

  final _DepartmentList _self;
  final $Res Function(_DepartmentList) _then;

/// Create a copy of DepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departments = null,}) {
  return _then(_DepartmentList(
departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<Department>,
  ));
}


}

// dart format on
