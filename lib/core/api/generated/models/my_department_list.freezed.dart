// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_department_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyDepartmentList {

 List<MyDepartment>? get departments;
/// Create a copy of MyDepartmentList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyDepartmentListCopyWith<MyDepartmentList> get copyWith => _$MyDepartmentListCopyWithImpl<MyDepartmentList>(this as MyDepartmentList, _$identity);

  /// Serializes this MyDepartmentList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyDepartmentList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyDepartmentList&&const DeepCollectionEquality().equals(other.departments, _this.departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyDepartmentList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.departments));
}

@override
String toString() {
  final _this = this as MyDepartmentList;
  return 'MyDepartmentList(departments: ${_this.departments})';
}


}

/// @nodoc
abstract mixin class $MyDepartmentListCopyWith<$Res>  {
  factory $MyDepartmentListCopyWith(MyDepartmentList value, $Res Function(MyDepartmentList) _then) = _$MyDepartmentListCopyWithImpl;
@useResult
$Res call({
 List<MyDepartment>? departments
});




}
/// @nodoc
class _$MyDepartmentListCopyWithImpl<$Res>
    implements $MyDepartmentListCopyWith<$Res> {
  _$MyDepartmentListCopyWithImpl(this._self, this._then);

  final MyDepartmentList _self;
  final $Res Function(MyDepartmentList) _then;

/// Create a copy of MyDepartmentList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departments = freezed,}) {
  return _then(MyDepartmentList(
departments: freezed == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<MyDepartment>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyDepartmentList].
extension MyDepartmentListPatterns on MyDepartmentList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyDepartmentList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyDepartmentList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyDepartmentList value)  $default,){
final _that = this;
switch (_that) {
case _MyDepartmentList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyDepartmentList value)?  $default,){
final _that = this;
switch (_that) {
case _MyDepartmentList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MyDepartment>? departments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyDepartmentList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MyDepartment>? departments)  $default,) {final _that = this;
switch (_that) {
case _MyDepartmentList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MyDepartment>? departments)?  $default,) {final _that = this;
switch (_that) {
case _MyDepartmentList() when $default != null:
return $default(_that.departments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyDepartmentList implements MyDepartmentList {
  const _MyDepartmentList({required  List<MyDepartment>? departments}): _departments = departments;
  factory _MyDepartmentList.fromJson(Map<String, dynamic> json) => _$MyDepartmentListFromJson(json);

 final  List<MyDepartment>? _departments;
@override List<MyDepartment>? get departments {
  final value = _departments;
  if (value == null) return null;
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MyDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyDepartmentListCopyWith<_MyDepartmentList> get copyWith => __$MyDepartmentListCopyWithImpl<_MyDepartmentList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyDepartmentListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyDepartmentList&&const DeepCollectionEquality().equals(other.departments, _departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_departments));
}

@override
String toString() {
    return 'MyDepartmentList(departments: $departments)';
}


}

/// @nodoc
abstract mixin class _$MyDepartmentListCopyWith<$Res> implements $MyDepartmentListCopyWith<$Res> {
  factory _$MyDepartmentListCopyWith(_MyDepartmentList value, $Res Function(_MyDepartmentList) _then) = __$MyDepartmentListCopyWithImpl;
@override @useResult
$Res call({
 List<MyDepartment>? departments
});




}
/// @nodoc
class __$MyDepartmentListCopyWithImpl<$Res>
    implements _$MyDepartmentListCopyWith<$Res> {
  __$MyDepartmentListCopyWithImpl(this._self, this._then);

  final _MyDepartmentList _self;
  final $Res Function(_MyDepartmentList) _then;

/// Create a copy of MyDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departments = freezed,}) {
  return _then(_MyDepartmentList(
departments: freezed == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<MyDepartment>?,
  ));
}


}

// dart format on
