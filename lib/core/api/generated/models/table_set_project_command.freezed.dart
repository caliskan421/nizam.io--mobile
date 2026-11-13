// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_set_project_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSetProjectCommand {

 TableSetProjectCommandKind get kind;@JsonKey(name: 'project_id') String? get projectId;
/// Create a copy of TableSetProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSetProjectCommandCopyWith<TableSetProjectCommand> get copyWith => _$TableSetProjectCommandCopyWithImpl<TableSetProjectCommand>(this as TableSetProjectCommand, _$identity);

  /// Serializes this TableSetProjectCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSetProjectCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSetProjectCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSetProjectCommand;
  return Object.hash(runtimeType,_this.kind,_this.projectId);
}

@override
String toString() {
  final _this = this as TableSetProjectCommand;
  return 'TableSetProjectCommand(kind: ${_this.kind}, projectId: ${_this.projectId})';
}


}

/// @nodoc
abstract mixin class $TableSetProjectCommandCopyWith<$Res>  {
  factory $TableSetProjectCommandCopyWith(TableSetProjectCommand value, $Res Function(TableSetProjectCommand) _then) = _$TableSetProjectCommandCopyWithImpl;
@useResult
$Res call({
 TableSetProjectCommandKind kind,@JsonKey(name: 'project_id') String? projectId
});




}
/// @nodoc
class _$TableSetProjectCommandCopyWithImpl<$Res>
    implements $TableSetProjectCommandCopyWith<$Res> {
  _$TableSetProjectCommandCopyWithImpl(this._self, this._then);

  final TableSetProjectCommand _self;
  final $Res Function(TableSetProjectCommand) _then;

/// Create a copy of TableSetProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? projectId = freezed,}) {
  return _then(TableSetProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetProjectCommandKind,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSetProjectCommand].
extension TableSetProjectCommandPatterns on TableSetProjectCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSetProjectCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSetProjectCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSetProjectCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableSetProjectCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSetProjectCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableSetProjectCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSetProjectCommand() when $default != null:
return $default(_that.kind,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _TableSetProjectCommand():
return $default(_that.kind,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableSetProjectCommandKind kind, @JsonKey(name: 'project_id')  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _TableSetProjectCommand() when $default != null:
return $default(_that.kind,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSetProjectCommand implements TableSetProjectCommand {
  const _TableSetProjectCommand({required this.kind, @JsonKey(name: 'project_id') this.projectId});
  factory _TableSetProjectCommand.fromJson(Map<String, dynamic> json) => _$TableSetProjectCommandFromJson(json);

@override final  TableSetProjectCommandKind kind;
@override@JsonKey(name: 'project_id') final  String? projectId;

/// Create a copy of TableSetProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSetProjectCommandCopyWith<_TableSetProjectCommand> get copyWith => __$TableSetProjectCommandCopyWithImpl<_TableSetProjectCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSetProjectCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSetProjectCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,projectId);
}

@override
String toString() {
    return 'TableSetProjectCommand(kind: $kind, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$TableSetProjectCommandCopyWith<$Res> implements $TableSetProjectCommandCopyWith<$Res> {
  factory _$TableSetProjectCommandCopyWith(_TableSetProjectCommand value, $Res Function(_TableSetProjectCommand) _then) = __$TableSetProjectCommandCopyWithImpl;
@override @useResult
$Res call({
 TableSetProjectCommandKind kind,@JsonKey(name: 'project_id') String? projectId
});




}
/// @nodoc
class __$TableSetProjectCommandCopyWithImpl<$Res>
    implements _$TableSetProjectCommandCopyWith<$Res> {
  __$TableSetProjectCommandCopyWithImpl(this._self, this._then);

  final _TableSetProjectCommand _self;
  final $Res Function(_TableSetProjectCommand) _then;

/// Create a copy of TableSetProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? projectId = freezed,}) {
  return _then(_TableSetProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetProjectCommandKind,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
