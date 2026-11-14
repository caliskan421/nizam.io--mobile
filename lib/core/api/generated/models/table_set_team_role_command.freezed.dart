// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_set_team_role_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSetTeamRoleCommand {

 TableSetTeamRoleCommandKind get kind; TableSetTeamRoleCommandRole get role;
/// Create a copy of TableSetTeamRoleCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSetTeamRoleCommandCopyWith<TableSetTeamRoleCommand> get copyWith => _$TableSetTeamRoleCommandCopyWithImpl<TableSetTeamRoleCommand>(this as TableSetTeamRoleCommand, _$identity);

  /// Serializes this TableSetTeamRoleCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSetTeamRoleCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSetTeamRoleCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSetTeamRoleCommand;
  return Object.hash(runtimeType,_this.kind,_this.role);
}

@override
String toString() {
  final _this = this as TableSetTeamRoleCommand;
  return 'TableSetTeamRoleCommand(kind: ${_this.kind}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TableSetTeamRoleCommandCopyWith<$Res>  {
  factory $TableSetTeamRoleCommandCopyWith(TableSetTeamRoleCommand value, $Res Function(TableSetTeamRoleCommand) _then) = _$TableSetTeamRoleCommandCopyWithImpl;
@useResult
$Res call({
 TableSetTeamRoleCommandKind kind, TableSetTeamRoleCommandRole role
});




}
/// @nodoc
class _$TableSetTeamRoleCommandCopyWithImpl<$Res>
    implements $TableSetTeamRoleCommandCopyWith<$Res> {
  _$TableSetTeamRoleCommandCopyWithImpl(this._self, this._then);

  final TableSetTeamRoleCommand _self;
  final $Res Function(TableSetTeamRoleCommand) _then;

/// Create a copy of TableSetTeamRoleCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? role = null,}) {
  return _then(TableSetTeamRoleCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandKind,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandRole,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSetTeamRoleCommand].
extension TableSetTeamRoleCommandPatterns on TableSetTeamRoleCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSetTeamRoleCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSetTeamRoleCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSetTeamRoleCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand() when $default != null:
return $default(_that.kind,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)  $default,) {final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand():
return $default(_that.kind,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableSetTeamRoleCommandKind kind,  TableSetTeamRoleCommandRole role)?  $default,) {final _that = this;
switch (_that) {
case _TableSetTeamRoleCommand() when $default != null:
return $default(_that.kind,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSetTeamRoleCommand implements TableSetTeamRoleCommand {
  const _TableSetTeamRoleCommand({required this.kind, required this.role});
  factory _TableSetTeamRoleCommand.fromJson(Map<String, dynamic> json) => _$TableSetTeamRoleCommandFromJson(json);

@override final  TableSetTeamRoleCommandKind kind;
@override final  TableSetTeamRoleCommandRole role;

/// Create a copy of TableSetTeamRoleCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSetTeamRoleCommandCopyWith<_TableSetTeamRoleCommand> get copyWith => __$TableSetTeamRoleCommandCopyWithImpl<_TableSetTeamRoleCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSetTeamRoleCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSetTeamRoleCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,role);
}

@override
String toString() {
    return 'TableSetTeamRoleCommand(kind: $kind, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TableSetTeamRoleCommandCopyWith<$Res> implements $TableSetTeamRoleCommandCopyWith<$Res> {
  factory _$TableSetTeamRoleCommandCopyWith(_TableSetTeamRoleCommand value, $Res Function(_TableSetTeamRoleCommand) _then) = __$TableSetTeamRoleCommandCopyWithImpl;
@override @useResult
$Res call({
 TableSetTeamRoleCommandKind kind, TableSetTeamRoleCommandRole role
});




}
/// @nodoc
class __$TableSetTeamRoleCommandCopyWithImpl<$Res>
    implements _$TableSetTeamRoleCommandCopyWith<$Res> {
  __$TableSetTeamRoleCommandCopyWithImpl(this._self, this._then);

  final _TableSetTeamRoleCommand _self;
  final $Res Function(_TableSetTeamRoleCommand) _then;

/// Create a copy of TableSetTeamRoleCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? role = null,}) {
  return _then(_TableSetTeamRoleCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandKind,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableSetTeamRoleCommandRole,
  ));
}


}

// dart format on
