// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_department_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramDepartmentLink {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'department_id') String get departmentId;
/// Create a copy of ProgramDepartmentLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDepartmentLinkCopyWith<ProgramDepartmentLink> get copyWith => _$ProgramDepartmentLinkCopyWithImpl<ProgramDepartmentLink>(this as ProgramDepartmentLink, _$identity);

  /// Serializes this ProgramDepartmentLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDepartmentLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDepartmentLink&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDepartmentLink;
  return Object.hash(runtimeType,_this.programId,_this.departmentId);
}

@override
String toString() {
  final _this = this as ProgramDepartmentLink;
  return 'ProgramDepartmentLink(programId: ${_this.programId}, departmentId: ${_this.departmentId})';
}


}

/// @nodoc
abstract mixin class $ProgramDepartmentLinkCopyWith<$Res>  {
  factory $ProgramDepartmentLinkCopyWith(ProgramDepartmentLink value, $Res Function(ProgramDepartmentLink) _then) = _$ProgramDepartmentLinkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class _$ProgramDepartmentLinkCopyWithImpl<$Res>
    implements $ProgramDepartmentLinkCopyWith<$Res> {
  _$ProgramDepartmentLinkCopyWithImpl(this._self, this._then);

  final ProgramDepartmentLink _self;
  final $Res Function(ProgramDepartmentLink) _then;

/// Create a copy of ProgramDepartmentLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? departmentId = null,}) {
  return _then(ProgramDepartmentLink(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramDepartmentLink].
extension ProgramDepartmentLinkPatterns on ProgramDepartmentLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDepartmentLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDepartmentLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDepartmentLink value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDepartmentLink value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDepartmentLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDepartmentLink() when $default != null:
return $default(_that.programId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentLink():
return $default(_that.programId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDepartmentLink() when $default != null:
return $default(_that.programId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDepartmentLink implements ProgramDepartmentLink {
  const _ProgramDepartmentLink({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId});
  factory _ProgramDepartmentLink.fromJson(Map<String, dynamic> json) => _$ProgramDepartmentLinkFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'department_id') final  String departmentId;

/// Create a copy of ProgramDepartmentLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDepartmentLinkCopyWith<_ProgramDepartmentLink> get copyWith => __$ProgramDepartmentLinkCopyWithImpl<_ProgramDepartmentLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDepartmentLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDepartmentLink&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,departmentId);
}

@override
String toString() {
    return 'ProgramDepartmentLink(programId: $programId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$ProgramDepartmentLinkCopyWith<$Res> implements $ProgramDepartmentLinkCopyWith<$Res> {
  factory _$ProgramDepartmentLinkCopyWith(_ProgramDepartmentLink value, $Res Function(_ProgramDepartmentLink) _then) = __$ProgramDepartmentLinkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class __$ProgramDepartmentLinkCopyWithImpl<$Res>
    implements _$ProgramDepartmentLinkCopyWith<$Res> {
  __$ProgramDepartmentLinkCopyWithImpl(this._self, this._then);

  final _ProgramDepartmentLink _self;
  final $Res Function(_ProgramDepartmentLink) _then;

/// Create a copy of ProgramDepartmentLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? departmentId = null,}) {
  return _then(_ProgramDepartmentLink(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
