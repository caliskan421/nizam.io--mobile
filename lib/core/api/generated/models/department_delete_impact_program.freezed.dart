// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_delete_impact_program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentDeleteImpactProgram {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String? get programName;/// Departmanın o programdaki adı; bağ yoksa null.
@JsonKey(name: 'department_name') String? get departmentName;/// Departman bu programa hâlâ bağlı mı.
 bool get linked;@JsonKey(name: 'active_items') int get activeItems;@JsonKey(name: 'completed_items') int get completedItems;@JsonKey(name: 'deleted_items') int get deletedItems;@JsonKey(name: 'deleted_with_department') int get deletedWithDepartment;
/// Create a copy of DepartmentDeleteImpactProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentDeleteImpactProgramCopyWith<DepartmentDeleteImpactProgram> get copyWith => _$DepartmentDeleteImpactProgramCopyWithImpl<DepartmentDeleteImpactProgram>(this as DepartmentDeleteImpactProgram, _$identity);

  /// Serializes this DepartmentDeleteImpactProgram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentDeleteImpactProgram;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentDeleteImpactProgram&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.linked, _this.linked) || other.linked == _this.linked)&&(identical(other.activeItems, _this.activeItems) || other.activeItems == _this.activeItems)&&(identical(other.completedItems, _this.completedItems) || other.completedItems == _this.completedItems)&&(identical(other.deletedItems, _this.deletedItems) || other.deletedItems == _this.deletedItems)&&(identical(other.deletedWithDepartment, _this.deletedWithDepartment) || other.deletedWithDepartment == _this.deletedWithDepartment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentDeleteImpactProgram;
  return Object.hash(runtimeType,_this.programId,_this.programName,_this.departmentName,_this.linked,_this.activeItems,_this.completedItems,_this.deletedItems,_this.deletedWithDepartment);
}

@override
String toString() {
  final _this = this as DepartmentDeleteImpactProgram;
  return 'DepartmentDeleteImpactProgram(programId: ${_this.programId}, programName: ${_this.programName}, departmentName: ${_this.departmentName}, linked: ${_this.linked}, activeItems: ${_this.activeItems}, completedItems: ${_this.completedItems}, deletedItems: ${_this.deletedItems}, deletedWithDepartment: ${_this.deletedWithDepartment})';
}


}

