// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProject {

 String get id;@JsonKey(name: 'owner_id') String get ownerId; String get name;@JsonKey(name: 'program_id') String get programId;/// Kişisel alanda boş metin.
@JsonKey(name: 'department_id') String get departmentId; TableProjectSpace get space;
/// Create a copy of TableProject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectCopyWith<TableProject> get copyWith => _$TableProjectCopyWithImpl<TableProject>(this as TableProject, _$identity);

  /// Serializes this TableProject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProject;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProject&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.space, _this.space) || other.space == _this.space));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProject;
  return Object.hash(runtimeType,_this.id,_this.ownerId,_this.name,_this.programId,_this.departmentId,_this.space);
}

@override
String toString() {
  final _this = this as TableProject;
  return 'TableProject(id: ${_this.id}, ownerId: ${_this.ownerId}, name: ${_this.name}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, space: ${_this.space})';
}


}

/// @nodoc
abstract mixin class $TableProjectCopyWith<$Res>  {
  factory $TableProjectCopyWith(TableProject value, $Res Function(TableProject) _then) = _$TableProjectCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, TableProjectSpace space
});




}
/// @nodoc
class _$TableProjectCopyWithImpl<$Res>
    implements $TableProjectCopyWith<$Res> {
  _$TableProjectCopyWithImpl(this._self, this._then);

  final TableProject _self;
  final $Res Function(TableProject) _then;

/// Create a copy of TableProject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? programId = null,Object? departmentId = null,Object? space = null,}) {
  return _then(TableProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as TableProjectSpace,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProject].
extension TableProjectPatterns on TableProject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProject value)  $default,){
final _that = this;
switch (_that) {
case _TableProject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProject value)?  $default,){
final _that = this;
switch (_that) {
case _TableProject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableProjectSpace space)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProject() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableProjectSpace space)  $default,) {final _that = this;
switch (_that) {
case _TableProject():
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableProjectSpace space)?  $default,) {final _that = this;
switch (_that) {
case _TableProject() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProject implements TableProject {
  const _TableProject({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.space});
  factory _TableProject.fromJson(Map<String, dynamic> json) => _$TableProjectFromJson(json);

@override final  String id;
@override@JsonKey(name: 'owner_id') final  String ownerId;
@override final  String name;
@override@JsonKey(name: 'program_id') final  String programId;
/// Kişisel alanda boş metin.
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  TableProjectSpace space;

/// Create a copy of TableProject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProjectCopyWith<_TableProject> get copyWith => __$TableProjectCopyWithImpl<_TableProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProject&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.space, space) || other.space == space));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,ownerId,name,programId,departmentId,space);
}

@override
String toString() {
    return 'TableProject(id: $id, ownerId: $ownerId, name: $name, programId: $programId, departmentId: $departmentId, space: $space)';
}


}

/// @nodoc
abstract mixin class _$TableProjectCopyWith<$Res> implements $TableProjectCopyWith<$Res> {
  factory _$TableProjectCopyWith(_TableProject value, $Res Function(_TableProject) _then) = __$TableProjectCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, TableProjectSpace space
});




}
/// @nodoc
class __$TableProjectCopyWithImpl<$Res>
    implements _$TableProjectCopyWith<$Res> {
  __$TableProjectCopyWithImpl(this._self, this._then);

  final _TableProject _self;
  final $Res Function(_TableProject) _then;

/// Create a copy of TableProject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? programId = null,Object? departmentId = null,Object? space = null,}) {
  return _then(_TableProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as TableProjectSpace,
  ));
}


}

// dart format on
