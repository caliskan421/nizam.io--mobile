// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deleted_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletedDepartment {

@JsonKey(name: 'department_id') String get departmentId; String get name; String get kind;/// RFC 3339 (UTC); silinme zamanı okunamazsa boş.
@JsonKey(name: 'deleted_at') String get deletedAt; String? get code;
/// Create a copy of DeletedDepartment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedDepartmentCopyWith<DeletedDepartment> get copyWith => _$DeletedDepartmentCopyWithImpl<DeletedDepartment>(this as DeletedDepartment, _$identity);

  /// Serializes this DeletedDepartment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeletedDepartment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedDepartment&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.code, _this.code) || other.code == _this.code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeletedDepartment;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.kind,_this.deletedAt,_this.code);
}

@override
String toString() {
  final _this = this as DeletedDepartment;
  return 'DeletedDepartment(departmentId: ${_this.departmentId}, name: ${_this.name}, kind: ${_this.kind}, deletedAt: ${_this.deletedAt}, code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $DeletedDepartmentCopyWith<$Res>  {
  factory $DeletedDepartmentCopyWith(DeletedDepartment value, $Res Function(DeletedDepartment) _then) = _$DeletedDepartmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String kind,@JsonKey(name: 'deleted_at') String deletedAt, String? code
});




}
/// @nodoc
class _$DeletedDepartmentCopyWithImpl<$Res>
    implements $DeletedDepartmentCopyWith<$Res> {
  _$DeletedDepartmentCopyWithImpl(this._self, this._then);

  final DeletedDepartment _self;
  final $Res Function(DeletedDepartment) _then;

/// Create a copy of DeletedDepartment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? kind = null,Object? deletedAt = null,Object? code = freezed,}) {
  return _then(DeletedDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedDepartment].
extension DeletedDepartmentPatterns on DeletedDepartment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedDepartment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedDepartment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedDepartment value)  $default,){
final _that = this;
switch (_that) {
case _DeletedDepartment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedDepartment value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedDepartment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind, @JsonKey(name: 'deleted_at')  String deletedAt,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind,_that.deletedAt,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind, @JsonKey(name: 'deleted_at')  String deletedAt,  String? code)  $default,) {final _that = this;
switch (_that) {
case _DeletedDepartment():
return $default(_that.departmentId,_that.name,_that.kind,_that.deletedAt,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  String kind, @JsonKey(name: 'deleted_at')  String deletedAt,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _DeletedDepartment() when $default != null:
return $default(_that.departmentId,_that.name,_that.kind,_that.deletedAt,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedDepartment implements DeletedDepartment {
  const _DeletedDepartment({@JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.kind, @JsonKey(name: 'deleted_at') required this.deletedAt, this.code});
  factory _DeletedDepartment.fromJson(Map<String, dynamic> json) => _$DeletedDepartmentFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
@override final  String kind;
/// RFC 3339 (UTC); silinme zamanı okunamazsa boş.
@override@JsonKey(name: 'deleted_at') final  String deletedAt;
@override final  String? code;

/// Create a copy of DeletedDepartment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedDepartmentCopyWith<_DeletedDepartment> get copyWith => __$DeletedDepartmentCopyWithImpl<_DeletedDepartment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedDepartmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedDepartment&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,kind,deletedAt,code);
}

@override
String toString() {
    return 'DeletedDepartment(departmentId: $departmentId, name: $name, kind: $kind, deletedAt: $deletedAt, code: $code)';
}


}

/// @nodoc
abstract mixin class _$DeletedDepartmentCopyWith<$Res> implements $DeletedDepartmentCopyWith<$Res> {
  factory _$DeletedDepartmentCopyWith(_DeletedDepartment value, $Res Function(_DeletedDepartment) _then) = __$DeletedDepartmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, String kind,@JsonKey(name: 'deleted_at') String deletedAt, String? code
});




}
/// @nodoc
class __$DeletedDepartmentCopyWithImpl<$Res>
    implements _$DeletedDepartmentCopyWith<$Res> {
  __$DeletedDepartmentCopyWithImpl(this._self, this._then);

  final _DeletedDepartment _self;
  final $Res Function(_DeletedDepartment) _then;

/// Create a copy of DeletedDepartment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? kind = null,Object? deletedAt = null,Object? code = freezed,}) {
  return _then(_DeletedDepartment(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
