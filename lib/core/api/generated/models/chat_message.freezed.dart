// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {

@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'chat_id') String get chatId; int get seq;@JsonKey(name: 'sender_account_id') String get senderAccountId;@JsonKey(name: 'client_message_id') String get clientMessageId; String get body;@JsonKey(name: 'reply_to_message_id') String? get replyToMessageId; bool get edited;@JsonKey(name: 'edited_at') DateTime? get editedAt;@JsonKey(name: 'created_at') DateTime get createdAt;/// Gönderimdeki bahsetmeler (düzenleme değiştirmez); ad çözülmez.
 List<ChatMention> get mentions;/// Paylaşılan öğeler (statik); kart `GET /v1/chat-refs/{refId}` ile okunur.
 List<ChatMessageRef> get refs;/// Bu mesajdan açılan görevler.
@JsonKey(name: 'task_ids') List<String> get taskIds;/// Tür başına tepki sayısı; tepki edenler gösterilmez.
 List<Reactions> get reactions;@JsonKey(name: 'pinned_at') DateTime? get pinnedAt;/// Anket (soru mesaj gövdesidir); sonuçta oy verenler görünür.
 Poll2? get poll; List<Attachments> get attachments;/// Gövdenin düzenleme sürümü (ADR-0027); tombstone, sabitleme ve tepki artırmaz.
@JsonKey(name: 'edit_revision') int get editRevision;/// Yalnız geçmiş cevabında.
@JsonKey(name: 'sender_name') String? get senderName;@JsonKey(name: 'reply_to') ChatMessageQuote? get replyTo;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.clientMessageId, _this.clientMessageId) || other.clientMessageId == _this.clientMessageId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.replyToMessageId, _this.replyToMessageId) || other.replyToMessageId == _this.replyToMessageId)&&(identical(other.edited, _this.edited) || other.edited == _this.edited)&&(identical(other.editedAt, _this.editedAt) || other.editedAt == _this.editedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.mentions, _this.mentions)&&const DeepCollectionEquality().equals(other.refs, _this.refs)&&const DeepCollectionEquality().equals(other.taskIds, _this.taskIds)&&const DeepCollectionEquality().equals(other.reactions, _this.reactions)&&(identical(other.pinnedAt, _this.pinnedAt) || other.pinnedAt == _this.pinnedAt)&&(identical(other.poll, _this.poll) || other.poll == _this.poll)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments)&&(identical(other.editRevision, _this.editRevision) || other.editRevision == _this.editRevision)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.replyTo, _this.replyTo) || other.replyTo == _this.replyTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hashAll([runtimeType,_this.messageId,_this.chatId,_this.seq,_this.senderAccountId,_this.clientMessageId,_this.body,_this.replyToMessageId,_this.edited,_this.editedAt,_this.createdAt,const DeepCollectionEquality().hash(_this.mentions),const DeepCollectionEquality().hash(_this.refs),const DeepCollectionEquality().hash(_this.taskIds),const DeepCollectionEquality().hash(_this.reactions),_this.pinnedAt,_this.poll,const DeepCollectionEquality().hash(_this.attachments),_this.editRevision,_this.senderName,_this.replyTo]);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(messageId: ${_this.messageId}, chatId: ${_this.chatId}, seq: ${_this.seq}, senderAccountId: ${_this.senderAccountId}, clientMessageId: ${_this.clientMessageId}, body: ${_this.body}, replyToMessageId: ${_this.replyToMessageId}, edited: ${_this.edited}, editedAt: ${_this.editedAt}, createdAt: ${_this.createdAt}, mentions: ${_this.mentions}, refs: ${_this.refs}, taskIds: ${_this.taskIds}, reactions: ${_this.reactions}, pinnedAt: ${_this.pinnedAt}, poll: ${_this.poll}, attachments: ${_this.attachments}, editRevision: ${_this.editRevision}, senderName: ${_this.senderName}, replyTo: ${_this.replyTo})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'chat_id') String chatId, int seq,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'client_message_id') String clientMessageId, String body,@JsonKey(name: 'reply_to_message_id') String? replyToMessageId, bool edited,@JsonKey(name: 'edited_at') DateTime? editedAt,@JsonKey(name: 'created_at') DateTime createdAt, List<ChatMention> mentions, List<ChatMessageRef> refs,@JsonKey(name: 'task_ids') List<String> taskIds, List<Reactions> reactions,@JsonKey(name: 'pinned_at') DateTime? pinnedAt, Poll2? poll, List<Attachments> attachments,@JsonKey(name: 'edit_revision') int editRevision,@JsonKey(name: 'sender_name') String? senderName,@JsonKey(name: 'reply_to') ChatMessageQuote? replyTo
});


