// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retag_file_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetagFileRequest {

/// Kapalı etiket kümesi (RECORDS-K07).
 RetagFileRequestTag get tag;
/// Create a copy of RetagFileRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetagFileRequestCopyWith<RetagFileRequest> get copyWith => _$RetagFileRequestCopyWithImpl<RetagFileRequest>(this as RetagFileRequest, _$identity);

  /// Serializes this RetagFileRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RetagFileRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetagFileRequest&&(identical(other.tag, _this.tag) || other.tag == _this.tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RetagFileRequest;
  return Object.hash(runtimeType,_this.tag);
}

@override
String toString() {
  final _this = this as RetagFileRequest;
  return 'RetagFileRequest(tag: ${_this.tag})';
}


}

/// @nodoc
abstract mixin class $RetagFileRequestCopyWith<$Res>  {
  factory $RetagFileRequestCopyWith(RetagFileRequest value, $Res Function(RetagFileRequest) _then) = _$RetagFileRequestCopyWithImpl;
@useResult
$Res call({
 RetagFileRequestTag tag
});




}
/// @nodoc
class _$RetagFileRequestCopyWithImpl<$Res>
    implements $RetagFileRequestCopyWith<$Res> {
  _$RetagFileRequestCopyWithImpl(this._self, this._then);

  final RetagFileRequest _self;
  final $Res Function(RetagFileRequest) _then;

/// Create a copy of RetagFileRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,}) {
  return _then(RetagFileRequest(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as RetagFileRequestTag,
  ));
}

}


/// Adds pattern-matching-related methods to [RetagFileRequest].
extension RetagFileRequestPatterns on RetagFileRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RetagFileRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RetagFileRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RetagFileRequest value)  $default,){
final _that = this;
switch (_that) {
case _RetagFileRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RetagFileRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RetagFileRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RetagFileRequestTag tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RetagFileRequest() when $default != null:
return $default(_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RetagFileRequestTag tag)  $default,) {final _that = this;
switch (_that) {
case _RetagFileRequest():
return $default(_that.tag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RetagFileRequestTag tag)?  $default,) {final _that = this;
switch (_that) {
case _RetagFileRequest() when $default != null:
return $default(_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RetagFileRequest implements RetagFileRequest {
  const _RetagFileRequest({required this.tag});
  factory _RetagFileRequest.fromJson(Map<String, dynamic> json) => _$RetagFileRequestFromJson(json);

/// Kapalı etiket kümesi (RECORDS-K07).
@override final  RetagFileRequestTag tag;

/// Create a copy of RetagFileRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetagFileRequestCopyWith<_RetagFileRequest> get copyWith => __$RetagFileRequestCopyWithImpl<_RetagFileRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RetagFileRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetagFileRequest&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tag);
}

@override
String toString() {
    return 'RetagFileRequest(tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$RetagFileRequestCopyWith<$Res> implements $RetagFileRequestCopyWith<$Res> {
  factory _$RetagFileRequestCopyWith(_RetagFileRequest value, $Res Function(_RetagFileRequest) _then) = __$RetagFileRequestCopyWithImpl;
@override @useResult
$Res call({
 RetagFileRequestTag tag
});




}
/// @nodoc
class __$RetagFileRequestCopyWithImpl<$Res>
    implements _$RetagFileRequestCopyWith<$Res> {
  __$RetagFileRequestCopyWithImpl(this._self, this._then);

  final _RetagFileRequest _self;
  final $Res Function(_RetagFileRequest) _then;

/// Create a copy of RetagFileRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,}) {
  return _then(_RetagFileRequest(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as RetagFileRequestTag,
  ));
}


}

// dart format on
