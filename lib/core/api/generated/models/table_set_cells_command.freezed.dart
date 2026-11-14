// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_set_cells_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSetCellsCommand {

 TableSetCellsCommandKind get kind; List<TableCell> get cells;
/// Create a copy of TableSetCellsCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSetCellsCommandCopyWith<TableSetCellsCommand> get copyWith => _$TableSetCellsCommandCopyWithImpl<TableSetCellsCommand>(this as TableSetCellsCommand, _$identity);

  /// Serializes this TableSetCellsCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSetCellsCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSetCellsCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.cells, _this.cells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSetCellsCommand;
  return Object.hash(runtimeType,_this.kind,const DeepCollectionEquality().hash(_this.cells));
}

@override
String toString() {
  final _this = this as TableSetCellsCommand;
  return 'TableSetCellsCommand(kind: ${_this.kind}, cells: ${_this.cells})';
}


}

/// @nodoc
abstract mixin class $TableSetCellsCommandCopyWith<$Res>  {
  factory $TableSetCellsCommandCopyWith(TableSetCellsCommand value, $Res Function(TableSetCellsCommand) _then) = _$TableSetCellsCommandCopyWithImpl;
@useResult
$Res call({
 TableSetCellsCommandKind kind, List<TableCell> cells
});




}
/// @nodoc
class _$TableSetCellsCommandCopyWithImpl<$Res>
    implements $TableSetCellsCommandCopyWith<$Res> {
  _$TableSetCellsCommandCopyWithImpl(this._self, this._then);

  final TableSetCellsCommand _self;
  final $Res Function(TableSetCellsCommand) _then;

/// Create a copy of TableSetCellsCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? cells = null,}) {
  return _then(TableSetCellsCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetCellsCommandKind,cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSetCellsCommand].
extension TableSetCellsCommandPatterns on TableSetCellsCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSetCellsCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSetCellsCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSetCellsCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableSetCellsCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSetCellsCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableSetCellsCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableSetCellsCommandKind kind,  List<TableCell> cells)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSetCellsCommand() when $default != null:
return $default(_that.kind,_that.cells);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableSetCellsCommandKind kind,  List<TableCell> cells)  $default,) {final _that = this;
switch (_that) {
case _TableSetCellsCommand():
return $default(_that.kind,_that.cells);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableSetCellsCommandKind kind,  List<TableCell> cells)?  $default,) {final _that = this;
switch (_that) {
case _TableSetCellsCommand() when $default != null:
return $default(_that.kind,_that.cells);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSetCellsCommand implements TableSetCellsCommand {
  const _TableSetCellsCommand({required this.kind, required  List<TableCell> cells}): _cells = cells;
  factory _TableSetCellsCommand.fromJson(Map<String, dynamic> json) => _$TableSetCellsCommandFromJson(json);

@override final  TableSetCellsCommandKind kind;
 final  List<TableCell> _cells;
@override List<TableCell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}


/// Create a copy of TableSetCellsCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSetCellsCommandCopyWith<_TableSetCellsCommand> get copyWith => __$TableSetCellsCommandCopyWithImpl<_TableSetCellsCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSetCellsCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSetCellsCommand&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.cells, _cells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(_cells));
}

@override
String toString() {
    return 'TableSetCellsCommand(kind: $kind, cells: $cells)';
}


}

/// @nodoc
abstract mixin class _$TableSetCellsCommandCopyWith<$Res> implements $TableSetCellsCommandCopyWith<$Res> {
  factory _$TableSetCellsCommandCopyWith(_TableSetCellsCommand value, $Res Function(_TableSetCellsCommand) _then) = __$TableSetCellsCommandCopyWithImpl;
@override @useResult
$Res call({
 TableSetCellsCommandKind kind, List<TableCell> cells
});




}
/// @nodoc
class __$TableSetCellsCommandCopyWithImpl<$Res>
    implements _$TableSetCellsCommandCopyWith<$Res> {
  __$TableSetCellsCommandCopyWithImpl(this._self, this._then);

  final _TableSetCellsCommand _self;
  final $Res Function(_TableSetCellsCommand) _then;

/// Create a copy of TableSetCellsCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? cells = null,}) {
  return _then(_TableSetCellsCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetCellsCommandKind,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>,
  ));
}


}

// dart format on
