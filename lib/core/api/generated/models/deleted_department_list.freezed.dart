// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deleted_department_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletedDepartmentList {

 List<DeletedDepartment> get departments;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of DeletedDepartmentList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedDepartmentListCopyWith<DeletedDepartmentList> get copyWith => _$DeletedDepartmentListCopyWithImpl<DeletedDepartmentList>(this as DeletedDepartmentList, _$identity);

  /// Serializes this DeletedDepartmentList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeletedDepartmentList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedDepartmentList&&const DeepCollectionEquality().equals(other.departments, _this.departments)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeletedDepartmentList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.departments),_this.nextCursor);
}

@override
String toString() {
  final _this = this as DeletedDepartmentList;
  return 'DeletedDepartmentList(departments: ${_this.departments}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $DeletedDepartmentListCopyWith<$Res>  {
  factory $DeletedDepartmentListCopyWith(DeletedDepartmentList value, $Res Function(DeletedDepartmentList) _then) = _$DeletedDepartmentListCopyWithImpl;
@useResult
$Res call({
 List<DeletedDepartment> departments,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$DeletedDepartmentListCopyWithImpl<$Res>
    implements $DeletedDepartmentListCopyWith<$Res> {
  _$DeletedDepartmentListCopyWithImpl(this._self, this._then);

  final DeletedDepartmentList _self;
  final $Res Function(DeletedDepartmentList) _then;

/// Create a copy of DeletedDepartmentList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departments = null,Object? nextCursor = freezed,}) {
  return _then(DeletedDepartmentList(
departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<DeletedDepartment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedDepartmentList].
extension DeletedDepartmentListPatterns on DeletedDepartmentList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedDepartmentList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedDepartmentList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedDepartmentList value)  $default,){
final _that = this;
switch (_that) {
case _DeletedDepartmentList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedDepartmentList value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedDepartmentList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DeletedDepartment> departments, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedDepartmentList() when $default != null:
return $default(_that.departments,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DeletedDepartment> departments, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _DeletedDepartmentList():
return $default(_that.departments,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DeletedDepartment> departments, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _DeletedDepartmentList() when $default != null:
return $default(_that.departments,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedDepartmentList implements DeletedDepartmentList {
  const _DeletedDepartmentList({required  List<DeletedDepartment> departments, @JsonKey(name: 'next_cursor') this.nextCursor}): _departments = departments;
  factory _DeletedDepartmentList.fromJson(Map<String, dynamic> json) => _$DeletedDepartmentListFromJson(json);

 final  List<DeletedDepartment> _departments;
@override List<DeletedDepartment> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of DeletedDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedDepartmentListCopyWith<_DeletedDepartmentList> get copyWith => __$DeletedDepartmentListCopyWithImpl<_DeletedDepartmentList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedDepartmentListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedDepartmentList&&const DeepCollectionEquality().equals(other.departments, _departments)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_departments),nextCursor);
}

@override
String toString() {
    return 'DeletedDepartmentList(departments: $departments, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$DeletedDepartmentListCopyWith<$Res> implements $DeletedDepartmentListCopyWith<$Res> {
  factory _$DeletedDepartmentListCopyWith(_DeletedDepartmentList value, $Res Function(_DeletedDepartmentList) _then) = __$DeletedDepartmentListCopyWithImpl;
@override @useResult
$Res call({
 List<DeletedDepartment> departments,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$DeletedDepartmentListCopyWithImpl<$Res>
    implements _$DeletedDepartmentListCopyWith<$Res> {
  __$DeletedDepartmentListCopyWithImpl(this._self, this._then);

  final _DeletedDepartmentList _self;
  final $Res Function(_DeletedDepartmentList) _then;

/// Create a copy of DeletedDepartmentList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departments = null,Object? nextCursor = freezed,}) {
  return _then(_DeletedDepartmentList(
departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<DeletedDepartment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
