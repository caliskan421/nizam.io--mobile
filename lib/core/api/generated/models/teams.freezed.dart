// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teams.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Teams {

@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'department_name') String get departmentName; Role get role;
/// Create a copy of Teams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamsCopyWith<Teams> get copyWith => _$TeamsCopyWithImpl<Teams>(this as Teams, _$identity);

  /// Serializes this Teams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Teams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Teams&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Teams;
  return Object.hash(runtimeType,_this.departmentId,_this.departmentName,_this.role);
}

@override
String toString() {
  final _this = this as Teams;
  return 'Teams(departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TeamsCopyWith<$Res>  {
  factory $TeamsCopyWith(Teams value, $Res Function(Teams) _then) = _$TeamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, Role role
});




}
/// @nodoc
class _$TeamsCopyWithImpl<$Res>
    implements $TeamsCopyWith<$Res> {
  _$TeamsCopyWithImpl(this._self, this._then);

  final Teams _self;
  final $Res Function(Teams) _then;

/// Create a copy of Teams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? departmentName = null,Object? role = null,}) {
  return _then(Teams(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,
  ));
}

}


/// Adds pattern-matching-related methods to [Teams].
extension TeamsPatterns on Teams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Teams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Teams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Teams value)  $default,){
final _that = this;
switch (_that) {
case _Teams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Teams value)?  $default,){
final _that = this;
switch (_that) {
case _Teams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  Role role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Teams() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  Role role)  $default,) {final _that = this;
switch (_that) {
case _Teams():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String departmentName,  Role role)?  $default,) {final _that = this;
switch (_that) {
case _Teams() when $default != null:
return $default(_that.departmentId,_that.departmentName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Teams implements Teams {
  const _Teams({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, required this.role});
  factory _Teams.fromJson(Map<String, dynamic> json) => _$TeamsFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'department_name') final  String departmentName;
@override final  Role role;

/// Create a copy of Teams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamsCopyWith<_Teams> get copyWith => __$TeamsCopyWithImpl<_Teams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Teams&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,departmentName,role);
}

@override
String toString() {
    return 'Teams(departmentId: $departmentId, departmentName: $departmentName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TeamsCopyWith<$Res> implements $TeamsCopyWith<$Res> {
  factory _$TeamsCopyWith(_Teams value, $Res Function(_Teams) _then) = __$TeamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String departmentName, Role role
});




}
/// @nodoc
class __$TeamsCopyWithImpl<$Res>
    implements _$TeamsCopyWith<$Res> {
  __$TeamsCopyWithImpl(this._self, this._then);

  final _Teams _self;
  final $Res Function(_Teams) _then;

/// Create a copy of Teams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? departmentName = null,Object? role = null,}) {
  return _then(_Teams(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,
  ));
}


}

// dart format on
