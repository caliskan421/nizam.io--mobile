// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatEvent {

@JsonKey(name: 'chat_id') String get chatId;@JsonKey(name: 'message_id') String? get messageId;@JsonKey(name: 'actor_account_id') String get actorAccountId;/// Üyelik/sohbet olayında sohbete giren ve sohbetten düşen hesaplar; diğer olaylarda boş.
@JsonKey(name: 'affected_account_ids') List<String> get affectedAccountIds;
/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatEventCopyWith<ChatEvent> get copyWith => _$ChatEventCopyWithImpl<ChatEvent>(this as ChatEvent, _$identity);

  /// Serializes this ChatEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.actorAccountId, _this.actorAccountId) || other.actorAccountId == _this.actorAccountId)&&const DeepCollectionEquality().equals(other.affectedAccountIds, _this.affectedAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatEvent;
  return Object.hash(runtimeType,_this.chatId,_this.messageId,_this.actorAccountId,const DeepCollectionEquality().hash(_this.affectedAccountIds));
}

@override
String toString() {
  final _this = this as ChatEvent;
  return 'ChatEvent(chatId: ${_this.chatId}, messageId: ${_this.messageId}, actorAccountId: ${_this.actorAccountId}, affectedAccountIds: ${_this.affectedAccountIds})';
}


}

/// @nodoc
abstract mixin class $ChatEventCopyWith<$Res>  {
  factory $ChatEventCopyWith(ChatEvent value, $Res Function(ChatEvent) _then) = _$ChatEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chat_id') String chatId,@JsonKey(name: 'message_id') String? messageId,@JsonKey(name: 'actor_account_id') String actorAccountId,@JsonKey(name: 'affected_account_ids') List<String> affectedAccountIds
});




}
/// @nodoc
class _$ChatEventCopyWithImpl<$Res>
    implements $ChatEventCopyWith<$Res> {
  _$ChatEventCopyWithImpl(this._self, this._then);

  final ChatEvent _self;
  final $Res Function(ChatEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? messageId = freezed,Object? actorAccountId = null,Object? affectedAccountIds = null,}) {
  return _then(ChatEvent(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,actorAccountId: null == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String,affectedAccountIds: null == affectedAccountIds ? _self.affectedAccountIds : affectedAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatEvent value)  $default,){
final _that = this;
switch (_that) {
case _ChatEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ChatEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String? messageId, @JsonKey(name: 'actor_account_id')  String actorAccountId, @JsonKey(name: 'affected_account_ids')  List<String> affectedAccountIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatEvent() when $default != null:
return $default(_that.chatId,_that.messageId,_that.actorAccountId,_that.affectedAccountIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String? messageId, @JsonKey(name: 'actor_account_id')  String actorAccountId, @JsonKey(name: 'affected_account_ids')  List<String> affectedAccountIds)  $default,) {final _that = this;
switch (_that) {
case _ChatEvent():
return $default(_that.chatId,_that.messageId,_that.actorAccountId,_that.affectedAccountIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String? messageId, @JsonKey(name: 'actor_account_id')  String actorAccountId, @JsonKey(name: 'affected_account_ids')  List<String> affectedAccountIds)?  $default,) {final _that = this;
switch (_that) {
case _ChatEvent() when $default != null:
return $default(_that.chatId,_that.messageId,_that.actorAccountId,_that.affectedAccountIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatEvent implements ChatEvent {
  const _ChatEvent({@JsonKey(name: 'chat_id') required this.chatId, @JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'actor_account_id') required this.actorAccountId, @JsonKey(name: 'affected_account_ids') required  List<String> affectedAccountIds}): _affectedAccountIds = affectedAccountIds;
  factory _ChatEvent.fromJson(Map<String, dynamic> json) => _$ChatEventFromJson(json);

@override@JsonKey(name: 'chat_id') final  String chatId;
@override@JsonKey(name: 'message_id') final  String? messageId;
@override@JsonKey(name: 'actor_account_id') final  String actorAccountId;
/// Üyelik/sohbet olayında sohbete giren ve sohbetten düşen hesaplar; diğer olaylarda boş.
 final  List<String> _affectedAccountIds;
/// Üyelik/sohbet olayında sohbete giren ve sohbetten düşen hesaplar; diğer olaylarda boş.
@override@JsonKey(name: 'affected_account_ids') List<String> get affectedAccountIds {
  if (_affectedAccountIds is EqualUnmodifiableListView) return _affectedAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_affectedAccountIds);
}


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatEventCopyWith<_ChatEvent> get copyWith => __$ChatEventCopyWithImpl<_ChatEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatEvent&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&const DeepCollectionEquality().equals(other.affectedAccountIds, _affectedAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatId,messageId,actorAccountId,const DeepCollectionEquality().hash(_affectedAccountIds));
}

@override
String toString() {
    return 'ChatEvent(chatId: $chatId, messageId: $messageId, actorAccountId: $actorAccountId, affectedAccountIds: $affectedAccountIds)';
}


}

/// @nodoc
abstract mixin class _$ChatEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory _$ChatEventCopyWith(_ChatEvent value, $Res Function(_ChatEvent) _then) = __$ChatEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chat_id') String chatId,@JsonKey(name: 'message_id') String? messageId,@JsonKey(name: 'actor_account_id') String actorAccountId,@JsonKey(name: 'affected_account_ids') List<String> affectedAccountIds
});




}
/// @nodoc
class __$ChatEventCopyWithImpl<$Res>
    implements _$ChatEventCopyWith<$Res> {
  __$ChatEventCopyWithImpl(this._self, this._then);

  final _ChatEvent _self;
  final $Res Function(_ChatEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? messageId = freezed,Object? actorAccountId = null,Object? affectedAccountIds = null,}) {
  return _then(_ChatEvent(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,actorAccountId: null == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String,affectedAccountIds: null == affectedAccountIds ? _self._affectedAccountIds : affectedAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
