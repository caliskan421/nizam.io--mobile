// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_column.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableColumn {

/// Çoklu referans sütunu (TABLES-K14): hücre değeri 1–50 benzersiz kimlik dizisidir. Yalnız referans tiplerinde true olabilir; oluşturulduktan sonra değişmez.
 bool get multiple; String get id; String get name; TableColumnType get type;/// Piksel genişliği.
 int get width; int get position;
/// Create a copy of TableColumn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableColumnCopyWith<TableColumn> get copyWith => _$TableColumnCopyWithImpl<TableColumn>(this as TableColumn, _$identity);

  /// Serializes this TableColumn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableColumn;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableColumn&&(identical(other.multiple, _this.multiple) || other.multiple == _this.multiple)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.position, _this.position) || other.position == _this.position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableColumn;
  return Object.hash(runtimeType,_this.multiple,_this.id,_this.name,_this.type,_this.width,_this.position);
}

@override
String toString() {
  final _this = this as TableColumn;
  return 'TableColumn(multiple: ${_this.multiple}, id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, width: ${_this.width}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $TableColumnCopyWith<$Res>  {
  factory $TableColumnCopyWith(TableColumn value, $Res Function(TableColumn) _then) = _$TableColumnCopyWithImpl;
@useResult
$Res call({
 bool multiple, String id, String name, TableColumnType type, int width, int position
});




}
/// @nodoc
class _$TableColumnCopyWithImpl<$Res>
    implements $TableColumnCopyWith<$Res> {
  _$TableColumnCopyWithImpl(this._self, this._then);

  final TableColumn _self;
  final $Res Function(TableColumn) _then;

/// Create a copy of TableColumn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? multiple = null,Object? id = null,Object? name = null,Object? type = null,Object? width = null,Object? position = null,}) {
  return _then(TableColumn(
multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableColumn].
extension TableColumnPatterns on TableColumn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableColumn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableColumn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableColumn value)  $default,){
final _that = this;
switch (_that) {
case _TableColumn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableColumn value)?  $default,){
final _that = this;
switch (_that) {
case _TableColumn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool multiple,  String id,  String name,  TableColumnType type,  int width,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableColumn() when $default != null:
return $default(_that.multiple,_that.id,_that.name,_that.type,_that.width,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool multiple,  String id,  String name,  TableColumnType type,  int width,  int position)  $default,) {final _that = this;
switch (_that) {
case _TableColumn():
return $default(_that.multiple,_that.id,_that.name,_that.type,_that.width,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool multiple,  String id,  String name,  TableColumnType type,  int width,  int position)?  $default,) {final _that = this;
switch (_that) {
case _TableColumn() when $default != null:
return $default(_that.multiple,_that.id,_that.name,_that.type,_that.width,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableColumn implements TableColumn {
  const _TableColumn({required this.multiple, required this.id, required this.name, required this.type, required this.width, required this.position});
  factory _TableColumn.fromJson(Map<String, dynamic> json) => _$TableColumnFromJson(json);

/// Çoklu referans sütunu (TABLES-K14): hücre değeri 1–50 benzersiz kimlik dizisidir. Yalnız referans tiplerinde true olabilir; oluşturulduktan sonra değişmez.
@override final  bool multiple;
@override final  String id;
@override final  String name;
@override final  TableColumnType type;
/// Piksel genişliği.
@override final  int width;
@override final  int position;

/// Create a copy of TableColumn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableColumnCopyWith<_TableColumn> get copyWith => __$TableColumnCopyWithImpl<_TableColumn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableColumnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableColumn&&(identical(other.multiple, multiple) || other.multiple == multiple)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,multiple,id,name,type,width,position);
}

@override
String toString() {
    return 'TableColumn(multiple: $multiple, id: $id, name: $name, type: $type, width: $width, position: $position)';
}


}

/// @nodoc
abstract mixin class _$TableColumnCopyWith<$Res> implements $TableColumnCopyWith<$Res> {
  factory _$TableColumnCopyWith(_TableColumn value, $Res Function(_TableColumn) _then) = __$TableColumnCopyWithImpl;
@override @useResult
$Res call({
 bool multiple, String id, String name, TableColumnType type, int width, int position
});




}
/// @nodoc
class __$TableColumnCopyWithImpl<$Res>
    implements _$TableColumnCopyWith<$Res> {
  __$TableColumnCopyWithImpl(this._self, this._then);

  final _TableColumn _self;
  final $Res Function(_TableColumn) _then;

/// Create a copy of TableColumn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? multiple = null,Object? id = null,Object? name = null,Object? type = null,Object? width = null,Object? position = null,}) {
  return _then(_TableColumn(
multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
