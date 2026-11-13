// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_rename_project_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableRenameProjectCommand {

 TableRenameProjectCommandKind get kind; String get id; String get name;
/// Create a copy of TableRenameProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableRenameProjectCommandCopyWith<TableRenameProjectCommand> get copyWith => _$TableRenameProjectCommandCopyWithImpl<TableRenameProjectCommand>(this as TableRenameProjectCommand, _$identity);

  /// Serializes this TableRenameProjectCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableRenameProjectCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableRenameProjectCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableRenameProjectCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as TableRenameProjectCommand;
  return 'TableRenameProjectCommand(kind: ${_this.kind}, id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TableRenameProjectCommandCopyWith<$Res>  {
  factory $TableRenameProjectCommandCopyWith(TableRenameProjectCommand value, $Res Function(TableRenameProjectCommand) _then) = _$TableRenameProjectCommandCopyWithImpl;
@useResult
$Res call({
 TableRenameProjectCommandKind kind, String id, String name
});




}
/// @nodoc
class _$TableRenameProjectCommandCopyWithImpl<$Res>
    implements $TableRenameProjectCommandCopyWith<$Res> {
  _$TableRenameProjectCommandCopyWithImpl(this._self, this._then);

  final TableRenameProjectCommand _self;
  final $Res Function(TableRenameProjectCommand) _then;

/// Create a copy of TableRenameProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? name = null,}) {
  return _then(TableRenameProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableRenameProjectCommand].
extension TableRenameProjectCommandPatterns on TableRenameProjectCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableRenameProjectCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableRenameProjectCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableRenameProjectCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableRenameProjectCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableRenameProjectCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableRenameProjectCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableRenameProjectCommandKind kind,  String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableRenameProjectCommand() when $default != null:
return $default(_that.kind,_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableRenameProjectCommandKind kind,  String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _TableRenameProjectCommand():
return $default(_that.kind,_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableRenameProjectCommandKind kind,  String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TableRenameProjectCommand() when $default != null:
return $default(_that.kind,_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableRenameProjectCommand implements TableRenameProjectCommand {
  const _TableRenameProjectCommand({required this.kind, required this.id, required this.name});
  factory _TableRenameProjectCommand.fromJson(Map<String, dynamic> json) => _$TableRenameProjectCommandFromJson(json);

@override final  TableRenameProjectCommandKind kind;
@override final  String id;
@override final  String name;

/// Create a copy of TableRenameProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableRenameProjectCommandCopyWith<_TableRenameProjectCommand> get copyWith => __$TableRenameProjectCommandCopyWithImpl<_TableRenameProjectCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableRenameProjectCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableRenameProjectCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,name);
}

@override
String toString() {
    return 'TableRenameProjectCommand(kind: $kind, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TableRenameProjectCommandCopyWith<$Res> implements $TableRenameProjectCommandCopyWith<$Res> {
  factory _$TableRenameProjectCommandCopyWith(_TableRenameProjectCommand value, $Res Function(_TableRenameProjectCommand) _then) = __$TableRenameProjectCommandCopyWithImpl;
@override @useResult
$Res call({
 TableRenameProjectCommandKind kind, String id, String name
});




}
/// @nodoc
class __$TableRenameProjectCommandCopyWithImpl<$Res>
    implements _$TableRenameProjectCommandCopyWith<$Res> {
  __$TableRenameProjectCommandCopyWithImpl(this._self, this._then);

  final _TableRenameProjectCommand _self;
  final $Res Function(_TableRenameProjectCommand) _then;

/// Create a copy of TableRenameProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? name = null,}) {
  return _then(_TableRenameProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
