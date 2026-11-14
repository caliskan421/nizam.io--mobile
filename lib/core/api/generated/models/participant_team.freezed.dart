// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantTeam {

@JsonKey(name: 'department_id') String get departmentId;/// Departmanın programdaki adı.
@JsonKey(name: 'department_name') String get departmentName; ParticipantTeamRole get role;
/// Create a copy of ParticipantTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantTeamCopyWith<ParticipantTeam> get copyWith => _$ParticipantTeamCopyWithImpl<ParticipantTeam>(this as ParticipantTeam, _$identity);

  /// Serializes this ParticipantTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParticipantTeam;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantTeam&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParticipantTeam;
  return Object.hash(runtimeType,_this.departmentId,_this.departmentName,_this.role);
}

@override
String toString() {
  final _this = this as ParticipantTeam;
  return 'ParticipantTeam(departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $ParticipantTeamCopyWith<$Res>  {
  factory $ParticipantTeamCopyWith(ParticipantTeam value, $Res Function(ParticipantTeam) _then) = _$ParticipantTeamCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, ParticipantTeamRole role
});




}
/// @nodoc
class _$ParticipantTeamCopyWithImpl<$Res>
    implements $ParticipantTeamCopyWith<$Res> {
  _$ParticipantTeamCopyWithImpl(this._self, this._then);

  final ParticipantTeam _self;
  final $Res Function(ParticipantTeam) _then;

/// Create a copy of ParticipantTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? departmentName = null,Object? role = null,}) {
  return _then(ParticipantTeam(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ParticipantTeamRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantTeam].
extension ParticipantTeamPatterns on ParticipantTeam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantTeam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantTeam value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantTeam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantTeam value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantTeam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  ParticipantTeamRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantTeam() when $default != null:
return $default(_that.departmentId,_that.departmentName,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  ParticipantTeamRole role)  $default,) {final _that = this;
switch (_that) {
case _ParticipantTeam():
return $default(_that.departmentId,_that.departmentName,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  ParticipantTeamRole role)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantTeam() when $default != null:
return $default(_that.departmentId,_that.departmentName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantTeam implements ParticipantTeam {
  const _ParticipantTeam({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, required this.role});
  factory _ParticipantTeam.fromJson(Map<String, dynamic> json) => _$ParticipantTeamFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın programdaki adı.
@override@JsonKey(name: 'department_name') final  String departmentName;
@override final  ParticipantTeamRole role;

/// Create a copy of ParticipantTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantTeamCopyWith<_ParticipantTeam> get copyWith => __$ParticipantTeamCopyWithImpl<_ParticipantTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantTeamToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantTeam&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,departmentName,role);
}

@override
String toString() {
    return 'ParticipantTeam(departmentId: $departmentId, departmentName: $departmentName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ParticipantTeamCopyWith<$Res> implements $ParticipantTeamCopyWith<$Res> {
  factory _$ParticipantTeamCopyWith(_ParticipantTeam value, $Res Function(_ParticipantTeam) _then) = __$ParticipantTeamCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, ParticipantTeamRole role
});




}
/// @nodoc
class __$ParticipantTeamCopyWithImpl<$Res>
    implements _$ParticipantTeamCopyWith<$Res> {
  __$ParticipantTeamCopyWithImpl(this._self, this._then);

  final _ParticipantTeam _self;
  final $Res Function(_ParticipantTeam) _then;

/// Create a copy of ParticipantTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? departmentName = null,Object? role = null,}) {
  return _then(_ParticipantTeam(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ParticipantTeamRole,
  ));
}


}

// dart format on
