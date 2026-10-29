// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportDepartment {

@JsonKey(name: 'department_id') String get departmentId; String get name; String? get kind;
/// Create a copy of ReportDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportDepartmentCopyWith<ReportDepartment> get copyWith => _$ReportDepartmentCopyWithImpl<ReportDepartment>(this as ReportDepartment, _$identity);

  /// Serializes this ReportDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.kind);
}

@override
String toString() {
  final _this = this as ReportDepartment;
  return 'ReportDepartment(departmentId: ${_this.departmentId}, name: ${_this.name}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $ReportDepartmentCopyWith<$Res>  {
  factory $ReportDepartmentCopyWith(ReportDepartment value, $Res Function(ReportDepartment) _then) = _$ReportDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String? kind
});




}
/// @nodoc
class _$ReportDepartmentCopyWithImpl<$Res>
    implements $ReportDepartmentCopyWith<$Res> {
  _$ReportDepartmentCopyWithImpl(this._self, this._then);

  final ReportDepartment _self;
  final $Res Function(ReportDepartment) _then;

/// Create a copy of ReportDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? kind = freezed,}) {
  return _then(ReportDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportDepartment].
extension ReportDepartmentPatterns on ReportDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportDepartment value)  $default,){
final _that = this;
switch (_that) {
case _ReportDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _ReportDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String? kind)  $default,) {final _that = this;
switch (_that) {
case _ReportDepartment():
return $default(_that.departmentId,_that.name,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String? kind)?  $default,) {final _that = this;
switch (_that) {
case _ReportDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportDepartment implements ReportDepartment {
  const _ReportDepartment({@JsonKey(name: 'department_id') required this.departmentId, required this.name, this.kind});
  factory _ReportDepartment.fromJson(Map<String, dynamic> json) => _$ReportDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
@override final  String? kind;

/// Create a copy of ReportDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportDepartmentCopyWith<_ReportDepartment> get copyWith => __$ReportDepartmentCopyWithImpl<_ReportDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,kind);
}

@override
String toString() {
    return 'ReportDepartment(departmentId: $departmentId, name: $name, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ReportDepartmentCopyWith<$Res> implements $ReportDepartmentCopyWith<$Res> {
  factory _$ReportDepartmentCopyWith(_ReportDepartment value, $Res Function(_ReportDepartment) _then) = __$ReportDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String? kind
});




}
/// @nodoc
class __$ReportDepartmentCopyWithImpl<$Res>
    implements _$ReportDepartmentCopyWith<$Res> {
  __$ReportDepartmentCopyWithImpl(this._self, this._then);

  final _ReportDepartment _self;
  final $Res Function(_ReportDepartment) _then;

/// Create a copy of ReportDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? kind = freezed,}) {
  return _then(_ReportDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
