// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_move_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableMoveCommand {

 TableMoveCommandKind get kind;@JsonKey(name: 'target_space') TableMoveCommandTargetSpace get targetSpace;/// Yalnız `coordinatorship` hedefinde zorunlu; kişisel hedefte verilmez.
@JsonKey(name: 'target_department_id') String? get targetDepartmentId;/// Verilmezse tablo projesiz taşınır; verilmişse hedefteki silinmemiş proje (null/boş 422).
@JsonKey(name: 'target_project_id') String? get targetProjectId;
/// Create a copy of TableMoveCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableMoveCommandCopyWith<TableMoveCommand> get copyWith => _$TableMoveCommandCopyWithImpl<TableMoveCommand>(this as TableMoveCommand, _$identity);

  /// Serializes this TableMoveCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableMoveCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableMoveCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetSpace, _this.targetSpace) || other.targetSpace == _this.targetSpace)&&(identical(other.targetDepartmentId, _this.targetDepartmentId) || other.targetDepartmentId == _this.targetDepartmentId)&&(identical(other.targetProjectId, _this.targetProjectId) || other.targetProjectId == _this.targetProjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableMoveCommand;
  return Object.hash(runtimeType,_this.kind,_this.targetSpace,_this.targetDepartmentId,_this.targetProjectId);
}

@override
String toString() {
  final _this = this as TableMoveCommand;
  return 'TableMoveCommand(kind: ${_this.kind}, targetSpace: ${_this.targetSpace}, targetDepartmentId: ${_this.targetDepartmentId}, targetProjectId: ${_this.targetProjectId})';
}


}

/// @nodoc
abstract mixin class $TableMoveCommandCopyWith<$Res>  {
  factory $TableMoveCommandCopyWith(TableMoveCommand value, $Res Function(TableMoveCommand) _then) = _$TableMoveCommandCopyWithImpl;
@useResult
$Res call({
 TableMoveCommandKind kind,@JsonKey(name: 'target_space') TableMoveCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String? targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId
});




}
/// @nodoc
class _$TableMoveCommandCopyWithImpl<$Res>
    implements $TableMoveCommandCopyWith<$Res> {
  _$TableMoveCommandCopyWithImpl(this._self, this._then);

  final TableMoveCommand _self;
  final $Res Function(TableMoveCommand) _then;

/// Create a copy of TableMoveCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = freezed,Object? targetProjectId = freezed,}) {
  return _then(TableMoveCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableMoveCommandTargetSpace,targetDepartmentId: freezed == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableMoveCommand].
extension TableMoveCommandPatterns on TableMoveCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableMoveCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableMoveCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableMoveCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableMoveCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableMoveCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableMoveCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableMoveCommand() when $default != null:
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)  $default,) {final _that = this;
switch (_that) {
case _TableMoveCommand():
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableMoveCommandKind kind, @JsonKey(name: 'target_space')  TableMoveCommandTargetSpace targetSpace, @JsonKey(name: 'target_department_id')  String? targetDepartmentId, @JsonKey(name: 'target_project_id')  String? targetProjectId)?  $default,) {final _that = this;
switch (_that) {
case _TableMoveCommand() when $default != null:
return $default(_that.kind,_that.targetSpace,_that.targetDepartmentId,_that.targetProjectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableMoveCommand implements TableMoveCommand {
  const _TableMoveCommand({required this.kind, @JsonKey(name: 'target_space') required this.targetSpace, @JsonKey(name: 'target_department_id') this.targetDepartmentId, @JsonKey(name: 'target_project_id') this.targetProjectId});
  factory _TableMoveCommand.fromJson(Map<String, dynamic> json) => _$TableMoveCommandFromJson(json);

@override final  TableMoveCommandKind kind;
@override@JsonKey(name: 'target_space') final  TableMoveCommandTargetSpace targetSpace;
/// Yalnız `coordinatorship` hedefinde zorunlu; kişisel hedefte verilmez.
@override@JsonKey(name: 'target_department_id') final  String? targetDepartmentId;
/// Verilmezse tablo projesiz taşınır; verilmişse hedefteki silinmemiş proje (null/boş 422).
@override@JsonKey(name: 'target_project_id') final  String? targetProjectId;

/// Create a copy of TableMoveCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableMoveCommandCopyWith<_TableMoveCommand> get copyWith => __$TableMoveCommandCopyWithImpl<_TableMoveCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableMoveCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableMoveCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetSpace, targetSpace) || other.targetSpace == targetSpace)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetSpace,targetDepartmentId,targetProjectId);
}

@override
String toString() {
    return 'TableMoveCommand(kind: $kind, targetSpace: $targetSpace, targetDepartmentId: $targetDepartmentId, targetProjectId: $targetProjectId)';
}


}

/// @nodoc
abstract mixin class _$TableMoveCommandCopyWith<$Res> implements $TableMoveCommandCopyWith<$Res> {
  factory _$TableMoveCommandCopyWith(_TableMoveCommand value, $Res Function(_TableMoveCommand) _then) = __$TableMoveCommandCopyWithImpl;
@override @useResult
$Res call({
 TableMoveCommandKind kind,@JsonKey(name: 'target_space') TableMoveCommandTargetSpace targetSpace,@JsonKey(name: 'target_department_id') String? targetDepartmentId,@JsonKey(name: 'target_project_id') String? targetProjectId
});




}
/// @nodoc
class __$TableMoveCommandCopyWithImpl<$Res>
    implements _$TableMoveCommandCopyWith<$Res> {
  __$TableMoveCommandCopyWithImpl(this._self, this._then);

  final _TableMoveCommand _self;
  final $Res Function(_TableMoveCommand) _then;

/// Create a copy of TableMoveCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetSpace = null,Object? targetDepartmentId = freezed,Object? targetProjectId = freezed,}) {
  return _then(_TableMoveCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveCommandKind,targetSpace: null == targetSpace ? _self.targetSpace : targetSpace // ignore: cast_nullable_to_non_nullable
as TableMoveCommandTargetSpace,targetDepartmentId: freezed == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
