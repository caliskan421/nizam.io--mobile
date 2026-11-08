// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_chat_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendChatMessageRequest {

/// İstemcinin ürettiği tekrar kimliği; 1–100 bayt yazdırılabilir ASCII, boşluksuz; (sohbet, gönderen) başına tekil.
@JsonKey(name: 'client_message_id') String get clientMessageId;/// Düz metin, en çok 5.000 karakter; kontrol karakteri reddedilir.
 String get body;@JsonKey(name: 'reply_to_message_id') String? get replyToMessageId;/// Yapılandırılmış bahsetme listesi; sunucu metni ayrıştırmaz. En çok 20 (tekrar sessizce.
/// tekilleşir). `account` hedefinin sohbet üyeliği doğrulanmaz (ad çözülmez, rozet yalnız.
/// görünür sohbette); `department` programa bağlı olmalı; `all` yalnız grupta ve yalnız.
/// yönetici/kurucu (birebirde 422 `messaging.input_invalid`, yetkisiz 403.
/// `messaging.not_authorized`). Düzenleme bahsetmeyi değiştirmez.
///
 List<ChatMention>? get mentions;/// Mesajı anket olarak açar (soru = gövde; yalnız grupta, birebirde 422, alan `poll`).
 Poll? get poll;/// Paylaşılan öğeler (görev, koordinatörlük, arşiv dosyası); en çok 10, tekrar tekilleşir.
/// Hedef gönderenin bugünkü yetkisiyle görünür ve sohbetin programında olmalı; aksi tek.
/// 422 `messaging.input_invalid` (`field: refs`) — varlık sızmaz. Denetim gönderim.
/// transaction'ından önce yapılır; aynı istemci kimliğiyle tekrar, referans artık.
/// görünmüyorsa 422 alır (ilk mesaj durur).
///
 List<Refs>? get refs;
/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendChatMessageRequestCopyWith<SendChatMessageRequest> get copyWith => _$SendChatMessageRequestCopyWithImpl<SendChatMessageRequest>(this as SendChatMessageRequest, _$identity);

  /// Serializes this SendChatMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SendChatMessageRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendChatMessageRequest&&(identical(other.clientMessageId, _this.clientMessageId) || other.clientMessageId == _this.clientMessageId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.replyToMessageId, _this.replyToMessageId) || other.replyToMessageId == _this.replyToMessageId)&&const DeepCollectionEquality().equals(other.mentions, _this.mentions)&&(identical(other.poll, _this.poll) || other.poll == _this.poll)&&const DeepCollectionEquality().equals(other.refs, _this.refs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SendChatMessageRequest;
  return Object.hash(runtimeType,_this.clientMessageId,_this.body,_this.replyToMessageId,const DeepCollectionEquality().hash(_this.mentions),_this.poll,const DeepCollectionEquality().hash(_this.refs));
}

@override
String toString() {
  final _this = this as SendChatMessageRequest;
  return 'SendChatMessageRequest(clientMessageId: ${_this.clientMessageId}, body: ${_this.body}, replyToMessageId: ${_this.replyToMessageId}, mentions: ${_this.mentions}, poll: ${_this.poll}, refs: ${_this.refs})';
}


}

/// @nodoc
abstract mixin class $SendChatMessageRequestCopyWith<$Res>  {
  factory $SendChatMessageRequestCopyWith(SendChatMessageRequest value, $Res Function(SendChatMessageRequest) _then) = _$SendChatMessageRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'client_message_id') String clientMessageId, String body,@JsonKey(name: 'reply_to_message_id') String? replyToMessageId, List<ChatMention>? mentions, Poll? poll, List<Refs>? refs
});