$Poll2CopyWith<$Res>? get poll;$ChatMessageQuoteCopyWith<$Res>? get replyTo;

}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? chatId = null,Object? seq = null,Object? senderAccountId = null,Object? clientMessageId = null,Object? body = null,Object? replyToMessageId = freezed,Object? edited = null,Object? editedAt = freezed,Object? createdAt = null,Object? mentions = null,Object? refs = null,Object? taskIds = null,Object? reactions = null,Object? pinnedAt = freezed,Object? poll = freezed,Object? attachments = null,Object? editRevision = null,Object? senderName = freezed,Object? replyTo = freezed,}) {
  return _then(ChatMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<ChatMention>,refs: null == refs ? _self.refs : refs // ignore: cast_nullable_to_non_nullable
as List<ChatMessageRef>,taskIds: null == taskIds ? _self.taskIds : taskIds // ignore: cast_nullable_to_non_nullable
as List<String>,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reactions>,pinnedAt: freezed == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as Poll2?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachments>,editRevision: null == editRevision ? _self.editRevision : editRevision // ignore: cast_nullable_to_non_nullable
as int,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ChatMessageQuote?,
  ));
}
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Poll2CopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $Poll2CopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageQuoteCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ChatMessageQuoteCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'chat_id')  String chatId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  bool edited, @JsonKey(name: 'edited_at')  DateTime? editedAt, @JsonKey(name: 'created_at')  DateTime createdAt,  List<ChatMention> mentions,  List<ChatMessageRef> refs, @JsonKey(name: 'task_ids')  List<String> taskIds,  List<Reactions> reactions, @JsonKey(name: 'pinned_at')  DateTime? pinnedAt,  Poll2? poll,  List<Attachments> attachments, @JsonKey(name: 'edit_revision')  int editRevision, @JsonKey(name: 'sender_name')  String? senderName, @JsonKey(name: 'reply_to')  ChatMessageQuote? replyTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.chatId,_that.seq,_that.senderAccountId,_that.clientMessageId,_that.body,_that.replyToMessageId,_that.edited,_that.editedAt,_that.createdAt,_that.mentions,_that.refs,_that.taskIds,_that.reactions,_that.pinnedAt,_that.poll,_that.attachments,_that.editRevision,_that.senderName,_that.replyTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'chat_id')  String chatId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  bool edited, @JsonKey(name: 'edited_at')  DateTime? editedAt, @JsonKey(name: 'created_at')  DateTime createdAt,  List<ChatMention> mentions,  List<ChatMessageRef> refs, @JsonKey(name: 'task_ids')  List<String> taskIds,  List<Reactions> reactions, @JsonKey(name: 'pinned_at')  DateTime? pinnedAt,  Poll2? poll,  List<Attachments> attachments, @JsonKey(name: 'edit_revision')  int editRevision, @JsonKey(name: 'sender_name')  String? senderName, @JsonKey(name: 'reply_to')  ChatMessageQuote? replyTo)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.messageId,_that.chatId,_that.seq,_that.senderAccountId,_that.clientMessageId,_that.body,_that.replyToMessageId,_that.edited,_that.editedAt,_that.createdAt,_that.mentions,_that.refs,_that.taskIds,_that.reactions,_that.pinnedAt,_that.poll,_that.attachments,_that.editRevision,_that.senderName,_that.replyTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'chat_id')  String chatId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  bool edited, @JsonKey(name: 'edited_at')  DateTime? editedAt, @JsonKey(name: 'created_at')  DateTime createdAt,  List<ChatMention> mentions,  List<ChatMessageRef> refs, @JsonKey(name: 'task_ids')  List<String> taskIds,  List<Reactions> reactions, @JsonKey(name: 'pinned_at')  DateTime? pinnedAt,  Poll2? poll,  List<Attachments> attachments, @JsonKey(name: 'edit_revision')  int editRevision, @JsonKey(name: 'sender_name')  String? senderName, @JsonKey(name: 'reply_to')  ChatMessageQuote? replyTo)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.chatId,_that.seq,_that.senderAccountId,_that.clientMessageId,_that.body,_that.replyToMessageId,_that.edited,_that.editedAt,_that.createdAt,_that.mentions,_that.refs,_that.taskIds,_that.reactions,_that.pinnedAt,_that.poll,_that.attachments,_that.editRevision,_that.senderName,_that.replyTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'chat_id') required this.chatId, required this.seq, @JsonKey(name: 'sender_account_id') required this.senderAccountId, @JsonKey(name: 'client_message_id') required this.clientMessageId, required this.body, @JsonKey(name: 'reply_to_message_id') required this.replyToMessageId, required this.edited, @JsonKey(name: 'edited_at') required this.editedAt, @JsonKey(name: 'created_at') required this.createdAt, required  List<ChatMention> mentions, required  List<ChatMessageRef> refs, @JsonKey(name: 'task_ids') required  List<String> taskIds, required  List<Reactions> reactions, @JsonKey(name: 'pinned_at') required this.pinnedAt, required this.poll, required  List<Attachments> attachments, @JsonKey(name: 'edit_revision') required this.editRevision, @JsonKey(name: 'sender_name') this.senderName, @JsonKey(name: 'reply_to') this.replyTo}): _mentions = mentions,_refs = refs,_taskIds = taskIds,_reactions = reactions,_attachments = attachments;
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'chat_id') final  String chatId;
@override final  int seq;
@override@JsonKey(name: 'sender_account_id') final  String senderAccountId;
@override@JsonKey(name: 'client_message_id') final  String clientMessageId;
@override final  String body;
@override@JsonKey(name: 'reply_to_message_id') final  String? replyToMessageId;
@override final  bool edited;
@override@JsonKey(name: 'edited_at') final  DateTime? editedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
/// Gönderimdeki bahsetmeler (düzenleme değiştirmez); ad çözülmez.
 final  List<ChatMention> _mentions;
