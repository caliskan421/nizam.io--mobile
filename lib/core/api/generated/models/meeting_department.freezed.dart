// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingDepartment {

@JsonKey(name: 'department_id') String get departmentId;/// Bağ kurulduğu andaki departman adı.
@JsonKey(name: 'department_name') String get departmentName;
/// Create a copy of MeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingDepartmentCopyWith<MeetingDepartment> get copyWith => _$MeetingDepartmentCopyWithImpl<MeetingDepartment>(this as MeetingDepartment, _$identity);

  /// Serializes this MeetingDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.departmentName);
}

@override
String toString() {
  final _this = this as MeetingDepartment;
  return 'MeetingDepartment(departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName})';
}


}

/// @nodoc
abstract mixin class $MeetingDepartmentCopyWith<$Res>  {
  factory $MeetingDepartmentCopyWith(MeetingDepartment value, $Res Function(MeetingDepartment) _then) = _$MeetingDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName
});




}
/// @nodoc
class _$MeetingDepartmentCopyWithImpl<$Res>
    implements $MeetingDepartmentCopyWith<$Res> {
  _$MeetingDepartmentCopyWithImpl(this._self, this._then);

  final MeetingDepartment _self;
  final $Res Function(MeetingDepartment) _then;

/// Create a copy of MeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? departmentName = null,}) {
  return _then(MeetingDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingDepartment].
extension MeetingDepartmentPatterns on MeetingDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingDepartment value)  $default,){
final _that = this;
switch (_that) {
case _MeetingDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingDepartment() when $default != null:
return $default(_that.departmentId,_that.departmentName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName)  $default,) {final _that = this;
switch (_that) {
case _MeetingDepartment():
return $default(_that.departmentId,_that.departmentName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName)?  $default,) {final _that = this;
switch (_that) {
case _MeetingDepartment() when $default != null:
return $default(_that.departmentId,_that.departmentName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingDepartment implements MeetingDepartment {
  const _MeetingDepartment({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName});
  factory _MeetingDepartment.fromJson(Map<String, dynamic> json) => _$MeetingDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Bağ kurulduğu andaki departman adı.
@override@JsonKey(name: 'department_name') final  String departmentName;

/// Create a copy of MeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingDepartmentCopyWith<_MeetingDepartment> get copyWith => __$MeetingDepartmentCopyWithImpl<_MeetingDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,departmentName);
}

@override
String toString() {
    return 'MeetingDepartment(departmentId: $departmentId, departmentName: $departmentName)';
}


}

/// @nodoc
abstract mixin class _$MeetingDepartmentCopyWith<$Res> implements $MeetingDepartmentCopyWith<$Res> {
  factory _$MeetingDepartmentCopyWith(_MeetingDepartment value, $Res Function(_MeetingDepartment) _then) = __$MeetingDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName
});




}
/// @nodoc
class __$MeetingDepartmentCopyWithImpl<$Res>
    implements _$MeetingDepartmentCopyWith<$Res> {
  __$MeetingDepartmentCopyWithImpl(this._self, this._then);

  final _MeetingDepartment _self;
  final $Res Function(_MeetingDepartment) _then;

/// Create a copy of MeetingDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? departmentName = null,}) {
  return _then(_MeetingDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
