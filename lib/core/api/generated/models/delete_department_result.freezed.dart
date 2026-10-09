// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_department_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteDepartmentResult {

@JsonKey(name: 'department_id') String get departmentId; bool get deleted;
/// Create a copy of DeleteDepartmentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteDepartmentResultCopyWith<DeleteDepartmentResult> get copyWith => _$DeleteDepartmentResultCopyWithImpl<DeleteDepartmentResult>(this as DeleteDepartmentResult, _$identity);

  /// Serializes this DeleteDepartmentResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeleteDepartmentResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteDepartmentResult&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeleteDepartmentResult;
  return Object.hash(runtimeType,_this.departmentId,_this.deleted);
}

@override
String toString() {
  final _this = this as DeleteDepartmentResult;
  return 'DeleteDepartmentResult(departmentId: ${_this.departmentId}, deleted: ${_this.deleted})';
}


}

/// @nodoc
abstract mixin class $DeleteDepartmentResultCopyWith<$Res>  {
  factory $DeleteDepartmentResultCopyWith(DeleteDepartmentResult value, $Res Function(DeleteDepartmentResult) _then) = _$DeleteDepartmentResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, bool deleted
});




}
/// @nodoc
class _$DeleteDepartmentResultCopyWithImpl<$Res>
    implements $DeleteDepartmentResultCopyWith<$Res> {
  _$DeleteDepartmentResultCopyWithImpl(this._self, this._then);

  final DeleteDepartmentResult _self;
  final $Res Function(DeleteDepartmentResult) _then;

/// Create a copy of DeleteDepartmentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? deleted = null,}) {
  return _then(DeleteDepartmentResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteDepartmentResult].
extension DeleteDepartmentResultPatterns on DeleteDepartmentResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteDepartmentResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteDepartmentResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteDepartmentResult value)  $default,){
final _that = this;
switch (_that) {
case _DeleteDepartmentResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteDepartmentResult value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteDepartmentResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteDepartmentResult() when $default != null:
return $default(_that.departmentId,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _DeleteDepartmentResult():
return $default(_that.departmentId,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _DeleteDepartmentResult() when $default != null:
return $default(_that.departmentId,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteDepartmentResult implements DeleteDepartmentResult {
  const _DeleteDepartmentResult({@JsonKey(name: 'department_id') required this.departmentId, required this.deleted});
  factory _DeleteDepartmentResult.fromJson(Map<String, dynamic> json) => _$DeleteDepartmentResultFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  bool deleted;

/// Create a copy of DeleteDepartmentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteDepartmentResultCopyWith<_DeleteDepartmentResult> get copyWith => __$DeleteDepartmentResultCopyWithImpl<_DeleteDepartmentResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteDepartmentResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteDepartmentResult&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,deleted);
}

@override
String toString() {
    return 'DeleteDepartmentResult(departmentId: $departmentId, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$DeleteDepartmentResultCopyWith<$Res> implements $DeleteDepartmentResultCopyWith<$Res> {
  factory _$DeleteDepartmentResultCopyWith(_DeleteDepartmentResult value, $Res Function(_DeleteDepartmentResult) _then) = __$DeleteDepartmentResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, bool deleted
});




}
/// @nodoc
class __$DeleteDepartmentResultCopyWithImpl<$Res>
    implements _$DeleteDepartmentResultCopyWith<$Res> {
  __$DeleteDepartmentResultCopyWithImpl(this._self, this._then);

  final _DeleteDepartmentResult _self;
  final $Res Function(_DeleteDepartmentResult) _then;

/// Create a copy of DeleteDepartmentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? deleted = null,}) {
  return _then(_DeleteDepartmentResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
