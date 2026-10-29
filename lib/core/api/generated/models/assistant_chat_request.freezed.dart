// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_chat_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantChatRequest {

/// Soru metni (boş olamaz; uzunluk sınırı domain kuralıdır).
 String get soru;/// Devam ettirilecek sohbet; boşsa yeni sohbet açılır.
@JsonKey(name: 'sohbet_id') String? get sohbetId;
/// Create a copy of AssistantChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantChatRequestCopyWith<AssistantChatRequest> get copyWith => _$AssistantChatRequestCopyWithImpl<AssistantChatRequest>(this as AssistantChatRequest, _$identity);

  /// Serializes this AssistantChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantChatRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantChatRequest&&(identical(other.soru, _this.soru) || other.soru == _this.soru)&&(identical(other.sohbetId, _this.sohbetId) || other.sohbetId == _this.sohbetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantChatRequest;
  return Object.hash(runtimeType,_this.soru,_this.sohbetId);
}

@override
String toString() {
  final _this = this as AssistantChatRequest;
  return 'AssistantChatRequest(soru: ${_this.soru}, sohbetId: ${_this.sohbetId})';
}


}

/// @nodoc
abstract mixin class $AssistantChatRequestCopyWith<$Res>  {
  factory $AssistantChatRequestCopyWith(AssistantChatRequest value, $Res Function(AssistantChatRequest) _then) = _$AssistantChatRequestCopyWithImpl;
@useResult
$Res call({
 String soru,@JsonKey(name: 'sohbet_id') String? sohbetId
});




}
/// @nodoc
class _$AssistantChatRequestCopyWithImpl<$Res>
    implements $AssistantChatRequestCopyWith<$Res> {
  _$AssistantChatRequestCopyWithImpl(this._self, this._then);

  final AssistantChatRequest _self;
  final $Res Function(AssistantChatRequest) _then;

/// Create a copy of AssistantChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soru = null,Object? sohbetId = freezed,}) {
  return _then(AssistantChatRequest(
soru: null == soru ? _self.soru : soru // ignore: cast_nullable_to_non_nullable
as String,sohbetId: freezed == sohbetId ? _self.sohbetId : sohbetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantChatRequest].
extension AssistantChatRequestPatterns on AssistantChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _AssistantChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String soru, @JsonKey(name: 'sohbet_id')  String? sohbetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantChatRequest() when $default != null:
return $default(_that.soru,_that.sohbetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String soru, @JsonKey(name: 'sohbet_id')  String? sohbetId)  $default,) {final _that = this;
switch (_that) {
case _AssistantChatRequest():
return $default(_that.soru,_that.sohbetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String soru, @JsonKey(name: 'sohbet_id')  String? sohbetId)?  $default,) {final _that = this;
switch (_that) {
case _AssistantChatRequest() when $default != null:
return $default(_that.soru,_that.sohbetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantChatRequest implements AssistantChatRequest {
  const _AssistantChatRequest({required this.soru, @JsonKey(name: 'sohbet_id') this.sohbetId});
  factory _AssistantChatRequest.fromJson(Map<String, dynamic> json) => _$AssistantChatRequestFromJson(json);

/// Soru metni (boş olamaz; uzunluk sınırı domain kuralıdır).
@override final  String soru;
/// Devam ettirilecek sohbet; boşsa yeni sohbet açılır.
@override@JsonKey(name: 'sohbet_id') final  String? sohbetId;

/// Create a copy of AssistantChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantChatRequestCopyWith<_AssistantChatRequest> get copyWith => __$AssistantChatRequestCopyWithImpl<_AssistantChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantChatRequest&&(identical(other.soru, soru) || other.soru == soru)&&(identical(other.sohbetId, sohbetId) || other.sohbetId == sohbetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,soru,sohbetId);
}

@override
String toString() {
    return 'AssistantChatRequest(soru: $soru, sohbetId: $sohbetId)';
}


}

/// @nodoc
abstract mixin class _$AssistantChatRequestCopyWith<$Res> implements $AssistantChatRequestCopyWith<$Res> {
  factory _$AssistantChatRequestCopyWith(_AssistantChatRequest value, $Res Function(_AssistantChatRequest) _then) = __$AssistantChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String soru,@JsonKey(name: 'sohbet_id') String? sohbetId
});




}
/// @nodoc
class __$AssistantChatRequestCopyWithImpl<$Res>
    implements _$AssistantChatRequestCopyWith<$Res> {
  __$AssistantChatRequestCopyWithImpl(this._self, this._then);

  final _AssistantChatRequest _self;
  final $Res Function(_AssistantChatRequest) _then;

/// Create a copy of AssistantChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soru = null,Object? sohbetId = freezed,}) {
  return _then(_AssistantChatRequest(
soru: null == soru ? _self.soru : soru // ignore: cast_nullable_to_non_nullable
as String,sohbetId: freezed == sohbetId ? _self.sohbetId : sohbetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
