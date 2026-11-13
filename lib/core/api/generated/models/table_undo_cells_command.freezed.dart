// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_undo_cells_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableUndoCellsCommand {

 TableUndoCellsCommandKind get kind; int get sequence;
/// Create a copy of TableUndoCellsCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableUndoCellsCommandCopyWith<TableUndoCellsCommand> get copyWith => _$TableUndoCellsCommandCopyWithImpl<TableUndoCellsCommand>(this as TableUndoCellsCommand, _$identity);

  /// Serializes this TableUndoCellsCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableUndoCellsCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableUndoCellsCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableUndoCellsCommand;
  return Object.hash(runtimeType,_this.kind,_this.sequence);
}

@override
String toString() {
  final _this = this as TableUndoCellsCommand;
  return 'TableUndoCellsCommand(kind: ${_this.kind}, sequence: ${_this.sequence})';
}


}

/// @nodoc
abstract mixin class $TableUndoCellsCommandCopyWith<$Res>  {
  factory $TableUndoCellsCommandCopyWith(TableUndoCellsCommand value, $Res Function(TableUndoCellsCommand) _then) = _$TableUndoCellsCommandCopyWithImpl;
@useResult
$Res call({
 TableUndoCellsCommandKind kind, int sequence
});




}
/// @nodoc
class _$TableUndoCellsCommandCopyWithImpl<$Res>
    implements $TableUndoCellsCommandCopyWith<$Res> {
  _$TableUndoCellsCommandCopyWithImpl(this._self, this._then);

  final TableUndoCellsCommand _self;
  final $Res Function(TableUndoCellsCommand) _then;

/// Create a copy of TableUndoCellsCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? sequence = null,}) {
  return _then(TableUndoCellsCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableUndoCellsCommandKind,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableUndoCellsCommand].
extension TableUndoCellsCommandPatterns on TableUndoCellsCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableUndoCellsCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableUndoCellsCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableUndoCellsCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableUndoCellsCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableUndoCellsCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableUndoCellsCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableUndoCellsCommandKind kind,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableUndoCellsCommand() when $default != null:
return $default(_that.kind,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableUndoCellsCommandKind kind,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _TableUndoCellsCommand():
return $default(_that.kind,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableUndoCellsCommandKind kind,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _TableUndoCellsCommand() when $default != null:
return $default(_that.kind,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableUndoCellsCommand implements TableUndoCellsCommand {
  const _TableUndoCellsCommand({required this.kind, required this.sequence});
  factory _TableUndoCellsCommand.fromJson(Map<String, dynamic> json) => _$TableUndoCellsCommandFromJson(json);

@override final  TableUndoCellsCommandKind kind;
@override final  int sequence;

/// Create a copy of TableUndoCellsCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableUndoCellsCommandCopyWith<_TableUndoCellsCommand> get copyWith => __$TableUndoCellsCommandCopyWithImpl<_TableUndoCellsCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableUndoCellsCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableUndoCellsCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,sequence);
}

@override
String toString() {
    return 'TableUndoCellsCommand(kind: $kind, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$TableUndoCellsCommandCopyWith<$Res> implements $TableUndoCellsCommandCopyWith<$Res> {
  factory _$TableUndoCellsCommandCopyWith(_TableUndoCellsCommand value, $Res Function(_TableUndoCellsCommand) _then) = __$TableUndoCellsCommandCopyWithImpl;
@override @useResult
$Res call({
 TableUndoCellsCommandKind kind, int sequence
});




}
/// @nodoc
class __$TableUndoCellsCommandCopyWithImpl<$Res>
    implements _$TableUndoCellsCommandCopyWith<$Res> {
  __$TableUndoCellsCommandCopyWithImpl(this._self, this._then);

  final _TableUndoCellsCommand _self;
  final $Res Function(_TableUndoCellsCommand) _then;

/// Create a copy of TableUndoCellsCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? sequence = null,}) {
  return _then(_TableUndoCellsCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableUndoCellsCommandKind,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
