// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_propose_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProposeCommand {

 TableProposeCommandKind get kind;@JsonKey(name: 'target_space') TableProposeCommandTargetSpace get targetSpace;@JsonKey(name: 'target_department_id') String get targetDepartmentId;/// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
@JsonKey(name: 'target_project_id') String? get targetProjectId; TableProposeCommandRole? get role;
/// Create a copy of TableProposeCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProposeCommandCopyWith<TableProposeCommand> get copyWith => _$TableProposeCommandCopyWithImpl<TableProposeCommand>(this as TableProposeCommand, _$identity);

  /// Serializes this TableProposeCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProposeCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProposeCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetSpace, _this.targetSpace) || other.targetSpace == _this.targetSpace)&&(identical(other.targetDepartmentId, _this.targetDepartmentId) || other.targetDepartmentId == _this.targetDepartmentId)&&(identical(other.targetProjectId, _this.targetProjectId) || other.targetProjectId == _this.targetProjectId)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProposeCommand;
  return Object.hash(runtimeType,_this.kind,_this.targetSpace,_this.targetDepartmentId,_this.targetProjectId,_this.role);
}

@override
String toString() {
  final _this = this as TableProposeCommand;
  return 'TableProposeCommand(kind: ${_this.kind}, targetSpace: ${_this.targetSpace}, targetDepartmentId: ${_this.targetDepartmentId}, targetProjectId: ${_this.targetProjectId}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TableProposeCommandCopyWith<$Res>  {
  factory $TableProposeCommandCopyWith(TableProposeCommand value, $Res Function(TableProposeCommand) _then) = _$TableProposeCommandCopyWithImpl;
@useResult
$Res call({
 TableProposeCommandKind kind,@JsonKey(name: 'target_space') TableProposeCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId, TableProposeCommandRole? role
});




}
/// @nodoc
class _$TableProposeCommandCopyWithImpl<$Res>
    implements $TableProposeCommandCopyWith<$Res> {
  _$TableProposeCommandCopyWithImpl(this._self, this._then);

  final TableProposeCommand _self;
  final $Res Function(TableProposeCommand) _then;

/// Create a copy of TableProposeCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = null,Object? targetProjectId = freezed,Object? role = freezed,}) {
  return _then(TableProposeCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposeCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableProposeCommandTargetSpace,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableProposeCommandRole?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProposeCommand].
extension TableProposeCommandPatterns on TableProposeCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProposeCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProposeCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProposeCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableProposeCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProposeCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableProposeCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProposeCommand() when $default != null:
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)  $default,) {final _that = this;
switch (_that) {
case _TableProposeCommand():
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableProposeCommandKind kind, @JsonKey(name: 'target_space')  TableProposeCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId,  TableProposeCommandRole? role)?  $default,) {final _that = this;
switch (_that) {
case _TableProposeCommand() when $default != null:
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProposeCommand implements TableProposeCommand {
  const _TableProposeCommand({required this.kind, @JsonKey(name: 'target_space') required this.targetSpace, @JsonKey(name: 'target_department_id') required this.targetDepartmentId, @JsonKey(name: 'target_project_id') this.targetProjectId, this.role});
  factory _TableProposeCommand.fromJson(Map<String, dynamic> json) => _$TableProposeCommandFromJson(json);

@override final  TableProposeCommandKind kind;
@override@JsonKey(name: 'target_space') final  TableProposeCommandTargetSpace targetSpace;
@override@JsonKey(name: 'target_department_id') final  String targetDepartmentId;
/// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
@override@JsonKey(name: 'target_project_id') final  String? targetProjectId;
@override final  TableProposeCommandRole? role;

/// Create a copy of TableProposeCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProposeCommandCopyWith<_TableProposeCommand> get copyWith => __$TableProposeCommandCopyWithImpl<_TableProposeCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProposeCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProposeCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetSpace, targetSpace) || other.targetSpace == targetSpace)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetSpace,targetDepartmentId,targetProjectId,role);
}

@override
String toString() {
    return 'TableProposeCommand(kind: $kind, targetSpace: $targetSpace, targetDepartmentId: $targetDepartmentId, targetProjectId: $targetProjectId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TableProposeCommandCopyWith<$Res> implements $TableProposeCommandCopyWith<$Res> {
  factory _$TableProposeCommandCopyWith(_TableProposeCommand value, $Res Function(_TableProposeCommand) _then) = __$TableProposeCommandCopyWithImpl;
@override @useResult
$Res call({
 TableProposeCommandKind kind,@JsonKey(name: 'target_space') TableProposeCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId, TableProposeCommandRole? role
});




}
/// @nodoc
class __$TableProposeCommandCopyWithImpl<$Res>
    implements _$TableProposeCommandCopyWith<$Res> {
  __$TableProposeCommandCopyWithImpl(this._self, this._then);

  final _TableProposeCommand _self;
  final $Res Function(_TableProposeCommand) _then;

/// Create a copy of TableProposeCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = null,Object? targetProjectId = freezed,Object? role = freezed,}) {
  return _then(_TableProposeCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposeCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableProposeCommandTargetSpace,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableProposeCommandRole?,
  ));
}


}

// dart format on
