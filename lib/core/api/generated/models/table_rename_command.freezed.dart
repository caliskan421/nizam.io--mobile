// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_rename_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableRenameCommand {

 TableRenameCommandKind get kind; String get name;
/// Create a copy of TableRenameCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableRenameCommandCopyWith<TableRenameCommand> get copyWith => _$TableRenameCommandCopyWithImpl<TableRenameCommand>(this as TableRenameCommand, _$identity);

  /// Serializes this TableRenameCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableRenameCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableRenameCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableRenameCommand;
  return Object.hash(runtimeType,_this.kind,_this.name);
}

@override
String toString() {
  final _this = this as TableRenameCommand;
  return 'TableRenameCommand(kind: ${_this.kind}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TableRenameCommandCopyWith<$Res>  {
  factory $TableRenameCommandCopyWith(TableRenameCommand value, $Res Function(TableRenameCommand) _then) = _$TableRenameCommandCopyWithImpl;
@useResult
$Res call({
 TableRenameCommandKind kind, String name
});




}
/// @nodoc
class _$TableRenameCommandCopyWithImpl<$Res>
    implements $TableRenameCommandCopyWith<$Res> {
  _$TableRenameCommandCopyWithImpl(this._self, this._then);

  final TableRenameCommand _self;
  final $Res Function(TableRenameCommand) _then;

/// Create a copy of TableRenameCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,}) {
  return _then(TableRenameCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableRenameCommand].
extension TableRenameCommandPatterns on TableRenameCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableRenameCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableRenameCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableRenameCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableRenameCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableRenameCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableRenameCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableRenameCommandKind kind,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableRenameCommand() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableRenameCommandKind kind,  String name)  $default,) {final _that = this;
switch (_that) {
case _TableRenameCommand():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableRenameCommandKind kind,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TableRenameCommand() when $default != null:
return $default(_that.kind,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableRenameCommand implements TableRenameCommand {
  const _TableRenameCommand({required this.kind, required this.name});
  factory _TableRenameCommand.fromJson(Map<String, dynamic> json) => _$TableRenameCommandFromJson(json);

@override final  TableRenameCommandKind kind;
@override final  String name;

/// Create a copy of TableRenameCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableRenameCommandCopyWith<_TableRenameCommand> get copyWith => __$TableRenameCommandCopyWithImpl<_TableRenameCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableRenameCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableRenameCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name);
}

@override
String toString() {
    return 'TableRenameCommand(kind: $kind, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TableRenameCommandCopyWith<$Res> implements $TableRenameCommandCopyWith<$Res> {
  factory _$TableRenameCommandCopyWith(_TableRenameCommand value, $Res Function(_TableRenameCommand) _then) = __$TableRenameCommandCopyWithImpl;
@override @useResult
$Res call({
 TableRenameCommandKind kind, String name
});




}
/// @nodoc
class __$TableRenameCommandCopyWithImpl<$Res>
    implements _$TableRenameCommandCopyWith<$Res> {
  __$TableRenameCommandCopyWithImpl(this._self, this._then);

  final _TableRenameCommand _self;
  final $Res Function(_TableRenameCommand) _then;

/// Create a copy of TableRenameCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,}) {
  return _then(_TableRenameCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