/// Gönderimdeki bahsetmeler (düzenleme değiştirmez); ad çözülmez.
@override List<ChatMention> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}

/// Paylaşılan öğeler (statik); kart `GET /v1/chat-refs/{refId}` ile okunur.
 final  List<ChatMessageRef> _refs;
/// Paylaşılan öğeler (statik); kart `GET /v1/chat-refs/{refId}` ile okunur.
@override List<ChatMessageRef> get refs {
  if (_refs is EqualUnmodifiableListView) return _refs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_refs);
}

/// Bu mesajdan açılan görevler.
 final  List<String> _taskIds;
/// Bu mesajdan açılan görevler.
@override@JsonKey(name: 'task_ids') List<String> get taskIds {
  if (_taskIds is EqualUnmodifiableListView) return _taskIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taskIds);
}

/// Tür başına tepki sayısı; tepki edenler gösterilmez.
 final  List<Reactions> _reactions;
/// Tür başına tepki sayısı; tepki edenler gösterilmez.
@override List<Reactions> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}

@override@JsonKey(name: 'pinned_at') final  DateTime? pinnedAt;
/// Anket (soru mesaj gövdesidir); sonuçta oy verenler görünür.
@override final  Poll2? poll;
 final  List<Attachments> _attachments;
@override List<Attachments> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

