// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCreateRequest {

/// Kırpılmış, satır sonu ve NUL içermeyen ad (en çok 200 Unicode karakter).
 String get name;/// İsteğe bağlı; verilirse `create_table` olmalıdır.
 TableCreateRequestKind? get kind;
/// Create a copy of TableCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCreateRequestCopyWith<TableCreateRequest> get copyWith => _$TableCreateRequestCopyWithImpl<TableCreateRequest>(this as TableCreateRequest, _$identity);

  /// Serializes this TableCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCreateRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCreateRequest;
  return Object.hash(runtimeType,_this.name,_this.kind);
}

@override
String toString() {
  final _this = this as TableCreateRequest;
  return 'TableCreateRequest(name: ${_this.name}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $TableCreateRequestCopyWith<$Res>  {
  factory $TableCreateRequestCopyWith(TableCreateRequest value, $Res Function(TableCreateRequest) _then) = _$TableCreateRequestCopyWithImpl;
@useResult
$Res call({
 String name, TableCreateRequestKind? kind
});




}
/// @nodoc
class _$TableCreateRequestCopyWithImpl<$Res>
    implements $TableCreateRequestCopyWith<$Res> {
  _$TableCreateRequestCopyWithImpl(this._self, this._then);

  final TableCreateRequest _self;
  final $Res Function(TableCreateRequest) _then;

/// Create a copy of TableCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? kind = freezed,}) {
  return _then(TableCreateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableCreateRequestKind?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableCreateRequest].
extension TableCreateRequestPatterns on TableCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _TableCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TableCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TableCreateRequestKind? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCreateRequest() when $default != null:
return $default(_that.name,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TableCreateRequestKind? kind)  $default,) {final _that = this;
switch (_that) {
case _TableCreateRequest():
return $default(_that.name,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TableCreateRequestKind? kind)?  $default,) {final _that = this;
switch (_that) {
case _TableCreateRequest() when $default != null:
return $default(_that.name,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCreateRequest implements TableCreateRequest {
  const _TableCreateRequest({required this.name, this.kind});
  factory _TableCreateRequest.fromJson(Map<String, dynamic> json) => _$TableCreateRequestFromJson(json);

/// Kırpılmış, satır sonu ve NUL içermeyen ad (en çok 200 Unicode karakter).
@override final  String name;
/// İsteğe bağlı; verilirse `create_table` olmalıdır.
@override final  TableCreateRequestKind? kind;

/// Create a copy of TableCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCreateRequestCopyWith<_TableCreateRequest> get copyWith => __$TableCreateRequestCopyWithImpl<_TableCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCreateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,kind);
}

@override
String toString() {
    return 'TableCreateRequest(name: $name, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$TableCreateRequestCopyWith<$Res> implements $TableCreateRequestCopyWith<$Res> {
  factory _$TableCreateRequestCopyWith(_TableCreateRequest value, $Res Function(_TableCreateRequest) _then) = __$TableCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, TableCreateRequestKind? kind
});




}
/// @nodoc
class __$TableCreateRequestCopyWithImpl<$Res>
    implements _$TableCreateRequestCopyWith<$Res> {
  __$TableCreateRequestCopyWithImpl(this._self, this._then);

  final _TableCreateRequest _self;
  final $Res Function(_TableCreateRequest) _then;

/// Create a copy of TableCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? kind = freezed,}) {
  return _then(_TableCreateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableCreateRequestKind?,
  ));
}


}

// dart format on
