// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'columns.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Columns {

 String get name; TableColumnType get type; bool get multiple;
/// Create a copy of Columns
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColumnsCopyWith<Columns> get copyWith => _$ColumnsCopyWithImpl<Columns>(this as Columns, _$identity);

  /// Serializes this Columns to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Columns;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Columns&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.multiple, _this.multiple) || other.multiple == _this.multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Columns;
  return Object.hash(runtimeType,_this.name,_this.type,_this.multiple);
}

@override
String toString() {
  final _this = this as Columns;
  return 'Columns(name: ${_this.name}, type: ${_this.type}, multiple: ${_this.multiple})';
}


}

/// @nodoc
abstract mixin class $ColumnsCopyWith<$Res>  {
  factory $ColumnsCopyWith(Columns value, $Res Function(Columns) _then) = _$ColumnsCopyWithImpl;
@useResult
$Res call({
 String name, TableColumnType type, bool multiple
});




}
/// @nodoc
class _$ColumnsCopyWithImpl<$Res>
    implements $ColumnsCopyWith<$Res> {
  _$ColumnsCopyWithImpl(this._self, this._then);

  final Columns _self;
  final $Res Function(Columns) _then;

/// Create a copy of Columns
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? multiple = null,}) {
  return _then(Columns(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Columns].
extension ColumnsPatterns on Columns {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Columns value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Columns() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Columns value)  $default,){
final _that = this;
switch (_that) {
case _Columns():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Columns value)?  $default,){
final _that = this;
switch (_that) {
case _Columns() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TableColumnType type,  bool multiple)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Columns() when $default != null:
return $default(_that.name,_that.type,_that.multiple);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TableColumnType type,  bool multiple)  $default,) {final _that = this;
switch (_that) {
case _Columns():
return $default(_that.name,_that.type,_that.multiple);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TableColumnType type,  bool multiple)?  $default,) {final _that = this;
switch (_that) {
case _Columns() when $default != null:
return $default(_that.name,_that.type,_that.multiple);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Columns implements Columns {
  const _Columns({required this.name, required this.type, required this.multiple});
  factory _Columns.fromJson(Map<String, dynamic> json) => _$ColumnsFromJson(json);

@override final  String name;
@override final  TableColumnType type;
@override final  bool multiple;

/// Create a copy of Columns
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColumnsCopyWith<_Columns> get copyWith => __$ColumnsCopyWithImpl<_Columns>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ColumnsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Columns&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.multiple, multiple) || other.multiple == multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,multiple);
}

@override
String toString() {
    return 'Columns(name: $name, type: $type, multiple: $multiple)';
}


}

/// @nodoc
abstract mixin class _$ColumnsCopyWith<$Res> implements $ColumnsCopyWith<$Res> {
  factory _$ColumnsCopyWith(_Columns value, $Res Function(_Columns) _then) = __$ColumnsCopyWithImpl;
@override @useResult
$Res call({
 String name, TableColumnType type, bool multiple
});




}
/// @nodoc
class __$ColumnsCopyWithImpl<$Res>
    implements _$ColumnsCopyWith<$Res> {
  __$ColumnsCopyWithImpl(this._self, this._then);

  final _Columns _self;
  final $Res Function(_Columns) _then;

/// Create a copy of Columns
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? multiple = null,}) {
  return _then(_Columns(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
