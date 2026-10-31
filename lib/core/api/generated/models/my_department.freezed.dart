// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyDepartment {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName;@JsonKey(name: 'department_id') String get departmentId;/// Departmanın bu programdaki adı.
@JsonKey(name: 'display_name') String get displayName; String get role;
/// Create a copy of MyDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyDepartmentCopyWith<MyDepartment> get copyWith => _$MyDepartmentCopyWithImpl<MyDepartment>(this as MyDepartment, _$identity);

  /// Serializes this MyDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyDepartment&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyDepartment;
  return Object.hash(runtimeType,_this.programId,_this.programName,_this.departmentId,_this.displayName,_this.role);
}

@override
String toString() {
  final _this = this as MyDepartment;
  return 'MyDepartment(programId: ${_this.programId}, programName: ${_this.programName}, departmentId: ${_this.departmentId}, displayName: ${_this.displayName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $MyDepartmentCopyWith<$Res>  {
  factory $MyDepartmentCopyWith(MyDepartment value, $Res Function(MyDepartment) _then) = _$MyDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, String role
});




}
/// @nodoc
class _$MyDepartmentCopyWithImpl<$Res>
    implements $MyDepartmentCopyWith<$Res> {
  _$MyDepartmentCopyWithImpl(this._self, this._then);

  final MyDepartment _self;
  final $Res Function(MyDepartment) _then;

/// Create a copy of MyDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? departmentId = null,Object? displayName = null,Object? role = null,}) {
  return _then(MyDepartment(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MyDepartment].
extension MyDepartmentPatterns on MyDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyDepartment value)  $default,){
final _that = this;
switch (_that) {
case _MyDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
return $default(_that.programId,_that.programName,_that.departmentId,_that.displayName,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String role)  $default,) {final _that = this;
switch (_that) {
case _MyDepartment():
return $default(_that.programId,_that.programName,_that.departmentId,_that.displayName,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  String role)?  $default,) {final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
return $default(_that.programId,_that.programName,_that.departmentId,_that.displayName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyDepartment implements MyDepartment {
  const _MyDepartment({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'display_name') required this.displayName, required this.role});
  factory _MyDepartment.fromJson(Map<String, dynamic> json) => _$MyDepartmentFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın bu programdaki adı.
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  String role;

/// Create a copy of MyDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyDepartmentCopyWith<_MyDepartment> get copyWith => __$MyDepartmentCopyWithImpl<_MyDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyDepartment&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,departmentId,displayName,role);
}

@override
String toString() {
    return 'MyDepartment(programId: $programId, programName: $programName, departmentId: $departmentId, displayName: $displayName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$MyDepartmentCopyWith<$Res> implements $MyDepartmentCopyWith<$Res> {
  factory _$MyDepartmentCopyWith(_MyDepartment value, $Res Function(_MyDepartment) _then) = __$MyDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, String role
});




}
/// @nodoc
class __$MyDepartmentCopyWithImpl<$Res>
    implements _$MyDepartmentCopyWith<$Res> {
  __$MyDepartmentCopyWithImpl(this._self, this._then);

  final _MyDepartment _self;
  final $Res Function(_MyDepartment) _then;

/// Create a copy of MyDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? departmentId = null,Object? displayName = null,Object? role = null,}) {
  return _then(_MyDepartment(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
