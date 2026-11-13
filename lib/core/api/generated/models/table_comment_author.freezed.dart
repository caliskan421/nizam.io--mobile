// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_comment_author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCommentAuthor {

 String get id; String get name;
/// Create a copy of TableCommentAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommentAuthorCopyWith<TableCommentAuthor> get copyWith => _$TableCommentAuthorCopyWithImpl<TableCommentAuthor>(this as TableCommentAuthor, _$identity);

  /// Serializes this TableCommentAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCommentAuthor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommentAuthor&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCommentAuthor;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as TableCommentAuthor;
  return 'TableCommentAuthor(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TableCommentAuthorCopyWith<$Res>  {
  factory $TableCommentAuthorCopyWith(TableCommentAuthor value, $Res Function(TableCommentAuthor) _then) = _$TableCommentAuthorCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$TableCommentAuthorCopyWithImpl<$Res>
    implements $TableCommentAuthorCopyWith<$Res> {
  _$TableCommentAuthorCopyWithImpl(this._self, this._then);

  final TableCommentAuthor _self;
  final $Res Function(TableCommentAuthor) _then;

/// Create a copy of TableCommentAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(TableCommentAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableCommentAuthor].
extension TableCommentAuthorPatterns on TableCommentAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCommentAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCommentAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCommentAuthor value)  $default,){
final _that = this;
switch (_that) {
case _TableCommentAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCommentAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _TableCommentAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCommentAuthor() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _TableCommentAuthor():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TableCommentAuthor() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCommentAuthor implements TableCommentAuthor {
  const _TableCommentAuthor({required this.id, required this.name});
  factory _TableCommentAuthor.fromJson(Map<String, dynamic> json) => _$TableCommentAuthorFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of TableCommentAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCommentAuthorCopyWith<_TableCommentAuthor> get copyWith => __$TableCommentAuthorCopyWithImpl<_TableCommentAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommentAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCommentAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'TableCommentAuthor(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TableCommentAuthorCopyWith<$Res> implements $TableCommentAuthorCopyWith<$Res> {
  factory _$TableCommentAuthorCopyWith(_TableCommentAuthor value, $Res Function(_TableCommentAuthor) _then) = __$TableCommentAuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$TableCommentAuthorCopyWithImpl<$Res>
    implements _$TableCommentAuthorCopyWith<$Res> {
  __$TableCommentAuthorCopyWithImpl(this._self, this._then);

  final _TableCommentAuthor _self;
  final $Res Function(_TableCommentAuthor) _then;

/// Create a copy of TableCommentAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_TableCommentAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
