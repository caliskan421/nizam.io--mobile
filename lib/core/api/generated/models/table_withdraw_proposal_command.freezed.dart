// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_withdraw_proposal_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableWithdrawProposalCommand {

 TableWithdrawProposalCommandKind get kind;
/// Create a copy of TableWithdrawProposalCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableWithdrawProposalCommandCopyWith<TableWithdrawProposalCommand> get copyWith => _$TableWithdrawProposalCommandCopyWithImpl<TableWithdrawProposalCommand>(this as TableWithdrawProposalCommand, _$identity);

  /// Serializes this TableWithdrawProposalCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableWithdrawProposalCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableWithdrawProposalCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableWithdrawProposalCommand;
  return Object.hash(runtimeType,_this.kind);
}

@override
String toString() {
  final _this = this as TableWithdrawProposalCommand;
  return 'TableWithdrawProposalCommand(kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $TableWithdrawProposalCommandCopyWith<$Res>  {
  factory $TableWithdrawProposalCommandCopyWith(TableWithdrawProposalCommand value, $Res Function(TableWithdrawProposalCommand) _then) = _$TableWithdrawProposalCommandCopyWithImpl;
@useResult
$Res call({
 TableWithdrawProposalCommandKind kind
});




}
/// @nodoc
class _$TableWithdrawProposalCommandCopyWithImpl<$Res>
    implements $TableWithdrawProposalCommandCopyWith<$Res> {
  _$TableWithdrawProposalCommandCopyWithImpl(this._self, this._then);

  final TableWithdrawProposalCommand _self;
  final $Res Function(TableWithdrawProposalCommand) _then;

/// Create a copy of TableWithdrawProposalCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,}) {
  return _then(TableWithdrawProposalCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableWithdrawProposalCommandKind,
  ));
}

}


/// Adds pattern-matching-related methods to [TableWithdrawProposalCommand].
extension TableWithdrawProposalCommandPatterns on TableWithdrawProposalCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableWithdrawProposalCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableWithdrawProposalCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableWithdrawProposalCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableWithdrawProposalCommandKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableWithdrawProposalCommandKind kind)  $default,) {final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableWithdrawProposalCommandKind kind)?  $default,) {final _that = this;
switch (_that) {
case _TableWithdrawProposalCommand() when $default != null:
return $default(_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableWithdrawProposalCommand implements TableWithdrawProposalCommand {
  const _TableWithdrawProposalCommand({required this.kind});
  factory _TableWithdrawProposalCommand.fromJson(Map<String, dynamic> json) => _$TableWithdrawProposalCommandFromJson(json);

@override final  TableWithdrawProposalCommandKind kind;

/// Create a copy of TableWithdrawProposalCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableWithdrawProposalCommandCopyWith<_TableWithdrawProposalCommand> get copyWith => __$TableWithdrawProposalCommandCopyWithImpl<_TableWithdrawProposalCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableWithdrawProposalCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableWithdrawProposalCommand&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'TableWithdrawProposalCommand(kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$TableWithdrawProposalCommandCopyWith<$Res> implements $TableWithdrawProposalCommandCopyWith<$Res> {
  factory _$TableWithdrawProposalCommandCopyWith(_TableWithdrawProposalCommand value, $Res Function(_TableWithdrawProposalCommand) _then) = __$TableWithdrawProposalCommandCopyWithImpl;
@override @useResult
$Res call({
 TableWithdrawProposalCommandKind kind
});




}
/// @nodoc
class __$TableWithdrawProposalCommandCopyWithImpl<$Res>
    implements _$TableWithdrawProposalCommandCopyWith<$Res> {
  __$TableWithdrawProposalCommandCopyWithImpl(this._self, this._then);

  final _TableWithdrawProposalCommand _self;
  final $Res Function(_TableWithdrawProposalCommand) _then;

/// Create a copy of TableWithdrawProposalCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(_TableWithdrawProposalCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableWithdrawProposalCommandKind,
  ));
}


}

// dart format on
