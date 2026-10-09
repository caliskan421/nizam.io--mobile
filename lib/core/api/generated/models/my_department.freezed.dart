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

@JsonKey(name: 'department_id') String get departmentId; String get name; String get role;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as MyDepartment;
  return 'MyDepartment(departmentId: ${_this.departmentId}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $MyDepartmentCopyWith<$Res>  {
  factory $MyDepartmentCopyWith(MyDepartment value, $Res Function(MyDepartment) _then) = _$MyDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String role
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
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? role = null,}) {
  return _then(MyDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String role)  $default,) {final _that = this;
switch (_that) {
case _MyDepartment():
return $default(_that.departmentId,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String role)?  $default,) {final _that = this;
switch (_that) {
case _MyDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyDepartment implements MyDepartment {
  const _MyDepartment({@JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.role});
  factory _MyDepartment.fromJson(Map<String, dynamic> json) => _$MyDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,role);
}

@override
String toString() {
    return 'MyDepartment(departmentId: $departmentId, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$MyDepartmentCopyWith<$Res> implements $MyDepartmentCopyWith<$Res> {
  factory _$MyDepartmentCopyWith(_MyDepartment value, $Res Function(_MyDepartment) _then) = __$MyDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String role
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
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? role = null,}) {
  return _then(_MyDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
