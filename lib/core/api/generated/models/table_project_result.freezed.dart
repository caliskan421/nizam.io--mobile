// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_project_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProjectResult {

/// Proje kimliği.
 String get id;/// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı (audit yazılmaz).
 bool get replayed;
/// Create a copy of TableProjectResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectResultCopyWith<TableProjectResult> get copyWith => _$TableProjectResultCopyWithImpl<TableProjectResult>(this as TableProjectResult, _$identity);

  /// Serializes this TableProjectResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProjectResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectResult&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.replayed, _this.replayed) || other.replayed == _this.replayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProjectResult;
  return Object.hash(runtimeType,_this.id,_this.replayed);
}

@override
String toString() {
  final _this = this as TableProjectResult;
  return 'TableProjectResult(id: ${_this.id}, replayed: ${_this.replayed})';
}


}

/// @nodoc
abstract mixin class $TableProjectResultCopyWith<$Res>  {
  factory $TableProjectResultCopyWith(TableProjectResult value, $Res Function(TableProjectResult) _then) = _$TableProjectResultCopyWithImpl;
@useResult
$Res call({
 String id, bool replayed
});




}
/// @nodoc
class _$TableProjectResultCopyWithImpl<$Res>
    implements $TableProjectResultCopyWith<$Res> {
  _$TableProjectResultCopyWithImpl(this._self, this._then);

  final TableProjectResult _self;
  final $Res Function(TableProjectResult) _then;

/// Create a copy of TableProjectResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? replayed = null,}) {
  return _then(TableProjectResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProjectResult].
extension TableProjectResultPatterns on TableProjectResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProjectResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProjectResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProjectResult value)  $default,){
final _that = this;
switch (_that) {
case _TableProjectResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProjectResult value)?  $default,){
final _that = this;
switch (_that) {
case _TableProjectResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool replayed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProjectResult() when $default != null:
return $default(_that.id,_that.replayed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool replayed)  $default,) {final _that = this;
switch (_that) {
case _TableProjectResult():
return $default(_that.id,_that.replayed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool replayed)?  $default,) {final _that = this;
switch (_that) {
case _TableProjectResult() when $default != null:
return $default(_that.id,_that.replayed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProjectResult implements TableProjectResult {
  const _TableProjectResult({required this.id, required this.replayed});
  factory _TableProjectResult.fromJson(Map<String, dynamic> json) => _$TableProjectResultFromJson(json);

/// Proje kimliği.
@override final  String id;
/// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı (audit yazılmaz).
@override final  bool replayed;

/// Create a copy of TableProjectResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProjectResultCopyWith<_TableProjectResult> get copyWith => __$TableProjectResultCopyWithImpl<_TableProjectResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProjectResult&&(identical(other.id, id) || other.id == id)&&(identical(other.replayed, replayed) || other.replayed == replayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,replayed);
}

@override
String toString() {
    return 'TableProjectResult(id: $id, replayed: $replayed)';
}


}

/// @nodoc
abstract mixin class _$TableProjectResultCopyWith<$Res> implements $TableProjectResultCopyWith<$Res> {
  factory _$TableProjectResultCopyWith(_TableProjectResult value, $Res Function(_TableProjectResult) _then) = __$TableProjectResultCopyWithImpl;
@override @useResult
$Res call({
 String id, bool replayed
});




}
/// @nodoc
class __$TableProjectResultCopyWithImpl<$Res>
    implements _$TableProjectResultCopyWith<$Res> {
  __$TableProjectResultCopyWithImpl(this._self, this._then);

  final _TableProjectResult _self;
  final $Res Function(_TableProjectResult) _then;

/// Create a copy of TableProjectResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? replayed = null,}) {
  return _then(_TableProjectResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
