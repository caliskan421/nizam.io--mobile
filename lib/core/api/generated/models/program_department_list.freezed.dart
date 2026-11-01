// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_department_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramDepartmentList {

 List<ProgramDepartment> get departments;
/// Create a copy of ProgramDepartmentList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDepartmentListCopyWith<ProgramDepartmentList> get copyWith => _$ProgramDepartmentListCopyWithImpl<ProgramDepartmentList>(this as ProgramDepartmentList, _$identity);

  /// Serializes this ProgramDepartmentList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDepartmentList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDepartmentList&&const DeepCollectionEquality().equals(other.departments, _this.departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDepartmentList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.departments));
}

@override
String toString() {
  final _this = this as ProgramDepartmentList;
  return 'ProgramDepartmentList(departments: ${_this.departments})';
}


}

/// @nodoc
abstract mixin class $ProgramDepartmentListCopyWith<$Res>  {
  factory $ProgramDepartmentListCopyWith(ProgramDepartmentList value, $Res Function(ProgramDepartmentList) _then) = _$ProgramDepartmentListCopyWithImpl;
@useResult
$Res call({
 List<ProgramDepartment> departments
});




}
/// @nodoc
class _$ProgramDepartmentListCopyWithImpl<$Res>
    implements $ProgramDepartmentListCopyWith<$Res> {
  _$ProgramDepartmentListCopyWithImpl(this._self, this._then);

  final ProgramDepartmentList _self;
  final $Res Function(ProgramDepartmentList) _then;

/// Create a copy of ProgramDepartmentList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departments = null,}) {
  return _then(ProgramDepartmentList(
departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<ProgramDepartment>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramDepartmentList].
extension ProgramDepartmentListPatterns on ProgramDepartmentList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDepartmentList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDepartmentList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDepartmentList value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDepartmentList value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProgramDepartment> departments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDepartmentList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProgramDepartment> departments)  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProgramDepartment> departments)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentList() when $default != null:
return $default(_that.departments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDepartmentList implements ProgramDepartmentList {
  const _ProgramDepartmentList({required  List<ProgramDepartment> departments}): _departments = departments;
  factory _ProgramDepartmentList.fromJson(Map<String, dynamic> json) => _$ProgramDepartmentListFromJson(json);

 final  List<ProgramDepartment> _departments;
@override List<ProgramDepartment> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}


/// Create a copy of ProgramDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDepartmentListCopyWith<_ProgramDepartmentList> get copyWith => __$ProgramDepartmentListCopyWithImpl<_ProgramDepartmentList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDepartmentListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDepartmentList&&const DeepCollectionEquality().equals(other.departments, _departments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_departments));
}

@override
String toString() {
    return 'ProgramDepartmentList(departments: $departments)';
}


}

/// @nodoc
abstract mixin class _$ProgramDepartmentListCopyWith<$Res> implements $ProgramDepartmentListCopyWith<$Res> {
  factory _$ProgramDepartmentListCopyWith(_ProgramDepartmentList value, $Res Function(_ProgramDepartmentList) _then) = __$ProgramDepartmentListCopyWithImpl;
@override @useResult
$Res call({
 List<ProgramDepartment> departments
});




}
/// @nodoc
class __$ProgramDepartmentListCopyWithImpl<$Res>
    implements _$ProgramDepartmentListCopyWith<$Res> {
  __$ProgramDepartmentListCopyWithImpl(this._self, this._then);

  final _ProgramDepartmentList _self;
  final $Res Function(_ProgramDepartmentList) _then;

/// Create a copy of ProgramDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departments = null,}) {
  return _then(_ProgramDepartmentList(
departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<ProgramDepartment>,
  ));
}


}

// dart format on
