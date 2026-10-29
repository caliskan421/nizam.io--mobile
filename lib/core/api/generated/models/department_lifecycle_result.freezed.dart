// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_lifecycle_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentLifecycleResult {

@JsonKey(name: 'department_id') String get departmentId; DepartmentLifecycleResultStatus get status;
/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentLifecycleResultCopyWith<DepartmentLifecycleResult> get copyWith => _$DepartmentLifecycleResultCopyWithImpl<DepartmentLifecycleResult>(this as DepartmentLifecycleResult, _$identity);

  /// Serializes this DepartmentLifecycleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentLifecycleResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentLifecycleResult&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentLifecycleResult;
  return Object.hash(runtimeType,_this.departmentId,_this.status);
}

@override
String toString() {
  final _this = this as DepartmentLifecycleResult;
  return 'DepartmentLifecycleResult(departmentId: ${_this.departmentId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $DepartmentLifecycleResultCopyWith<$Res>  {
  factory $DepartmentLifecycleResultCopyWith(DepartmentLifecycleResult value, $Res Function(DepartmentLifecycleResult) _then) = _$DepartmentLifecycleResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, DepartmentLifecycleResultStatus status
});




}
/// @nodoc
class _$DepartmentLifecycleResultCopyWithImpl<$Res>
    implements $DepartmentLifecycleResultCopyWith<$Res> {
  _$DepartmentLifecycleResultCopyWithImpl(this._self, this._then);

  final DepartmentLifecycleResult _self;
  final $Res Function(DepartmentLifecycleResult) _then;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? status = null,}) {
  return _then(DepartmentLifecycleResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartmentLifecycleResultStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentLifecycleResult].
extension DepartmentLifecycleResultPatterns on DepartmentLifecycleResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentLifecycleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentLifecycleResult value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentLifecycleResult value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
return $default(_that.departmentId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status)  $default,) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult():
return $default(_that.departmentId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
return $default(_that.departmentId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentLifecycleResult implements DepartmentLifecycleResult {
  const _DepartmentLifecycleResult({@JsonKey(name: 'department_id') required this.departmentId, required this.status});
  factory _DepartmentLifecycleResult.fromJson(Map<String, dynamic> json) => _$DepartmentLifecycleResultFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  DepartmentLifecycleResultStatus status;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentLifecycleResultCopyWith<_DepartmentLifecycleResult> get copyWith => __$DepartmentLifecycleResultCopyWithImpl<_DepartmentLifecycleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentLifecycleResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentLifecycleResult&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,status);
}

@override
String toString() {
    return 'DepartmentLifecycleResult(departmentId: $departmentId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$DepartmentLifecycleResultCopyWith<$Res> implements $DepartmentLifecycleResultCopyWith<$Res> {
  factory _$DepartmentLifecycleResultCopyWith(_DepartmentLifecycleResult value, $Res Function(_DepartmentLifecycleResult) _then) = __$DepartmentLifecycleResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, DepartmentLifecycleResultStatus status
});




}
/// @nodoc
class __$DepartmentLifecycleResultCopyWithImpl<$Res>
    implements _$DepartmentLifecycleResultCopyWith<$Res> {
  __$DepartmentLifecycleResultCopyWithImpl(this._self, this._then);

  final _DepartmentLifecycleResult _self;
  final $Res Function(_DepartmentLifecycleResult) _then;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? status = null,}) {
  return _then(_DepartmentLifecycleResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartmentLifecycleResultStatus,
  ));
}


}

// dart format on
