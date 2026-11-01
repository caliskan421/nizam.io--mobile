// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramDepartment {

@JsonKey(name: 'department_id') String get departmentId;/// Departmanın bu programdaki adı.
@JsonKey(name: 'display_name') String get displayName;/// Katalog kodu; kod verilmemişse alan yoktur.
 String? get code;
/// Create a copy of ProgramDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDepartmentCopyWith<ProgramDepartment> get copyWith => _$ProgramDepartmentCopyWithImpl<ProgramDepartment>(this as ProgramDepartment, _$identity);

  /// Serializes this ProgramDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.code, _this.code) || other.code == _this.code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.displayName,_this.code);
}

@override
String toString() {
  final _this = this as ProgramDepartment;
  return 'ProgramDepartment(departmentId: ${_this.departmentId}, displayName: ${_this.displayName}, code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $ProgramDepartmentCopyWith<$Res>  {
  factory $ProgramDepartmentCopyWith(ProgramDepartment value, $Res Function(ProgramDepartment) _then) = _$ProgramDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, String? code
});




}
/// @nodoc
class _$ProgramDepartmentCopyWithImpl<$Res>
    implements $ProgramDepartmentCopyWith<$Res> {
  _$ProgramDepartmentCopyWithImpl(this._self, this._then);

  final ProgramDepartment _self;
  final $Res Function(ProgramDepartment) _then;

/// Create a copy of ProgramDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? displayName = null,Object? code = freezed,}) {
  return _then(ProgramDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramDepartment].
extension ProgramDepartmentPatterns on ProgramDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDepartment value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDepartment() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String? code)  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartment():
return $default(_that.departmentId,_that.displayName,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartment() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDepartment implements ProgramDepartment {
  const _ProgramDepartment({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'display_name') required this.displayName, this.code});
  factory _ProgramDepartment.fromJson(Map<String, dynamic> json) => _$ProgramDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın bu programdaki adı.
@override@JsonKey(name: 'display_name') final  String displayName;
/// Katalog kodu; kod verilmemişse alan yoktur.
@override final  String? code;

/// Create a copy of ProgramDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDepartmentCopyWith<_ProgramDepartment> get copyWith => __$ProgramDepartmentCopyWithImpl<_ProgramDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,displayName,code);
}

@override
String toString() {
    return 'ProgramDepartment(departmentId: $departmentId, displayName: $displayName, code: $code)';
}


}

/// @nodoc
abstract mixin class _$ProgramDepartmentCopyWith<$Res> implements $ProgramDepartmentCopyWith<$Res> {
  factory _$ProgramDepartmentCopyWith(_ProgramDepartment value, $Res Function(_ProgramDepartment) _then) = __$ProgramDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, String? code
});




}
/// @nodoc
class __$ProgramDepartmentCopyWithImpl<$Res>
    implements _$ProgramDepartmentCopyWith<$Res> {
  __$ProgramDepartmentCopyWithImpl(this._self, this._then);

  final _ProgramDepartment _self;
  final $Res Function(_ProgramDepartment) _then;

/// Create a copy of ProgramDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? displayName = null,Object? code = freezed,}) {
  return _then(_ProgramDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
