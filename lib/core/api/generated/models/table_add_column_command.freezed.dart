// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_add_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableAddColumnCommand {

 TableAddColumnCommandKind get kind; String get name; TableColumnType get type; int get width;@JsonKey(name: 'expected_schema') int get expectedSchema;/// Çoklu referans sütunu (TABLES-K14); yalnız `*_reference` tiplerinde true olabilir, aksi 422.
 bool get multiple;
/// Create a copy of TableAddColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableAddColumnCommandCopyWith<TableAddColumnCommand> get copyWith => _$TableAddColumnCommandCopyWithImpl<TableAddColumnCommand>(this as TableAddColumnCommand, _$identity);

  /// Serializes this TableAddColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableAddColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableAddColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema)&&(identical(other.multiple, _this.multiple) || other.multiple == _this.multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableAddColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.name,_this.type,_this.width,_this.expectedSchema,_this.multiple);
}

@override
String toString() {
  final _this = this as TableAddColumnCommand;
  return 'TableAddColumnCommand(kind: ${_this.kind}, name: ${_this.name}, type: ${_this.type}, width: ${_this.width}, expectedSchema: ${_this.expectedSchema}, multiple: ${_this.multiple})';
}


}

/// @nodoc
abstract mixin class $TableAddColumnCommandCopyWith<$Res>  {
  factory $TableAddColumnCommandCopyWith(TableAddColumnCommand value, $Res Function(TableAddColumnCommand) _then) = _$TableAddColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableAddColumnCommandKind kind, String name, TableColumnType type, int width,@JsonKey(name: 'expected_schema') int expectedSchema, bool multiple
});




}
/// @nodoc
class _$TableAddColumnCommandCopyWithImpl<$Res>
    implements $TableAddColumnCommandCopyWith<$Res> {
  _$TableAddColumnCommandCopyWithImpl(this._self, this._then);

  final TableAddColumnCommand _self;
  final $Res Function(TableAddColumnCommand) _then;

/// Create a copy of TableAddColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,Object? type = null,Object? width = null,Object? expectedSchema = null,Object? multiple = null,}) {
  return _then(TableAddColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddColumnCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TableAddColumnCommand].
extension TableAddColumnCommandPatterns on TableAddColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableAddColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableAddColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableAddColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableAddColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableAddColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableAddColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableAddColumnCommand() when $default != null:
return $default(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)  $default,) {final _that = this;
switch (_that) {
case _TableAddColumnCommand():
return $default(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableAddColumnCommandKind kind,  String name,  TableColumnType type,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema,  bool multiple)?  $default,) {final _that = this;
switch (_that) {
case _TableAddColumnCommand() when $default != null:
return $default(_that.kind,_that.name,_that.type,_that.width,_that.expectedSchema,_that.multiple);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableAddColumnCommand implements TableAddColumnCommand {
  const _TableAddColumnCommand({required this.kind, required this.name, required this.type, required this.width, @JsonKey(name: 'expected_schema') required this.expectedSchema, this.multiple = false});
  factory _TableAddColumnCommand.fromJson(Map<String, dynamic> json) => _$TableAddColumnCommandFromJson(json);

@override final  TableAddColumnCommandKind kind;
@override final  String name;
@override final  TableColumnType type;
@override final  int width;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;
/// Çoklu referans sütunu (TABLES-K14); yalnız `*_reference` tiplerinde true olabilir, aksi 422.
@override@JsonKey() final  bool multiple;

/// Create a copy of TableAddColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableAddColumnCommandCopyWith<_TableAddColumnCommand> get copyWith => __$TableAddColumnCommandCopyWithImpl<_TableAddColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableAddColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableAddColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema)&&(identical(other.multiple, multiple) || other.multiple == multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name,type,width,expectedSchema,multiple);
}

@override
String toString() {
    return 'TableAddColumnCommand(kind: $kind, name: $name, type: $type, width: $width, expectedSchema: $expectedSchema, multiple: $multiple)';
}


}

/// @nodoc
abstract mixin class _$TableAddColumnCommandCopyWith<$Res> implements $TableAddColumnCommandCopyWith<$Res> {
  factory _$TableAddColumnCommandCopyWith(_TableAddColumnCommand value, $Res Function(_TableAddColumnCommand) _then) = __$TableAddColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableAddColumnCommandKind kind, String name, TableColumnType type, int width,@JsonKey(name: 'expected_schema') int expectedSchema, bool multiple
});




}
/// @nodoc
class __$TableAddColumnCommandCopyWithImpl<$Res>
    implements _$TableAddColumnCommandCopyWith<$Res> {
  __$TableAddColumnCommandCopyWithImpl(this._self, this._then);

  final _TableAddColumnCommand _self;
  final $Res Function(_TableAddColumnCommand) _then;

/// Create a copy of TableAddColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,Object? type = null,Object? width = null,Object? expectedSchema = null,Object? multiple = null,}) {
  return _then(_TableAddColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddColumnCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
