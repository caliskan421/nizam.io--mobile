// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revise_meeting_note_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviseMeetingNoteRequest {

/// Not içeriği. Sunucu düz metne indirir; sonuç boş olamaz, kontrol karakteri taşıyamaz ve en çok 5000 karakterdir (Unicode kod noktası/rune, düz metne indirildikten sonra ölçülür); aksi 422 `collaboration.input_invalid` (alan `content`).
 String get content;/// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `collaboration.input_invalid` + `collaboration.revision_required`, pozitif değilse `collaboration.revision_invalid`; bayatsa ve içerik farklıysa 409 `collaboration.edit_conflict`. Tamsayı olmayan değer 422 `collaboration.input_invalid` (alan `body`).
@JsonKey(name: 'expected_revision') int get expectedRevision;
/// Create a copy of ReviseMeetingNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviseMeetingNoteRequestCopyWith<ReviseMeetingNoteRequest> get copyWith => _$ReviseMeetingNoteRequestCopyWithImpl<ReviseMeetingNoteRequest>(this as ReviseMeetingNoteRequest, _$identity);

  /// Serializes this ReviseMeetingNoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviseMeetingNoteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviseMeetingNoteRequest&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.expectedRevision, _this.expectedRevision) || other.expectedRevision == _this.expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviseMeetingNoteRequest;
  return Object.hash(runtimeType,_this.content,_this.expectedRevision);
}

@override
String toString() {
  final _this = this as ReviseMeetingNoteRequest;
  return 'ReviseMeetingNoteRequest(content: ${_this.content}, expectedRevision: ${_this.expectedRevision})';
}


}

/// @nodoc
abstract mixin class $ReviseMeetingNoteRequestCopyWith<$Res>  {
  factory $ReviseMeetingNoteRequestCopyWith(ReviseMeetingNoteRequest value, $Res Function(ReviseMeetingNoteRequest) _then) = _$ReviseMeetingNoteRequestCopyWithImpl;
@useResult
$Res call({
 String content,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class _$ReviseMeetingNoteRequestCopyWithImpl<$Res>
    implements $ReviseMeetingNoteRequestCopyWith<$Res> {
  _$ReviseMeetingNoteRequestCopyWithImpl(this._self, this._then);

  final ReviseMeetingNoteRequest _self;
  final $Res Function(ReviseMeetingNoteRequest) _then;

/// Create a copy of ReviseMeetingNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? expectedRevision = null,}) {
  return _then(ReviseMeetingNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviseMeetingNoteRequest].
extension ReviseMeetingNoteRequestPatterns on ReviseMeetingNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviseMeetingNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviseMeetingNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviseMeetingNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReviseMeetingNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviseMeetingNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReviseMeetingNoteRequest() when $default != null:
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
case _ReviseMeetingNoteRequest() when $default != null:
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
case _ReviseMeetingNoteRequest():
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
case _ReviseMeetingNoteRequest() when $default != null:
return $default(_that.content,_that.expectedRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviseMeetingNoteRequest implements ReviseMeetingNoteRequest {
  const _ReviseMeetingNoteRequest({required this.content, @JsonKey(name: 'expected_revision') required this.expectedRevision});
  factory _ReviseMeetingNoteRequest.fromJson(Map<String, dynamic> json) => _$ReviseMeetingNoteRequestFromJson(json);

/// Not içeriği. Sunucu düz metne indirir; sonuç boş olamaz, kontrol karakteri taşıyamaz ve en çok 5000 karakterdir (Unicode kod noktası/rune, düz metne indirildikten sonra ölçülür); aksi 422 `collaboration.input_invalid` (alan `content`).
@override final  String content;
/// İstemcinin gördüğü not `edit_revision` değeri (ADR-0027). Eksikse 422 `collaboration.input_invalid` + `collaboration.revision_required`, pozitif değilse `collaboration.revision_invalid`; bayatsa ve içerik farklıysa 409 `collaboration.edit_conflict`. Tamsayı olmayan değer 422 `collaboration.input_invalid` (alan `body`).
@override@JsonKey(name: 'expected_revision') final  int expectedRevision;

/// Create a copy of ReviseMeetingNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviseMeetingNoteRequestCopyWith<_ReviseMeetingNoteRequest> get copyWith => __$ReviseMeetingNoteRequestCopyWithImpl<_ReviseMeetingNoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviseMeetingNoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviseMeetingNoteRequest&&(identical(other.content, content) || other.content == content)&&(identical(other.expectedRevision, expectedRevision) || other.expectedRevision == expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,expectedRevision);
}

@override
String toString() {
    return 'ReviseMeetingNoteRequest(content: $content, expectedRevision: $expectedRevision)';
}


}

/// @nodoc
abstract mixin class _$ReviseMeetingNoteRequestCopyWith<$Res> implements $ReviseMeetingNoteRequestCopyWith<$Res> {
  factory _$ReviseMeetingNoteRequestCopyWith(_ReviseMeetingNoteRequest value, $Res Function(_ReviseMeetingNoteRequest) _then) = __$ReviseMeetingNoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String content,@JsonKey(name: 'expected_revision') int expectedRevision
});




}
/// @nodoc
class __$ReviseMeetingNoteRequestCopyWithImpl<$Res>
    implements _$ReviseMeetingNoteRequestCopyWith<$Res> {
  __$ReviseMeetingNoteRequestCopyWithImpl(this._self, this._then);

  final _ReviseMeetingNoteRequest _self;
  final $Res Function(_ReviseMeetingNoteRequest) _then;

/// Create a copy of ReviseMeetingNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? expectedRevision = null,}) {
  return _then(_ReviseMeetingNoteRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: null == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
