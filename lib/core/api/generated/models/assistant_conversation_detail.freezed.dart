// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_conversation_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantConversationDetail {

 AssistantConversation get conversation; List<AssistantMessage> get messages;
/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantConversationDetailCopyWith<AssistantConversationDetail> get copyWith => _$AssistantConversationDetailCopyWithImpl<AssistantConversationDetail>(this as AssistantConversationDetail, _$identity);

  /// Serializes this AssistantConversationDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantConversationDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantConversationDetail&&(identical(other.conversation, _this.conversation) || other.conversation == _this.conversation)&&const DeepCollectionEquality().equals(other.messages, _this.messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantConversationDetail;
  return Object.hash(runtimeType,_this.conversation,const DeepCollectionEquality().hash(_this.messages));
}

@override
String toString() {
  final _this = this as AssistantConversationDetail;
  return 'AssistantConversationDetail(conversation: ${_this.conversation}, messages: ${_this.messages})';
}


}

/// @nodoc
abstract mixin class $AssistantConversationDetailCopyWith<$Res>  {
  factory $AssistantConversationDetailCopyWith(AssistantConversationDetail value, $Res Function(AssistantConversationDetail) _then) = _$AssistantConversationDetailCopyWithImpl;
@useResult
$Res call({
 AssistantConversation conversation, List<AssistantMessage> messages
});


$AssistantConversationCopyWith<$Res> get conversation;

}
/// @nodoc
class _$AssistantConversationDetailCopyWithImpl<$Res>
    implements $AssistantConversationDetailCopyWith<$Res> {
  _$AssistantConversationDetailCopyWithImpl(this._self, this._then);

  final AssistantConversationDetail _self;
  final $Res Function(AssistantConversationDetail) _then;

/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversation = null,Object? messages = null,}) {
  return _then(AssistantConversationDetail(
conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as AssistantConversation,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AssistantMessage>,
  ));
}
/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssistantConversationCopyWith<$Res> get conversation {
  
  return $AssistantConversationCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssistantConversationDetail].
extension AssistantConversationDetailPatterns on AssistantConversationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantConversationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantConversationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantConversationDetail value)  $default,){
final _that = this;
switch (_that) {
case _AssistantConversationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantConversationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantConversationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssistantConversation conversation,  List<AssistantMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantConversationDetail() when $default != null:
return $default(_that.conversation,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssistantConversation conversation,  List<AssistantMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _AssistantConversationDetail():
return $default(_that.conversation,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssistantConversation conversation,  List<AssistantMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _AssistantConversationDetail() when $default != null:
return $default(_that.conversation,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantConversationDetail implements AssistantConversationDetail {
  const _AssistantConversationDetail({required this.conversation, required  List<AssistantMessage> messages}): _messages = messages;
  factory _AssistantConversationDetail.fromJson(Map<String, dynamic> json) => _$AssistantConversationDetailFromJson(json);

@override final  AssistantConversation conversation;
 final  List<AssistantMessage> _messages;
@override List<AssistantMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantConversationDetailCopyWith<_AssistantConversationDetail> get copyWith => __$AssistantConversationDetailCopyWithImpl<_AssistantConversationDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantConversationDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantConversationDetail&&(identical(other.conversation, conversation) || other.conversation == conversation)&&const DeepCollectionEquality().equals(other.messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,conversation,const DeepCollectionEquality().hash(_messages));
}

@override
String toString() {
    return 'AssistantConversationDetail(conversation: $conversation, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$AssistantConversationDetailCopyWith<$Res> implements $AssistantConversationDetailCopyWith<$Res> {
  factory _$AssistantConversationDetailCopyWith(_AssistantConversationDetail value, $Res Function(_AssistantConversationDetail) _then) = __$AssistantConversationDetailCopyWithImpl;
@override @useResult
$Res call({
 AssistantConversation conversation, List<AssistantMessage> messages
});


@override $AssistantConversationCopyWith<$Res> get conversation;

}
/// @nodoc
class __$AssistantConversationDetailCopyWithImpl<$Res>
    implements _$AssistantConversationDetailCopyWith<$Res> {
  __$AssistantConversationDetailCopyWithImpl(this._self, this._then);

  final _AssistantConversationDetail _self;
  final $Res Function(_AssistantConversationDetail) _then;

/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversation = null,Object? messages = null,}) {
  return _then(_AssistantConversationDetail(
conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as AssistantConversation,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AssistantMessage>,
  ));
}

/// Create a copy of AssistantConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssistantConversationCopyWith<$Res> get conversation {
  
  return $AssistantConversationCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}

// dart format on
