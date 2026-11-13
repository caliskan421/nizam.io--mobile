// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_delete_project_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableDeleteProjectCommand {

 TableDeleteProjectCommandKind get kind; String get id;
/// Create a copy of TableDeleteProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDeleteProjectCommandCopyWith<TableDeleteProjectCommand> get copyWith => _$TableDeleteProjectCommandCopyWithImpl<TableDeleteProjectCommand>(this as TableDeleteProjectCommand, _$identity);

  /// Serializes this TableDeleteProjectCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableDeleteProjectCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDeleteProjectCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableDeleteProjectCommand;
  return Object.hash(runtimeType,_this.kind,_this.id);
}

@override
String toString() {
  final _this = this as TableDeleteProjectCommand;
  return 'TableDeleteProjectCommand(kind: ${_this.kind}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $TableDeleteProjectCommandCopyWith<$Res>  {
  factory $TableDeleteProjectCommandCopyWith(TableDeleteProjectCommand value, $Res Function(TableDeleteProjectCommand) _then) = _$TableDeleteProjectCommandCopyWithImpl;
@useResult
$Res call({
 TableDeleteProjectCommandKind kind, String id
});




}
/// @nodoc
class _$TableDeleteProjectCommandCopyWithImpl<$Res>
    implements $TableDeleteProjectCommandCopyWith<$Res> {
  _$TableDeleteProjectCommandCopyWithImpl(this._self, this._then);

  final TableDeleteProjectCommand _self;
  final $Res Function(TableDeleteProjectCommand) _then;

/// Create a copy of TableDeleteProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableDeleteProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableDeleteProjectCommand].
extension TableDeleteProjectCommandPatterns on TableDeleteProjectCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDeleteProjectCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDeleteProjectCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDeleteProjectCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableDeleteProjectCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDeleteProjectCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableDeleteProjectCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableDeleteProjectCommandKind kind,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDeleteProjectCommand() when $default != null:
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableDeleteProjectCommandKind kind,  String id)  $default,) {final _that = this;
switch (_that) {
case _TableDeleteProjectCommand():
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableDeleteProjectCommandKind kind,  String id)?  $default,) {final _that = this;
switch (_that) {
case _TableDeleteProjectCommand() when $default != null:
return $default(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableDeleteProjectCommand implements TableDeleteProjectCommand {
  const _TableDeleteProjectCommand({required this.kind, required this.id});
  factory _TableDeleteProjectCommand.fromJson(Map<String, dynamic> json) => _$TableDeleteProjectCommandFromJson(json);

@override final  TableDeleteProjectCommandKind kind;
@override final  String id;

/// Create a copy of TableDeleteProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDeleteProjectCommandCopyWith<_TableDeleteProjectCommand> get copyWith => __$TableDeleteProjectCommandCopyWithImpl<_TableDeleteProjectCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDeleteProjectCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDeleteProjectCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableDeleteProjectCommand(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class _$TableDeleteProjectCommandCopyWith<$Res> implements $TableDeleteProjectCommandCopyWith<$Res> {
  factory _$TableDeleteProjectCommandCopyWith(_TableDeleteProjectCommand value, $Res Function(_TableDeleteProjectCommand) _then) = __$TableDeleteProjectCommandCopyWithImpl;
@override @useResult
$Res call({
 TableDeleteProjectCommandKind kind, String id
});




}
/// @nodoc
class __$TableDeleteProjectCommandCopyWithImpl<$Res>
    implements _$TableDeleteProjectCommandCopyWith<$Res> {
  __$TableDeleteProjectCommandCopyWithImpl(this._self, this._then);

  final _TableDeleteProjectCommand _self;
  final $Res Function(_TableDeleteProjectCommand) _then;

/// Create a copy of TableDeleteProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_TableDeleteProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
