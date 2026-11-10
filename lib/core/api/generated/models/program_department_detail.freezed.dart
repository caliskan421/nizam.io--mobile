// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_department_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramDepartmentDetail {

@JsonKey(name: 'department_id') String get departmentId;/// Departmanın bu programdaki adı.
@JsonKey(name: 'display_name') String get displayName; ProgramDepartmentDetailKind get kind;/// Katalog kodu; kod verilmemişse alan yoktur.
 String? get code;/// Katalog açıklaması; boşsa alan yoktur.
 String? get description;
/// Create a copy of ProgramDepartmentDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDepartmentDetailCopyWith<ProgramDepartmentDetail> get copyWith => _$ProgramDepartmentDetailCopyWithImpl<ProgramDepartmentDetail>(this as ProgramDepartmentDetail, _$identity);

  /// Serializes this ProgramDepartmentDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDepartmentDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDepartmentDetail&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDepartmentDetail;
  return Object.hash(runtimeType,_this.departmentId,_this.displayName,_this.kind,_this.code,_this.description);
}

@override
String toString() {
  final _this = this as ProgramDepartmentDetail;
  return 'ProgramDepartmentDetail(departmentId: ${_this.departmentId}, displayName: ${_this.displayName}, kind: ${_this.kind}, code: ${_this.code}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $ProgramDepartmentDetailCopyWith<$Res>  {
  factory $ProgramDepartmentDetailCopyWith(ProgramDepartmentDetail value, $Res Function(ProgramDepartmentDetail) _then) = _$ProgramDepartmentDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, ProgramDepartmentDetailKind kind, String? code, String? description
});




}
/// @nodoc
class _$ProgramDepartmentDetailCopyWithImpl<$Res>
    implements $ProgramDepartmentDetailCopyWith<$Res> {
  _$ProgramDepartmentDetailCopyWithImpl(this._self, this._then);

  final ProgramDepartmentDetail _self;
  final $Res Function(ProgramDepartmentDetail) _then;

/// Create a copy of ProgramDepartmentDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? displayName = null,Object? kind = null,Object? code = freezed,Object? description = freezed,}) {
  return _then(ProgramDepartmentDetail(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProgramDepartmentDetailKind,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramDepartmentDetail].
extension ProgramDepartmentDetailPatterns on ProgramDepartmentDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDepartmentDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDepartmentDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDepartmentDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDepartmentDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  ProgramDepartmentDetailKind kind,  String? code,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDepartmentDetail() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.kind,_that.code,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  ProgramDepartmentDetailKind kind,  String? code,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentDetail():
return $default(_that.departmentId,_that.displayName,_that.kind,_that.code,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  ProgramDepartmentDetailKind kind,  String? code,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentDetail() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.kind,_that.code,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDepartmentDetail implements ProgramDepartmentDetail {
  const _ProgramDepartmentDetail({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'display_name') required this.displayName, required this.kind, this.code, this.description});
  factory _ProgramDepartmentDetail.fromJson(Map<String, dynamic> json) => _$ProgramDepartmentDetailFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın bu programdaki adı.
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  ProgramDepartmentDetailKind kind;
/// Katalog kodu; kod verilmemişse alan yoktur.
@override final  String? code;
/// Katalog açıklaması; boşsa alan yoktur.
@override final  String? description;

/// Create a copy of ProgramDepartmentDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDepartmentDetailCopyWith<_ProgramDepartmentDetail> get copyWith => __$ProgramDepartmentDetailCopyWithImpl<_ProgramDepartmentDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDepartmentDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDepartmentDetail&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,displayName,kind,code,description);
}

@override
String toString() {
    return 'ProgramDepartmentDetail(departmentId: $departmentId, displayName: $displayName, kind: $kind, code: $code, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ProgramDepartmentDetailCopyWith<$Res> implements $ProgramDepartmentDetailCopyWith<$Res> {
  factory _$ProgramDepartmentDetailCopyWith(_ProgramDepartmentDetail value, $Res Function(_ProgramDepartmentDetail) _then) = __$ProgramDepartmentDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, ProgramDepartmentDetailKind kind, String? code, String? description
});




}
/// @nodoc
class __$ProgramDepartmentDetailCopyWithImpl<$Res>
    implements _$ProgramDepartmentDetailCopyWith<$Res> {
  __$ProgramDepartmentDetailCopyWithImpl(this._self, this._then);

  final _ProgramDepartmentDetail _self;
  final $Res Function(_ProgramDepartmentDetail) _then;

/// Create a copy of ProgramDepartmentDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? displayName = null,Object? kind = null,Object? code = freezed,Object? description = freezed,}) {
  return _then(_ProgramDepartmentDetail(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProgramDepartmentDetailKind,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
