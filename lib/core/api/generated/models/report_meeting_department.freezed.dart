// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_meeting_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMeetingDepartment {

@JsonKey(name: 'department_id') String get departmentId; String get name; bool get deleted;
/// Create a copy of ReportMeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMeetingDepartmentCopyWith<ReportMeetingDepartment> get copyWith => _$ReportMeetingDepartmentCopyWithImpl<ReportMeetingDepartment>(this as ReportMeetingDepartment, _$identity);

  /// Serializes this ReportMeetingDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMeetingDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMeetingDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMeetingDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.deleted);
}

@override
String toString() {
  final _this = this as ReportMeetingDepartment;
  return 'ReportMeetingDepartment(departmentId: ${_this.departmentId}, name: ${_this.name}, deleted: ${_this.deleted})';
}


}

/// @nodoc
abstract mixin class $ReportMeetingDepartmentCopyWith<$Res>  {
  factory $ReportMeetingDepartmentCopyWith(ReportMeetingDepartment value, $Res Function(ReportMeetingDepartment) _then) = _$ReportMeetingDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, bool deleted
});




}
/// @nodoc
class _$ReportMeetingDepartmentCopyWithImpl<$Res>
    implements $ReportMeetingDepartmentCopyWith<$Res> {
  _$ReportMeetingDepartmentCopyWithImpl(this._self, this._then);

  final ReportMeetingDepartment _self;
  final $Res Function(ReportMeetingDepartment) _then;

/// Create a copy of ReportMeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? deleted = null,}) {
  return _then(ReportMeetingDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportMeetingDepartment].
extension ReportMeetingDepartmentPatterns on ReportMeetingDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMeetingDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMeetingDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMeetingDepartment value)  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMeetingDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMeetingDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingDepartment():
return $default(_that.departmentId,_that.name,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMeetingDepartment implements ReportMeetingDepartment {
  const _ReportMeetingDepartment({@JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.deleted});
  factory _ReportMeetingDepartment.fromJson(Map<String, dynamic> json) => _$ReportMeetingDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
@override final  bool deleted;

/// Create a copy of ReportMeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMeetingDepartmentCopyWith<_ReportMeetingDepartment> get copyWith => __$ReportMeetingDepartmentCopyWithImpl<_ReportMeetingDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMeetingDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMeetingDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,deleted);
}

@override
String toString() {
    return 'ReportMeetingDepartment(departmentId: $departmentId, name: $name, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$ReportMeetingDepartmentCopyWith<$Res> implements $ReportMeetingDepartmentCopyWith<$Res> {
  factory _$ReportMeetingDepartmentCopyWith(_ReportMeetingDepartment value, $Res Function(_ReportMeetingDepartment) _then) = __$ReportMeetingDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, bool deleted
});




}
/// @nodoc
class __$ReportMeetingDepartmentCopyWithImpl<$Res>
    implements _$ReportMeetingDepartmentCopyWith<$Res> {
  __$ReportMeetingDepartmentCopyWithImpl(this._self, this._then);

  final _ReportMeetingDepartment _self;
  final $Res Function(_ReportMeetingDepartment) _then;

/// Create a copy of ReportMeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? deleted = null,}) {
  return _then(_ReportMeetingDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
