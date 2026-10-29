// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_note_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkNoteRequest {

 String get content;
/// Create a copy of WorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkNoteRequestCopyWith<WorkNoteRequest> get copyWith => _$WorkNoteRequestCopyWithImpl<WorkNoteRequest>(this as WorkNoteRequest, _$identity);

  /// Serializes this WorkNoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkNoteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkNoteRequest&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkNoteRequest;
  return Object.hash(runtimeType,_this.content);
}

@override
String toString() {
  final _this = this as WorkNoteRequest;
  return 'WorkNoteRequest(content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $WorkNoteRequestCopyWith<$Res>  {
  factory $WorkNoteRequestCopyWith(WorkNoteRequest value, $Res Function(WorkNoteRequest) _then) = _$WorkNoteRequestCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$WorkNoteRequestCopyWithImpl<$Res>
    implements $WorkNoteRequestCopyWith<$Res> {
  _$WorkNoteRequestCopyWithImpl(this._self, this._then);

  final WorkNoteRequest _self;
  final $Res Function(WorkNoteRequest) _then;

/// Create a copy of WorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(WorkNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkNoteRequest].
extension WorkNoteRequestPatterns on WorkNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _WorkNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _WorkNoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkNoteRequest() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content)  $default,) {final _that = this;
switch (_that) {
case _WorkNoteRequest():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content)?  $default,) {final _that = this;
switch (_that) {
case _WorkNoteRequest() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkNoteRequest implements WorkNoteRequest {
  const _WorkNoteRequest({required this.content});
  factory _WorkNoteRequest.fromJson(Map<String, dynamic> json) => _$WorkNoteRequestFromJson(json);

@override final  String content;

/// Create a copy of WorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkNoteRequestCopyWith<_WorkNoteRequest> get copyWith => __$WorkNoteRequestCopyWithImpl<_WorkNoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkNoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkNoteRequest&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content);
}

@override
String toString() {
    return 'WorkNoteRequest(content: $content)';
}


}

/// @nodoc
abstract mixin class _$WorkNoteRequestCopyWith<$Res> implements $WorkNoteRequestCopyWith<$Res> {
  factory _$WorkNoteRequestCopyWith(_WorkNoteRequest value, $Res Function(_WorkNoteRequest) _then) = __$WorkNoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String content
});




}
/// @nodoc
class __$WorkNoteRequestCopyWithImpl<$Res>
    implements _$WorkNoteRequestCopyWith<$Res> {
  __$WorkNoteRequestCopyWithImpl(this._self, this._then);

  final _WorkNoteRequest _self;
  final $Res Function(_WorkNoteRequest) _then;

/// Create a copy of WorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_WorkNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
