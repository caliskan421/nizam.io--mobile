// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_delete_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableDeleteCommand {

 TableDeleteCommandKind get kind;
/// Create a copy of TableDeleteCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDeleteCommandCopyWith<TableDeleteCommand> get copyWith => _$TableDeleteCommandCopyWithImpl<TableDeleteCommand>(this as TableDeleteCommand, _$identity);

  /// Serializes this TableDeleteCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableDeleteCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDeleteCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableDeleteCommand;
  return Object.hash(runtimeType,_this.kind);
}

@override
String toString() {
  final _this = this as TableDeleteCommand;
  return 'TableDeleteCommand(kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $TableDeleteCommandCopyWith<$Res>  {
  factory $TableDeleteCommandCopyWith(TableDeleteCommand value, $Res Function(TableDeleteCommand) _then) = _$TableDeleteCommandCopyWithImpl;
@useResult
$Res call({
 TableDeleteCommandKind kind
});




}
/// @nodoc
class _$TableDeleteCommandCopyWithImpl<$Res>
    implements $TableDeleteCommandCopyWith<$Res> {
  _$TableDeleteCommandCopyWithImpl(this._self, this._then);

  final TableDeleteCommand _self;
  final $Res Function(TableDeleteCommand) _then;

/// Create a copy of TableDeleteCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,}) {
  return _then(TableDeleteCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommandKind,
  ));
}

}


/// Adds pattern-matching-related methods to [TableDeleteCommand].
extension TableDeleteCommandPatterns on TableDeleteCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDeleteCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDeleteCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDeleteCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableDeleteCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDeleteCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableDeleteCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableDeleteCommandKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDeleteCommand() when $default != null:
return $default(_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableDeleteCommandKind kind)  $default,) {final _that = this;
switch (_that) {
case _TableDeleteCommand():
return $default(_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableDeleteCommandKind kind)?  $default,) {final _that = this;
switch (_that) {
case _TableDeleteCommand() when $default != null:
return $default(_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableDeleteCommand implements TableDeleteCommand {
  const _TableDeleteCommand({required this.kind});
  factory _TableDeleteCommand.fromJson(Map<String, dynamic> json) => _$TableDeleteCommandFromJson(json);

@override final  TableDeleteCommandKind kind;

/// Create a copy of TableDeleteCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDeleteCommandCopyWith<_TableDeleteCommand> get copyWith => __$TableDeleteCommandCopyWithImpl<_TableDeleteCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDeleteCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDeleteCommand&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'TableDeleteCommand(kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$TableDeleteCommandCopyWith<$Res> implements $TableDeleteCommandCopyWith<$Res> {
  factory _$TableDeleteCommandCopyWith(_TableDeleteCommand value, $Res Function(_TableDeleteCommand) _then) = __$TableDeleteCommandCopyWithImpl;
@override @useResult
$Res call({
 TableDeleteCommandKind kind
});




}
/// @nodoc
class __$TableDeleteCommandCopyWithImpl<$Res>
    implements _$TableDeleteCommandCopyWith<$Res> {
  __$TableDeleteCommandCopyWithImpl(this._self, this._then);

  final _TableDeleteCommand _self;
  final $Res Function(_TableDeleteCommand) _then;

/// Create a copy of TableDeleteCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(_TableDeleteCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommandKind,
  ));
}


}

// dart format on
