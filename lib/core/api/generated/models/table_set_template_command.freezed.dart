// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_set_template_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSetTemplateCommand {

 TableSetTemplateCommandKind get kind; bool get template;
/// Create a copy of TableSetTemplateCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSetTemplateCommandCopyWith<TableSetTemplateCommand> get copyWith => _$TableSetTemplateCommandCopyWithImpl<TableSetTemplateCommand>(this as TableSetTemplateCommand, _$identity);

  /// Serializes this TableSetTemplateCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSetTemplateCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSetTemplateCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.template, _this.template) || other.template == _this.template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSetTemplateCommand;
  return Object.hash(runtimeType,_this.kind,_this.template);
}

@override
String toString() {
  final _this = this as TableSetTemplateCommand;
  return 'TableSetTemplateCommand(kind: ${_this.kind}, template: ${_this.template})';
}


}

/// @nodoc
abstract mixin class $TableSetTemplateCommandCopyWith<$Res>  {
  factory $TableSetTemplateCommandCopyWith(TableSetTemplateCommand value, $Res Function(TableSetTemplateCommand) _then) = _$TableSetTemplateCommandCopyWithImpl;
@useResult
$Res call({
 TableSetTemplateCommandKind kind, bool template
});




}
/// @nodoc
class _$TableSetTemplateCommandCopyWithImpl<$Res>
    implements $TableSetTemplateCommandCopyWith<$Res> {
  _$TableSetTemplateCommandCopyWithImpl(this._self, this._then);

  final TableSetTemplateCommand _self;
  final $Res Function(TableSetTemplateCommand) _then;

/// Create a copy of TableSetTemplateCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? template = null,}) {
  return _then(TableSetTemplateCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTemplateCommandKind,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSetTemplateCommand].
extension TableSetTemplateCommandPatterns on TableSetTemplateCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSetTemplateCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSetTemplateCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSetTemplateCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableSetTemplateCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSetTemplateCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableSetTemplateCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableSetTemplateCommandKind kind,  bool template)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSetTemplateCommand() when $default != null:
return $default(_that.kind,_that.template);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableSetTemplateCommandKind kind,  bool template)  $default,) {final _that = this;
switch (_that) {
case _TableSetTemplateCommand():
return $default(_that.kind,_that.template);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableSetTemplateCommandKind kind,  bool template)?  $default,) {final _that = this;
switch (_that) {
case _TableSetTemplateCommand() when $default != null:
return $default(_that.kind,_that.template);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSetTemplateCommand implements TableSetTemplateCommand {
  const _TableSetTemplateCommand({required this.kind, required this.template});
  factory _TableSetTemplateCommand.fromJson(Map<String, dynamic> json) => _$TableSetTemplateCommandFromJson(json);

@override final  TableSetTemplateCommandKind kind;
@override final  bool template;

/// Create a copy of TableSetTemplateCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSetTemplateCommandCopyWith<_TableSetTemplateCommand> get copyWith => __$TableSetTemplateCommandCopyWithImpl<_TableSetTemplateCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSetTemplateCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSetTemplateCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.template, template) || other.template == template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,template);
}

@override
String toString() {
    return 'TableSetTemplateCommand(kind: $kind, template: $template)';
}


}

/// @nodoc
abstract mixin class _$TableSetTemplateCommandCopyWith<$Res> implements $TableSetTemplateCommandCopyWith<$Res> {
  factory _$TableSetTemplateCommandCopyWith(_TableSetTemplateCommand value, $Res Function(_TableSetTemplateCommand) _then) = __$TableSetTemplateCommandCopyWithImpl;
@override @useResult
$Res call({
 TableSetTemplateCommandKind kind, bool template
});




}
/// @nodoc
class __$TableSetTemplateCommandCopyWithImpl<$Res>
    implements _$TableSetTemplateCommandCopyWith<$Res> {
  __$TableSetTemplateCommandCopyWithImpl(this._self, this._then);

  final _TableSetTemplateCommand _self;
  final $Res Function(_TableSetTemplateCommand) _then;

/// Create a copy of TableSetTemplateCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? template = null,}) {
  return _then(_TableSetTemplateCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableSetTemplateCommandKind,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
