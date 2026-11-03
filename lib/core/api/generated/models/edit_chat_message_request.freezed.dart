// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_chat_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditChatMessageRequest {

 String get body;/// İstemcinin gördüğü mesaj `edit_revision` değeri (ADR-0027). Eksikse 422 `messaging.input_invalid` + `messaging.revision_required`, pozitif değilse `messaging.revision_invalid`; bayatsa ve gövde farklıysa 409 `messaging.edit_conflict`. Tamsayı olmayan değer 422 `messaging.input_invalid` (alan `body`).
@JsonKey(name: 'expected_revision') int get expectedRevision;
/// Create a copy of EditChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditChatMessageRequestCopyWith<EditChatMessageRequest> get copyWith => _$EditChatMessageRequestCopyWithImpl<EditChatMessageRequest>(this as EditChatMessageRequest, _$identity);

  /// Serializes this EditChatMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EditChatMessageRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditChatMessageRequest&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.expectedRevision, _this.expectedRevision) || other.expectedRevision == _this.expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EditChatMessageRequest;
  return Object.hash(runtimeType,_this.body,_this.expectedRevision);
}

@override
String toString() {
  final _this = this as EditChatMessageRequest;
  return 'EditChatMessageRequest(body: ${_this.body}, expectedRevision: ${_this.expectedRevision})';
}


}

/// @nodoc
abstract mixin class $EditChatMessageRequestCopyWith<$Res>  {
  factory $EditChatMessageRequestCopyWith(EditChatMessageRequest value, $Res Function(EditChatMessageRequest) _then) = _$EditChatMessageRequestCopyWithImpl;
@useResult
$Res call({
 String body,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class _$EditChatMessageRequestCopyWithImpl<$Res>
    implements $EditChatMessageRequestCopyWith<$Res> {
  _$EditChatMessageRequestCopyWithImpl(this._self, this._then);

  final EditChatMessageRequest _self;
  final $Res Function(EditChatMessageRequest) _then;

/// Create a copy of EditChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? body = null,Object? expectedRevision = null,}) {
  return _then(EditChatMessageRequest(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EditChatMessageRequest].
extension EditChatMessageRequestPatterns on EditChatMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditChatMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditChatMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _EditChatMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditChatMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EditChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String body, @JsonKey(name: 'expected_revision')  int expectedRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditChatMessageRequest() when $default != null:
return $default(_that.body,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String body, @JsonKey(name: 'expected_revision')  int expectedRevision)  $default,) {final _that = this;
switch (_that) {
case _EditChatMessageRequest():
return $default(_that.body,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String body, @JsonKey(name: 'expected_revision')  int expectedRevision)?  $default,) {final _that = this;
switch (_that) {
case _EditChatMessageRequest() when $default != null:
return $default(_that.body,_that.expectedRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditChatMessageRequest implements EditChatMessageRequest {
  const _EditChatMessageRequest({required this.body, @JsonKey(name: 'expected_revision') required this.expectedRevision});
  factory _EditChatMessageRequest.fromJson(Map<String, dynamic> json) => _$EditChatMessageRequestFromJson(json);

@override final  String body;
/// İstemcinin gördüğü mesaj `edit_revision` değeri (ADR-0027). Eksikse 422 `messaging.input_invalid` + `messaging.revision_required`, pozitif değilse `messaging.revision_invalid`; bayatsa ve gövde farklıysa 409 `messaging.edit_conflict`. Tamsayı olmayan değer 422 `messaging.input_invalid` (alan `body`).
@override@JsonKey(name: 'expected_revision') final  int expectedRevision;

/// Create a copy of EditChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditChatMessageRequestCopyWith<_EditChatMessageRequest> get copyWith => __$EditChatMessageRequestCopyWithImpl<_EditChatMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditChatMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditChatMessageRequest&&(identical(other.body, body) || other.body == body)&&(identical(other.expectedRevision, expectedRevision) || other.expectedRevision == expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,body,expectedRevision);
}

@override
String toString() {
    return 'EditChatMessageRequest(body: $body, expectedRevision: $expectedRevision)';
}


}

/// @nodoc
abstract mixin class _$EditChatMessageRequestCopyWith<$Res> implements $EditChatMessageRequestCopyWith<$Res> {
  factory _$EditChatMessageRequestCopyWith(_EditChatMessageRequest value, $Res Function(_EditChatMessageRequest) _then) = __$EditChatMessageRequestCopyWithImpl;
@override @useResult
$Res call({
 String body,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class __$EditChatMessageRequestCopyWithImpl<$Res>
    implements _$EditChatMessageRequestCopyWith<$Res> {
  __$EditChatMessageRequestCopyWithImpl(this._self, this._then);

  final _EditChatMessageRequest _self;
  final $Res Function(_EditChatMessageRequest) _then;

/// Create a copy of EditChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? body = null,Object? expectedRevision = null,}) {
  return _then(_EditChatMessageRequest(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