/// @nodoc
abstract mixin class $DepartmentDeleteImpactProgramCopyWith<$Res>  {
  factory $DepartmentDeleteImpactProgramCopyWith(DepartmentDeleteImpactProgram value, $Res Function(DepartmentDeleteImpactProgram) _then) = _$DepartmentDeleteImpactProgramCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String? programName,@JsonKey(name: 'department_name') String? departmentName, bool linked,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems,@JsonKey(name: 'deleted_items') int deletedItems,@JsonKey(name: 'deleted_with_department') int deletedWithDepartment
});




}
/// @nodoc
class _$DepartmentDeleteImpactProgramCopyWithImpl<$Res>
    implements $DepartmentDeleteImpactProgramCopyWith<$Res> {
  _$DepartmentDeleteImpactProgramCopyWithImpl(this._self, this._then);

  final DepartmentDeleteImpactProgram _self;
  final $Res Function(DepartmentDeleteImpactProgram) _then;

/// Create a copy of DepartmentDeleteImpactProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = freezed,Object? departmentName = freezed,Object? linked = null,Object? activeItems = null,Object? completedItems = null,Object? deletedItems = null,Object? deletedWithDepartment = null,}) {
  return _then(DepartmentDeleteImpactProgram(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,linked: null == linked ? _self.linked : linked // ignore: cast_nullable_to_non_nullable
as bool,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,deletedItems: null == deletedItems ? _self.deletedItems : deletedItems // ignore: cast_nullable_to_non_nullable
as int,deletedWithDepartment: null == deletedWithDepartment ? _self.deletedWithDepartment : deletedWithDepartment // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentDeleteImpactProgram].
extension DepartmentDeleteImpactProgramPatterns on DepartmentDeleteImpactProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentDeleteImpactProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentDeleteImpactProgram value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentDeleteImpactProgram value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'department_name')  String? departmentName,  bool linked, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram() when $default != null:
return $default(_that.programId,_that.programName,_that.departmentName,_that.linked,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'department_name')  String? departmentName,  bool linked, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment)  $default,) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram():
return $default(_that.programId,_that.programName,_that.departmentName,_that.linked,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'department_name')  String? departmentName,  bool linked, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpactProgram() when $default != null:
return $default(_that.programId,_that.programName,_that.departmentName,_that.linked,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentDeleteImpactProgram implements DepartmentDeleteImpactProgram {
  const _DepartmentDeleteImpactProgram({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, @JsonKey(name: 'department_name') required this.departmentName, required this.linked, @JsonKey(name: 'active_items') required this.activeItems, @JsonKey(name: 'completed_items') required this.completedItems, @JsonKey(name: 'deleted_items') required this.deletedItems, @JsonKey(name: 'deleted_with_department') required this.deletedWithDepartment});
  factory _DepartmentDeleteImpactProgram.fromJson(Map<String, dynamic> json) => _$DepartmentDeleteImpactProgramFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String? programName;
/// Departmanın o programdaki adı; bağ yoksa null.
@override@JsonKey(name: 'department_name') final  String? departmentName;
/// Departman bu programa hâlâ bağlı mı.
@override final  bool linked;
@override@JsonKey(name: 'active_items') final  int activeItems;
@override@JsonKey(name: 'completed_items') final  int completedItems;
@override@JsonKey(name: 'deleted_items') final  int deletedItems;
@override@JsonKey(name: 'deleted_with_department') final  int deletedWithDepartment;

/// Create a copy of DepartmentDeleteImpactProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentDeleteImpactProgramCopyWith<_DepartmentDeleteImpactProgram> get copyWith => __$DepartmentDeleteImpactProgramCopyWithImpl<_DepartmentDeleteImpactProgram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentDeleteImpactProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentDeleteImpactProgram&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.linked, linked) || other.linked == linked)&&(identical(other.activeItems, activeItems) || other.activeItems == activeItems)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.deletedItems, deletedItems) || other.deletedItems == deletedItems)&&(identical(other.deletedWithDepartment, deletedWithDepartment) || other.deletedWithDepartment == deletedWithDepartment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,departmentName,linked,activeItems,completedItems,deletedItems,deletedWithDepartment);
}

@override
String toString() {
    return 'DepartmentDeleteImpactProgram(programId: $programId, programName: $programName, departmentName: $departmentName, linked: $linked, activeItems: $activeItems, completedItems: $completedItems, deletedItems: $deletedItems, deletedWithDepartment: $deletedWithDepartment)';
}


}

/// @nodoc
abstract mixin class _$DepartmentDeleteImpactProgramCopyWith<$Res> implements $DepartmentDeleteImpactProgramCopyWith<$Res> {
  factory _$DepartmentDeleteImpactProgramCopyWith(_DepartmentDeleteImpactProgram value, $Res Function(_DepartmentDeleteImpactProgram) _then) = __$DepartmentDeleteImpactProgramCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String? programName,@JsonKey(name: 'department_name') String? departmentName, bool linked,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems,@JsonKey(name: 'deleted_items') int deletedItems,@JsonKey(name: 'deleted_with_department') int deletedWithDepartment
});




}
/// @nodoc
class __$DepartmentDeleteImpactProgramCopyWithImpl<$Res>
    implements _$DepartmentDeleteImpactProgramCopyWith<$Res> {
  __$DepartmentDeleteImpactProgramCopyWithImpl(this._self, this._then);

  final _DepartmentDeleteImpactProgram _self;
  final $Res Function(_DepartmentDeleteImpactProgram) _then;

/// Create a copy of DepartmentDeleteImpactProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = freezed,Object? departmentName = freezed,Object? linked = null,Object? activeItems = null,Object? completedItems = null,Object? deletedItems = null,Object? deletedWithDepartment = null,}) {
  return _then(_DepartmentDeleteImpactProgram(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,linked: null == linked ? _self.linked : linked // ignore: cast_nullable_to_non_nullable
as bool,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,deletedItems: null == deletedItems ? _self.deletedItems : deletedItems // ignore: cast_nullable_to_non_nullable
as int,deletedWithDepartment: null == deletedWithDepartment ? _self.deletedWithDepartment : deletedWithDepartment // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