$PollCopyWith<$Res>? get poll;

}
/// @nodoc
class _$SendChatMessageRequestCopyWithImpl<$Res>
    implements $SendChatMessageRequestCopyWith<$Res> {
  _$SendChatMessageRequestCopyWithImpl(this._self, this._then);

  final SendChatMessageRequest _self;
  final $Res Function(SendChatMessageRequest) _then;

/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientMessageId = null,Object? body = null,Object? replyToMessageId = freezed,Object? mentions = freezed,Object? poll = freezed,Object? refs = freezed,}) {
  return _then(SendChatMessageRequest(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,mentions: freezed == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<ChatMention>?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as Poll?,refs: freezed == refs ? _self.refs : refs // ignore: cast_nullable_to_non_nullable
as List<Refs>?,
  ));
}
/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollCopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $PollCopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendChatMessageRequest].
extension SendChatMessageRequestPatterns on SendChatMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendChatMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendChatMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _SendChatMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendChatMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SendChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  List<ChatMention>? mentions,  Poll? poll,  List<Refs>? refs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendChatMessageRequest() when $default != null:
return $default(_that.clientMessageId,_that.body,_that.replyToMessageId,_that.mentions,_that.poll,_that.refs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  List<ChatMention>? mentions,  Poll? poll,  List<Refs>? refs)  $default,) {final _that = this;
switch (_that) {
case _SendChatMessageRequest():
return $default(_that.clientMessageId,_that.body,_that.replyToMessageId,_that.mentions,_that.poll,_that.refs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'client_message_id')  String clientMessageId,  String body, @JsonKey(name: 'reply_to_message_id')  String? replyToMessageId,  List<ChatMention>? mentions,  Poll? poll,  List<Refs>? refs)?  $default,) {final _that = this;
switch (_that) {
case _SendChatMessageRequest() when $default != null:
return $default(_that.clientMessageId,_that.body,_that.replyToMessageId,_that.mentions,_that.poll,_that.refs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendChatMessageRequest implements SendChatMessageRequest {
  const _SendChatMessageRequest({@JsonKey(name: 'client_message_id') required this.clientMessageId, required this.body, @JsonKey(name: 'reply_to_message_id') this.replyToMessageId,  List<ChatMention>? mentions, this.poll,  List<Refs>? refs}): _mentions = mentions,_refs = refs;
  factory _SendChatMessageRequest.fromJson(Map<String, dynamic> json) => _$SendChatMessageRequestFromJson(json);

/// İstemcinin ürettiği tekrar kimliği; 1–100 bayt yazdırılabilir ASCII, boşluksuz; (sohbet, gönderen) başına tekil.
@override@JsonKey(name: 'client_message_id') final  String clientMessageId;
/// Düz metin, en çok 5.000 karakter; kontrol karakteri reddedilir.
@override final  String body;
@override@JsonKey(name: 'reply_to_message_id') final  String? replyToMessageId;
/// Yapılandırılmış bahsetme listesi; sunucu metni ayrıştırmaz. En çok 20 (tekrar sessizce.
/// tekilleşir). `account` hedefinin sohbet üyeliği doğrulanmaz (ad çözülmez, rozet yalnız.
/// görünür sohbette); `department` programa bağlı olmalı; `all` yalnız grupta ve yalnız.
/// yönetici/kurucu (birebirde 422 `messaging.input_invalid`, yetkisiz 403.
/// `messaging.not_authorized`). Düzenleme bahsetmeyi değiştirmez.
///
 final  List<ChatMention>? _mentions;
/// Yapılandırılmış bahsetme listesi; sunucu metni ayrıştırmaz. En çok 20 (tekrar sessizce.
/// tekilleşir). `account` hedefinin sohbet üyeliği doğrulanmaz (ad çözülmez, rozet yalnız.
/// görünür sohbette); `department` programa bağlı olmalı; `all` yalnız grupta ve yalnız.
/// yönetici/kurucu (birebirde 422 `messaging.input_invalid`, yetkisiz 403.
/// `messaging.not_authorized`). Düzenleme bahsetmeyi değiştirmez.
///
@override List<ChatMention>? get mentions {
  final value = _mentions;
  if (value == null) return null;
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Mesajı anket olarak açar (soru = gövde; yalnız grupta, birebirde 422, alan `poll`).
@override final  Poll? poll;
/// Paylaşılan öğeler (görev, koordinatörlük, arşiv dosyası); en çok 10, tekrar tekilleşir.
/// Hedef gönderenin bugünkü yetkisiyle görünür ve sohbetin programında olmalı; aksi tek.
/// 422 `messaging.input_invalid` (`field: refs`) — varlık sızmaz. Denetim gönderim.
/// transaction'ından önce yapılır; aynı istemci kimliğiyle tekrar, referans artık.
/// görünmüyorsa 422 alır (ilk mesaj durur).
///
 final  List<Refs>? _refs;
/// Paylaşılan öğeler (görev, koordinatörlük, arşiv dosyası); en çok 10, tekrar tekilleşir.
/// Hedef gönderenin bugünkü yetkisiyle görünür ve sohbetin programında olmalı; aksi tek.
/// 422 `messaging.input_invalid` (`field: refs`) — varlık sızmaz. Denetim gönderim.
/// transaction'ından önce yapılır; aynı istemci kimliğiyle tekrar, referans artık.
/// görünmüyorsa 422 alır (ilk mesaj durur).
///
@override List<Refs>? get refs {
  final value = _refs;
  if (value == null) return null;
  if (_refs is EqualUnmodifiableListView) return _refs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendChatMessageRequestCopyWith<_SendChatMessageRequest> get copyWith => __$SendChatMessageRequestCopyWithImpl<_SendChatMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendChatMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendChatMessageRequest&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.body, body) || other.body == body)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&const DeepCollectionEquality().equals(other.mentions, _mentions)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other.refs, _refs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientMessageId,body,replyToMessageId,const DeepCollectionEquality().hash(_mentions),poll,const DeepCollectionEquality().hash(_refs));
}

@override
String toString() {
    return 'SendChatMessageRequest(clientMessageId: $clientMessageId, body: $body, replyToMessageId: $replyToMessageId, mentions: $mentions, poll: $poll, refs: $refs)';
}


}

/// @nodoc
abstract mixin class _$SendChatMessageRequestCopyWith<$Res> implements $SendChatMessageRequestCopyWith<$Res> {
  factory _$SendChatMessageRequestCopyWith(_SendChatMessageRequest value, $Res Function(_SendChatMessageRequest) _then) = __$SendChatMessageRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'client_message_id') String clientMessageId, String body,@JsonKey(name: 'reply_to_message_id') String? replyToMessageId, List<ChatMention>? mentions, Poll? poll, List<Refs>? refs
});


@override $PollCopyWith<$Res>? get poll;

}
/// @nodoc
class __$SendChatMessageRequestCopyWithImpl<$Res>
    implements _$SendChatMessageRequestCopyWith<$Res> {
  __$SendChatMessageRequestCopyWithImpl(this._self, this._then);

  final _SendChatMessageRequest _self;
  final $Res Function(_SendChatMessageRequest) _then;

/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientMessageId = null,Object? body = null,Object? replyToMessageId = freezed,Object? mentions = freezed,Object? poll = freezed,Object? refs = freezed,}) {
  return _then(_SendChatMessageRequest(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,mentions: freezed == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<ChatMention>?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as Poll?,refs: freezed == refs ? _self._refs : refs // ignore: cast_nullable_to_non_nullable
as List<Refs>?,
  ));
}

/// Create a copy of SendChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollCopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $PollCopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}
}

// dart format on
