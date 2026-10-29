// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rename_file_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenameFileRequest {

@JsonKey(name: 'display_name') String get displayName;
/// Create a copy of RenameFileRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenameFileRequestCopyWith<RenameFileRequest> get copyWith => _$RenameFileRequestCopyWithImpl<RenameFileRequest>(this as RenameFileRequest, _$identity);

  /// Serializes this RenameFileRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RenameFileRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenameFileRequest&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RenameFileRequest;
  return Object.hash(runtimeType,_this.displayName);
}

@override
String toString() {
  final _this = this as RenameFileRequest;
  return 'RenameFileRequest(displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $RenameFileRequestCopyWith<$Res>  {
  factory $RenameFileRequestCopyWith(RenameFileRequest value, $Res Function(RenameFileRequest) _then) = _$RenameFileRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'display_name') String displayName
});




}
/// @nodoc
class _$RenameFileRequestCopyWithImpl<$Res>
    implements $RenameFileRequestCopyWith<$Res> {
  _$RenameFileRequestCopyWithImpl(this._self, this._then);

  final RenameFileRequest _self;
  final $Res Function(RenameFileRequest) _then;

/// Create a copy of RenameFileRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,}) {
  return _then(RenameFileRequest(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenameFileRequest].
extension RenameFileRequestPatterns on RenameFileRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenameFileRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenameFileRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenameFileRequest value)  $default,){
final _that = this;
switch (_that) {
case _RenameFileRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenameFileRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RenameFileRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenameFileRequest() when $default != null:
return $default(_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName)  $default,) {final _that = this;
switch (_that) {
case _RenameFileRequest():
return $default(_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'display_name')  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _RenameFileRequest() when $default != null:
return $default(_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenameFileRequest implements RenameFileRequest {
  const _RenameFileRequest({@JsonKey(name: 'display_name') required this.displayName});
  factory _RenameFileRequest.fromJson(Map<String, dynamic> json) => _$RenameFileRequestFromJson(json);

@override@JsonKey(name: 'display_name') final  String displayName;

/// Create a copy of RenameFileRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenameFileRequestCopyWith<_RenameFileRequest> get copyWith => __$RenameFileRequestCopyWithImpl<_RenameFileRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenameFileRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenameFileRequest&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName);
}

@override
String toString() {
    return 'RenameFileRequest(displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$RenameFileRequestCopyWith<$Res> implements $RenameFileRequestCopyWith<$Res> {
  factory _$RenameFileRequestCopyWith(_RenameFileRequest value, $Res Function(_RenameFileRequest) _then) = __$RenameFileRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'display_name') String displayName
});




}
/// @nodoc
class __$RenameFileRequestCopyWithImpl<$Res>
    implements _$RenameFileRequestCopyWith<$Res> {
  __$RenameFileRequestCopyWithImpl(this._self, this._then);

  final _RenameFileRequest _self;
  final $Res Function(_RenameFileRequest) _then;

/// Create a copy of RenameFileRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,}) {
  return _then(_RenameFileRequest(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
