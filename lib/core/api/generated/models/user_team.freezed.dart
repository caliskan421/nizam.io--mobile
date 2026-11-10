// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserTeam {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName;@JsonKey(name: 'department_id') String get departmentId;/// Departmanın bu programdaki adı.
@JsonKey(name: 'display_name') String get displayName; UserTeamRole get role;
/// Create a copy of UserTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTeamCopyWith<UserTeam> get copyWith => _$UserTeamCopyWithImpl<UserTeam>(this as UserTeam, _$identity);

  /// Serializes this UserTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserTeam;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTeam&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserTeam;
  return Object.hash(runtimeType,_this.programId,_this.programName,_this.departmentId,_this.displayName,_this.role);
}

@override
String toString() {
  final _this = this as UserTeam;
  return 'UserTeam(programId: ${_this.programId}, programName: ${_this.programName}, departmentId: ${_this.departmentId}, displayName: ${_this.displayName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $UserTeamCopyWith<$Res>  {
  factory $UserTeamCopyWith(UserTeam value, $Res Function(UserTeam) _then) = _$UserTeamCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, UserTeamRole role
});




}
/// @nodoc
class _$UserTeamCopyWithImpl<$Res>
    implements $UserTeamCopyWith<$Res> {
  _$UserTeamCopyWithImpl(this._self, this._then);

  final UserTeam _self;
  final $Res Function(UserTeam) _then;

/// Create a copy of UserTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? departmentId = null,Object? displayName = null,Object? role = null,}) {
  return _then(UserTeam(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserTeamRole,
  ));
}

}


/// Adds pattern-matching-related methods to [UserTeam].
extension UserTeamPatterns on UserTeam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserTeam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserTeam value)  $default,){
final _that = this;
switch (_that) {
case _UserTeam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserTeam value)?  $default,){
final _that = this;
switch (_that) {
case _UserTeam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  UserTeamRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserTeam() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  UserTeamRole role)  $default,) {final _that = this;
switch (_that) {
case _UserTeam():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String displayName,  UserTeamRole role)?  $default,) {final _that = this;
switch (_that) {
case _UserTeam() when $default != null:
return $default(_that.programId,_that.programName,_that.departmentId,_that.displayName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserTeam implements UserTeam {
  const _UserTeam({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'display_name') required this.displayName, required this.role});
  factory _UserTeam.fromJson(Map<String, dynamic> json) => _$UserTeamFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın bu programdaki adı.
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  UserTeamRole role;

/// Create a copy of UserTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTeamCopyWith<_UserTeam> get copyWith => __$UserTeamCopyWithImpl<_UserTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserTeamToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTeam&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,departmentId,displayName,role);
}

@override
String toString() {
    return 'UserTeam(programId: $programId, programName: $programName, departmentId: $departmentId, displayName: $displayName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$UserTeamCopyWith<$Res> implements $UserTeamCopyWith<$Res> {
  factory _$UserTeamCopyWith(_UserTeam value, $Res Function(_UserTeam) _then) = __$UserTeamCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String displayName, UserTeamRole role
});




}
/// @nodoc
class __$UserTeamCopyWithImpl<$Res>
    implements _$UserTeamCopyWith<$Res> {
  __$UserTeamCopyWithImpl(this._self, this._then);

  final _UserTeam _self;
  final $Res Function(_UserTeam) _then;

/// Create a copy of UserTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? departmentId = null,Object? displayName = null,Object? role = null,}) {
  return _then(_UserTeam(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserTeamRole,
  ));
}


}

// dart format on
