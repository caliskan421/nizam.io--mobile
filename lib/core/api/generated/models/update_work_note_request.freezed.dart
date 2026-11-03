// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_work_note_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateWorkNoteRequest {

 String get content;/// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `work.input_invalid` + `work.revision_required`, pozitif değilse `work.revision_invalid`; bayatsa ve içerik farklıysa 409 `work.edit_conflict`. Tamsayı olmayan değer 422 `platform.body_invalid` (alan bilgisi yok).
@JsonKey(name: 'expected_revision') int get expectedRevision;
/// Create a copy of UpdateWorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkNoteRequestCopyWith<UpdateWorkNoteRequest> get copyWith => _$UpdateWorkNoteRequestCopyWithImpl<UpdateWorkNoteRequest>(this as UpdateWorkNoteRequest, _$identity);

  /// Serializes this UpdateWorkNoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateWorkNoteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkNoteRequest&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.expectedRevision, _this.expectedRevision) || other.expectedRevision == _this.expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateWorkNoteRequest;
  return Object.hash(runtimeType,_this.content,_this.expectedRevision);
}

@override
String toString() {
  final _this = this as UpdateWorkNoteRequest;
  return 'UpdateWorkNoteRequest(content: ${_this.content}, expectedRevision: ${_this.expectedRevision})';
}


}

/// @nodoc
abstract mixin class $UpdateWorkNoteRequestCopyWith<$Res>  {
  factory $UpdateWorkNoteRequestCopyWith(UpdateWorkNoteRequest value, $Res Function(UpdateWorkNoteRequest) _then) = _$UpdateWorkNoteRequestCopyWithImpl;
@useResult
$Res call({
 String content,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class _$UpdateWorkNoteRequestCopyWithImpl<$Res>
    implements $UpdateWorkNoteRequestCopyWith<$Res> {
  _$UpdateWorkNoteRequestCopyWithImpl(this._self, this._then);

  final UpdateWorkNoteRequest _self;
  final $Res Function(UpdateWorkNoteRequest) _then;

/// Create a copy of UpdateWorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? expectedRevision = null,}) {
  return _then(UpdateWorkNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkNoteRequest].
extension UpdateWorkNoteRequestPatterns on UpdateWorkNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content, @JsonKey(name: 'expected_revision')  int expectedRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest() when $default != null:
return $default(_that.content,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content, @JsonKey(name: 'expected_revision')  int expectedRevision)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest():
return $default(_that.content,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content, @JsonKey(name: 'expected_revision')  int expectedRevision)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkNoteRequest() when $default != null:
return $default(_that.content,_that.expectedRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkNoteRequest implements UpdateWorkNoteRequest {
  const _UpdateWorkNoteRequest({required this.content, @JsonKey(name: 'expected_revision') required this.expectedRevision});
  factory _UpdateWorkNoteRequest.fromJson(Map<String, dynamic> json) => _$UpdateWorkNoteRequestFromJson(json);

@override final  String content;
/// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `work.input_invalid` + `work.revision_required`, pozitif değilse `work.revision_invalid`; bayatsa ve içerik farklıysa 409 `work.edit_conflict`. Tamsayı olmayan değer 422 `platform.body_invalid` (alan bilgisi yok).
@override@JsonKey(name: 'expected_revision') final  int expectedRevision;

/// Create a copy of UpdateWorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkNoteRequestCopyWith<_UpdateWorkNoteRequest> get copyWith => __$UpdateWorkNoteRequestCopyWithImpl<_UpdateWorkNoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkNoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkNoteRequest&&(identical(other.content, content) || other.content == content)&&(identical(other.expectedRevision, expectedRevision) || other.expectedRevision == expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,expectedRevision);
}

@override
String toString() {
    return 'UpdateWorkNoteRequest(content: $content, expectedRevision: $expectedRevision)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkNoteRequestCopyWith<$Res> implements $UpdateWorkNoteRequestCopyWith<$Res> {
  factory _$UpdateWorkNoteRequestCopyWith(_UpdateWorkNoteRequest value, $Res Function(_UpdateWorkNoteRequest) _then) = __$UpdateWorkNoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String content,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class __$UpdateWorkNoteRequestCopyWithImpl<$Res>
    implements _$UpdateWorkNoteRequestCopyWith<$Res> {
  __$UpdateWorkNoteRequestCopyWithImpl(this._self, this._then);

  final _UpdateWorkNoteRequest _self;
  final $Res Function(_UpdateWorkNoteRequest) _then;

/// Create a copy of UpdateWorkNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? expectedRevision = null,}) {
  return _then(_UpdateWorkNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