/// Gövdenin düzenleme sürümü (ADR-0027); tombstone, sabitleme ve tepki artırmaz.
@override@JsonKey(name: 'edit_revision') final  int editRevision;
/// Yalnız geçmiş cevabında.
@override@JsonKey(name: 'sender_name') final  String? senderName;
@override@JsonKey(name: 'reply_to') final  ChatMessageQuote? replyTo;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.body, body) || other.body == body)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.mentions, _mentions)&&const DeepCollectionEquality().equals(other.refs, _refs)&&const DeepCollectionEquality().equals(other.taskIds, _taskIds)&&const DeepCollectionEquality().equals(other.reactions, _reactions)&&(identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other.attachments, _attachments)&&(identical(other.editRevision, editRevision) || other.editRevision == editRevision)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,messageId,chatId,seq,senderAccountId,clientMessageId,body,replyToMessageId,edited,editedAt,createdAt,const DeepCollectionEquality().hash(_mentions),const DeepCollectionEquality().hash(_refs),const DeepCollectionEquality().hash(_taskIds),const DeepCollectionEquality().hash(_reactions),pinnedAt,poll,const DeepCollectionEquality().hash(_attachments),editRevision,senderName,replyTo]);
}

@override
String toString() {
    return 'ChatMessage(messageId: $messageId, chatId: $chatId, seq: $seq, senderAccountId: $senderAccountId, clientMessageId: $clientMessageId, body: $body, replyToMessageId: $replyToMessageId, edited: $edited, editedAt: $editedAt, createdAt: $createdAt, mentions: $mentions, refs: $refs, taskIds: $taskIds, reactions: $reactions, pinnedAt: $pinnedAt, poll: $poll, attachments: $attachments, editRevision: $editRevision, senderName: $senderName, replyTo: $replyTo)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'chat_id') String chatId, int seq,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'client_message_id') String clientMessageId, String body,@JsonKey(name: 'reply_to_message_id') String? replyToMessageId, bool edited,@JsonKey(name: 'edited_at') DateTime? editedAt,@JsonKey(name: 'created_at') DateTime createdAt, List<ChatMention> mentions, List<ChatMessageRef> refs,@JsonKey(name: 'task_ids') List<String> taskIds, List<Reactions> reactions,@JsonKey(name: 'pinned_at') DateTime? pinnedAt, Poll2? poll, List<Attachments> attachments,@JsonKey(name: 'edit_revision') int editRevision,@JsonKey(name: 'sender_name') String? senderName,@JsonKey(name: 'reply_to') ChatMessageQuote? replyTo
});


@override $Poll2CopyWith<$Res>? get poll;@override $ChatMessageQuoteCopyWith<$Res>? get replyTo;

}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? chatId = null,Object? seq = null,Object? senderAccountId = null,Object? clientMessageId = null,Object? body = null,Object? replyToMessageId = freezed,Object? edited = null,Object? editedAt = freezed,Object? createdAt = null,Object? mentions = null,Object? refs = null,Object? taskIds = null,Object? reactions = null,Object? pinnedAt = freezed,Object? poll = freezed,Object? attachments = null,Object? editRevision = null,Object? senderName = freezed,Object? replyTo = freezed,}) {
  return _then(_ChatMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<ChatMention>,refs: null == refs ? _self._refs : refs // ignore: cast_nullable_to_non_nullable
as List<ChatMessageRef>,taskIds: null == taskIds ? _self._taskIds : taskIds // ignore: cast_nullable_to_non_nullable
as List<String>,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reactions>,pinnedAt: freezed == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as Poll2?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachments>,editRevision: null == editRevision ? _self.editRevision : editRevision // ignore: cast_nullable_to_non_nullable
as int,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ChatMessageQuote?,
  ));
}

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Poll2CopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $Poll2CopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageQuoteCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ChatMessageQuoteCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}

// dart format on
