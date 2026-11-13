// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_create_project_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCreateProjectCommand {

 TableCreateProjectCommandKind get kind; String get name;
/// Create a copy of TableCreateProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCreateProjectCommandCopyWith<TableCreateProjectCommand> get copyWith => _$TableCreateProjectCommandCopyWithImpl<TableCreateProjectCommand>(this as TableCreateProjectCommand, _$identity);

  /// Serializes this TableCreateProjectCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCreateProjectCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCreateProjectCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCreateProjectCommand;
  return Object.hash(runtimeType,_this.kind,_this.name);
}

@override
String toString() {
  final _this = this as TableCreateProjectCommand;
  return 'TableCreateProjectCommand(kind: ${_this.kind}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TableCreateProjectCommandCopyWith<$Res>  {
  factory $TableCreateProjectCommandCopyWith(TableCreateProjectCommand value, $Res Function(TableCreateProjectCommand) _then) = _$TableCreateProjectCommandCopyWithImpl;
@useResult
$Res call({
 TableCreateProjectCommandKind kind, String name
});




}
/// @nodoc
class _$TableCreateProjectCommandCopyWithImpl<$Res>
    implements $TableCreateProjectCommandCopyWith<$Res> {
  _$TableCreateProjectCommandCopyWithImpl(this._self, this._then);

  final TableCreateProjectCommand _self;
  final $Res Function(TableCreateProjectCommand) _then;

/// Create a copy of TableCreateProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,}) {
  return _then(TableCreateProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableCreateProjectCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableCreateProjectCommand].
extension TableCreateProjectCommandPatterns on TableCreateProjectCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCreateProjectCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCreateProjectCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCreateProjectCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableCreateProjectCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCreateProjectCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableCreateProjectCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableCreateProjectCommandKind kind,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCreateProjectCommand() when $default != null:
return $default(_that.kind,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableCreateProjectCommandKind kind,  String name)  $default,) {final _that = this;
switch (_that) {
case _TableCreateProjectCommand():
return $default(_that.kind,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableCreateProjectCommandKind kind,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TableCreateProjectCommand() when $default != null:
return $default(_that.kind,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCreateProjectCommand implements TableCreateProjectCommand {
  const _TableCreateProjectCommand({required this.kind, required this.name});
  factory _TableCreateProjectCommand.fromJson(Map<String, dynamic> json) => _$TableCreateProjectCommandFromJson(json);

@override final  TableCreateProjectCommandKind kind;
@override final  String name;

/// Create a copy of TableCreateProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCreateProjectCommandCopyWith<_TableCreateProjectCommand> get copyWith => __$TableCreateProjectCommandCopyWithImpl<_TableCreateProjectCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCreateProjectCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCreateProjectCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name);
}

@override
String toString() {
    return 'TableCreateProjectCommand(kind: $kind, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TableCreateProjectCommandCopyWith<$Res> implements $TableCreateProjectCommandCopyWith<$Res> {
  factory _$TableCreateProjectCommandCopyWith(_TableCreateProjectCommand value, $Res Function(_TableCreateProjectCommand) _then) = __$TableCreateProjectCommandCopyWithImpl;
@override @useResult
$Res call({
 TableCreateProjectCommandKind kind, String name
});




}
/// @nodoc
class __$TableCreateProjectCommandCopyWithImpl<$Res>
    implements _$TableCreateProjectCommandCopyWith<$Res> {
  __$TableCreateProjectCommandCopyWithImpl(this._self, this._then);

  final _TableCreateProjectCommand _self;
  final $Res Function(_TableCreateProjectCommand) _then;

/// Create a copy of TableCreateProjectCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,}) {
  return _then(_TableCreateProjectCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableCreateProjectCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
